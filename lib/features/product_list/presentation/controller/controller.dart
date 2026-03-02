import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../data/models/product_model.dart';
import 'state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final GetProductsUseCase _getProductsUseCase = GetProductsUseCaseImpl();

  ProductListCubit() : super(ProductListState());

  String? _categoryUid;

  Future<void> getProducts(
    String categoryUid, {
    SortOption? initialSort,
  }) async {
    if (isClosed) return;
    _categoryUid = categoryUid;
    if (initialSort != null) {
      emit(state.copyWith(sortOption: initialSort));
    }
    await _fetchProducts();
  }

  Future<void> _fetchProducts({bool isLoadMore = false}) async {
    if (isClosed) return;
    if (_categoryUid == null) return;
    if (isLoadMore && state.hasReachedMax) return;

    if (!isLoadMore) {
      emit(
        state.copyWith(
          requestState: RequestState.loading,
          page: 1,
          hasReachedMax: false,
          allProducts: [],
        ),
      );
    }

    final result = await _getProductsUseCase.call(
      _categoryUid!,
      filters: state.activeFilters,
      sortOption: state.sortOption,
      searchQuery: state.searchQuery,
      page: state.page,
    );

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              requestState: RequestState.error,
              msg: error.message,
            ),
          );
        }
      },
      (data) {
        if (!isClosed) {
          final List<ProductModel> newProducts = isLoadMore
              ? [...state.allProducts, ...data.items]
              : data.items;

          emit(
            state.copyWith(
              requestState: RequestState.done,
              allProducts: newProducts,
              displayedProducts: newProducts,
              aggregations: data.aggregations,
              page: state.page + 1,
              hasReachedMax:
                  data.items.isEmpty ||
                  data.items.length < 20, // Assuming page size 20
            ),
          );
        }
      },
    );
  }

  void loadMore() {
    if (isClosed) return;
    if (state.requestState != RequestState.loading && !state.hasReachedMax) {
      _fetchProducts(isLoadMore: true);
    }
  }

  void search(String query) {
    if (isClosed) return;
    emit(state.copyWith(searchQuery: query));
    _fetchProducts();
  }

  void sort(SortOption option) {
    if (isClosed) return;
    emit(state.copyWith(sortOption: option));
    _fetchProducts();
  }

  void filter(Map<String, List<String>> filters) {
    if (isClosed) return;
    emit(state.copyWith(activeFilters: filters));
    _fetchProducts();
  }
}
