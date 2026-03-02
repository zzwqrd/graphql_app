import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/models.dart';
import '../../data/repositories_impl/repository_impl.dart';

abstract class GetCategoriesUseCase {
  Future<Either<HelperResponse, ModelsCategories>> call();
  Future<Either<HelperResponse, ModelsCategories>> getCategoryById(String uid);
}

class GetCategoriesUseCaseImpl implements GetCategoriesUseCase {
  final _repository = CategoryRepositoryImpl();

  @override
  Future<Either<HelperResponse, ModelsCategories>> call() async {
    return await _repository.getCategories();
  }

  @override
  Future<Either<HelperResponse, ModelsCategories>> getCategoryById(
    String uid,
  ) async {
    return await _repository.getCategoryById(uid);
  }
}
