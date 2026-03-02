import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/product_details_model.dart';
import '../../data/repositories_impl/repository_impl.dart';
import '../repositories/repository.dart';

abstract class GetProductDetailsUseCase {
  Future<Either<HelperResponse, ProductDetailsModel>> call(String sku);
}

class GetProductDetailsUseCaseImpl implements GetProductDetailsUseCase {
  final ProductDetailsRepository _repository = ProductDetailsRepositoryImpl();

  @override
  Future<Either<HelperResponse, ProductDetailsModel>> call(String sku) async {
    return await _repository.getProductDetails(sku);
  }
}
