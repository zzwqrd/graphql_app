import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/home_response.dart';
import '../../data/models/home_banner_slider_model.dart';
import '../../data/models/cms_block_model.dart';
import '../../data/models/home_crafting_memories_model.dart';
import '../../data/models/enhanced_slider_model.dart';

abstract class HomeRepository {
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
