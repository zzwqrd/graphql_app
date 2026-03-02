import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../datasources/remote_data_source.dart';
import '../models/models.dart';
import '../../domain/repositories/repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final _remoteDataSource = CategoryRemoteDataSource();
  static ModelsCategories? _cache;

  @override
  Future<Either<HelperResponse, ModelsCategories>> getCategories() async {
    if (_cache != null) {
      _fetchAndCache(); // Refresh in background
      return Right(_cache!);
    }
    return _fetchAndCache();
  }

  Future<Either<HelperResponse, ModelsCategories>> _fetchAndCache() async {
    final result = await _remoteDataSource.getCategories();
    result.fold((l) => null, (r) => _cache = r);
    return result;
  }

  @override
  Future<Either<HelperResponse, ModelsCategories>> getCategoryById(
    String uid,
  ) async {
    return await _remoteDataSource.getCategoryById(uid);
  }
}
