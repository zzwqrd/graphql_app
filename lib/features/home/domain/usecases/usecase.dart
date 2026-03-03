import 'package:dartz/dartz.dart';

import '../../../../core/services/helper_respons.dart';
import '../../data/models/home_response.dart';
import '../../data/models/home_banner_slider_model.dart';
import '../../data/models/cms_block_model.dart';
import '../../data/models/home_crafting_memories_model.dart';
import '../../data/models/enhanced_slider_model.dart';
import '../../data/repository_impl/repository.dart';

abstract class HomeUseCase {
  Future<Either<HelperResponse, HomeResponse>> getHome();
  Future<Either<HelperResponse, BannersSliderOutputHome>> getHomeBanners(
    String actionName,
  );
  Future<Either<HelperResponse, CmsBlocksOutput>> getProductCmsBlocks(
    List<String> identifiers,
  );
  Future<Either<HelperResponse, CraftingMemoriesOutput>>
  getCraftingMemoriesBlock();
  Future<Either<HelperResponse, EnhancedSliderOutput>>
  getEnhancedSliderProducts(String sliderName);
}

class HomeUseCaseImpl implements HomeUseCase {
  final _homeRepository = HomeRepositoryImpl();

  @override
  Future<Either<HelperResponse, HomeResponse>> getHome() async {
    return await _homeRepository.getHome();
  }

  @override
  Future<Either<HelperResponse, BannersSliderOutputHome>> getHomeBanners(
    String actionName,
  ) async {
    return await _homeRepository.getHomeBanners(actionName);
  }

  @override
  Future<Either<HelperResponse, CmsBlocksOutput>> getProductCmsBlocks(
    List<String> identifiers,
  ) async {
    return await _homeRepository.getProductCmsBlocks(identifiers);
  }

  @override
  Future<Either<HelperResponse, CraftingMemoriesOutput>>
  getCraftingMemoriesBlock() async {
    return await _homeRepository.getCraftingMemoriesBlock();
  }

  @override
  Future<Either<HelperResponse, EnhancedSliderOutput>>
  getEnhancedSliderProducts(String sliderName) async {
    return await _homeRepository.getEnhancedSliderProducts(sliderName);
  }
}
