import '../../../../../core/utils/enums.dart';
import '../../data/models/models.dart';

class CategoryState {
  final RequestState requestState;
  final String msg;
  final ErrorRequestType errorType;
  final ModelsCategories? categories;
  final List<CategoryItem> sidebarCategories;
  final CategoryItem? selectedCategory;
  final RequestState productRequestState;

  CategoryState({
    this.requestState = RequestState.initial,
    this.productRequestState = RequestState.initial,
    this.msg = '',
    this.errorType = ErrorRequestType.unknown,
    this.categories,
    this.sidebarCategories = const [],
    this.selectedCategory,
  });

  CategoryState copyWith({
    RequestState? requestState,
    RequestState? productRequestState,
    String? msg,
    ErrorRequestType? errorType,
    ModelsCategories? categories,
    List<CategoryItem>? sidebarCategories,
    CategoryItem? selectedCategory,
  }) => CategoryState(
    requestState: requestState ?? this.requestState,
    productRequestState: productRequestState ?? this.productRequestState,
    msg: msg ?? this.msg,
    errorType: errorType ?? this.errorType,
    categories: categories ?? this.categories,
    sidebarCategories: sidebarCategories ?? this.sidebarCategories,
    selectedCategory: selectedCategory ?? this.selectedCategory,
  );
}
