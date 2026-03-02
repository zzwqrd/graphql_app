import 'package:dartz/dartz.dart';

import '../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart';
import '../data_source/managed_home_remote_data_source.dart';
import '../models/home_response.dart';

class HomeRepositoryImpl implements HomeRepository {
  final _managedRemoteDataSource = ManagedHomeRemoteDataSource();
  static HomeResponse? _cache;

  @override
  Future<Either<HelperResponse, HomeResponse>> getHome() async {
    // If we have a cache, we can return it immediately or use it to speed up the UI.
    // For now, let's allow returning the cache if it exists, while still triggering a refresh.
    if (_cache != null) {
      // In a real Stale-While-Revalidate, we might want a different stream-based API,
      // but for this simple Cubit, we can return the cache and let the Cubit handle the refresh.
      _fetchAndCache(); // Refresh in background
      return Right(_cache!);
    }
    return _fetchAndCache();
  }

  Future<Either<HelperResponse, HomeResponse>> _fetchAndCache() async {
    final result = await _managedRemoteDataSource.getHome();
    result.fold((l) => null, (r) => _cache = r);
    return result;
  }
}
