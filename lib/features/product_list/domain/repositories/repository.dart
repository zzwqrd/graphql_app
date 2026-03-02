import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<Either<HelperResponse, ProductListResponse>> getProducts(
    String categoryUid, {
    Map<String, List<String>>? filters,
    SortOption? sortOption,
    String? searchQuery,
    int page = 1,
  });
}
