import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories_impl/repository_impl.dart';

abstract class GetProductsUseCase {
  Future<Either<HelperResponse, ProductListResponse>> call(
    String categoryUid, {
    Map<String, List<String>>? filters,
    SortOption? sortOption,
    String? searchQuery,
    int page = 1,
  });
}

class GetProductsUseCaseImpl implements GetProductsUseCase {
  final _repository = ProductRepositoryImpl();

  @override
  Future<Either<HelperResponse, ProductListResponse>> call(
    String categoryUid, {
    Map<String, List<String>>? filters,
    SortOption? sortOption,
    String? searchQuery,
    int page = 1,
  }) async {
    return await _repository.getProducts(
      categoryUid,
      filters: filters,
      sortOption: sortOption,
      searchQuery: searchQuery,
      page: page,
    );
  }
}
