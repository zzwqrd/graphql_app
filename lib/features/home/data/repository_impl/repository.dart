import 'package:dartz/dartz.dart';

import '../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart';
import '../data_source/managed_home_remote_data_source.dart';
import '../data_source/home_banner_remote_data_source.dart';
import '../data_source/cms_block_remote_data_source.dart';
import '../data_source/home_crafting_memories_remote_data_source.dart';
import '../models/home_response.dart';
import '../models/home_banner_slider_model.dart';
import '../models/cms_block_model.dart';
import '../models/home_crafting_memories_model.dart';
import '../models/enhanced_slider_model.dart';
import '../data_source/home_new_arrivals_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final _managedRemoteDataSource = ManagedHomeRemoteDataSource();
  final _bannerRemoteDataSource = HomeBannerRemoteDataSource();
  final _cmsBlockRemoteDataSource = CmsBlockRemoteDataSource();
  final _craftingMemoriesRemoteDataSource =
      HomeCraftingMemoriesRemoteDataSource();
  final _newArrivalsRemoteDataSource = HomeNewArrivalsRemoteDataSource();
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

  @override
  Future<Either<HelperResponse, BannersSliderOutputHome>> getHomeBanners(
    String actionName,
  ) async {
    return await _bannerRemoteDataSource.getHomeBanners(actionName);
  }

  @override
  Future<Either<HelperResponse, CmsBlocksOutput>> getProductCmsBlocks(
    List<String> identifiers,
  ) async {
    return await _cmsBlockRemoteDataSource.getProductCmsBlocks(identifiers);
  }

  @override
  Future<Either<HelperResponse, CraftingMemoriesOutput>>
  getCraftingMemoriesBlock() async {
    return await _craftingMemoriesRemoteDataSource.getCraftingMemoriesBlock();
  }

  @override
  Future<Either<HelperResponse, EnhancedSliderOutput>>
  getEnhancedSliderProducts(String sliderName) async {
    return await _newArrivalsRemoteDataSource.getEnhancedSliderProducts(
      sliderName,
    );
  }
}
