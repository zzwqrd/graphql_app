import '../../../../../core/utils/enums.dart';
import '../../data/models/product_model.dart';

class ProductListState {
  final RequestState requestState;
  final String msg;
  final List<ProductModel> allProducts; // Store all fetched products
  final List<ProductModel> displayedProducts; // Store filtered/sorted products
  final List<Aggregation> aggregations;
  final Map<String, List<String>>
  activeFilters; // attribute_code -> list of values
  final SortOption? sortOption;
  final String searchQuery;
  final int page;
  final bool hasReachedMax;

  ProductListState({
    this.requestState = RequestState.initial,
    this.msg = '',
    this.allProducts = const [],
    this.displayedProducts = const [],
    this.aggregations = const [],
    this.activeFilters = const {},
    this.sortOption,
    this.searchQuery = '',
    this.page = 1,
    this.hasReachedMax = false,
  });

  ProductListState copyWith({
    RequestState? requestState,
    String? msg,
    List<ProductModel>? allProducts,
    List<ProductModel>? displayedProducts,
    List<Aggregation>? aggregations,
    Map<String, List<String>>? activeFilters,
    SortOption? sortOption,
    String? searchQuery,
    int? page,
    bool? hasReachedMax,
  }) => ProductListState(
    requestState: requestState ?? this.requestState,
    msg: msg ?? this.msg,
    allProducts: allProducts ?? this.allProducts,
    displayedProducts: displayedProducts ?? this.displayedProducts,
    aggregations: aggregations ?? this.aggregations,
    activeFilters: activeFilters ?? this.activeFilters,
    sortOption: sortOption ?? this.sortOption,
    searchQuery: searchQuery ?? this.searchQuery,
    page: page ?? this.page,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
  );
}
