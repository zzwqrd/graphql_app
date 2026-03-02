import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final _remoteDataSource = ProductRemoteDataSource();

  @override
  Future<Either<HelperResponse, ProductListResponse>> getProducts(
    String categoryUid, {
    Map<String, List<String>>? filters,
    SortOption? sortOption,
    String? searchQuery,
    int page = 1,
  }) async {
    return await _remoteDataSource.getProducts(
      categoryUid,
      filters: filters,
      sortOption: sortOption,
      searchQuery: searchQuery,
      page: page,
    );
  }
}
