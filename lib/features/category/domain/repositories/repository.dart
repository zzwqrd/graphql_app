import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/models.dart';

abstract class CategoryRepository {
  Future<Either<HelperResponse, ModelsCategories>> getCategories();
  Future<Either<HelperResponse, ModelsCategories>> getCategoryById(String uid);
}
