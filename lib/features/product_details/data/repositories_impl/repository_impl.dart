import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/product_details_model.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final _remoteDataSource = ProductDetailsRemoteDataSource();

  @override
  Future<Either<HelperResponse, ProductDetailsModel>> getProductDetails(
    String sku,
  ) async {
    final result = await _remoteDataSource.getProductDetails(sku);
    return result.fold((error) => Left(error), (response) {
      if (response.items.isNotEmpty) {
        return Right(response.items.first);
      } else {
        return Left(HelperResponse.notFound(message: 'Product not found'));
      }
    });
  }
}
