import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/product_details_model.dart';

abstract class ProductDetailsRepository {
  Future<Either<HelperResponse, ProductDetailsModel>> getProductDetails(
    String sku,
  );
}
