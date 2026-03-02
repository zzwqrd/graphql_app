import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/models.dart';
import '../../domain/usecases/usecases.dart';
import 'state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase = GetCategoriesUseCaseImpl();

  CategoryCubit() : super(CategoryState());

  Future<void> getCategories() async {
    if (state.categories == null) {
      emit(state.copyWith(requestState: RequestState.loading));
    }
    final result = await getCategoriesUseCase.call();

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              requestState: RequestState.error,
              msg: error.message,
              errorType: error.errorType,
            ),
          );
        }
      },
      (data) {
        final sidebarCategories = data.items.isNotEmpty
            ? data.items.first.children
            : <CategoryItem>[];

        if (!isClosed) {
          emit(
            state.copyWith(
              requestState: RequestState.done,
              categories: data,
              sidebarCategories: sidebarCategories,
            ),
          );
        }

        if (sidebarCategories.isNotEmpty) {
          selectCategory(sidebarCategories.first);
        }
      },
    );
  }

  Future<void> selectCategory(CategoryItem category) async {
    emit(
      state.copyWith(
        selectedCategory: category,
        productRequestState: RequestState.loading,
      ),
    );

    final result = await getCategoriesUseCase.getCategoryById(category.uid);

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              productRequestState: RequestState.error,
              msg: error.message,
              errorType: error.errorType,
            ),
          );
        }
      },
      (data) {
        if (data.items.isNotEmpty) {
          if (!isClosed) {
            emit(
              state.copyWith(
                selectedCategory: data.items.first,
                productRequestState: RequestState.done,
              ),
            );
          }
        } else {
          if (!isClosed) {
            emit(state.copyWith(productRequestState: RequestState.done));
          }
        }
      },
    );
  }
}
