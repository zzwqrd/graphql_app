import '../../../../core/utils/enums.dart';
import '../../data/models/home_response.dart';
import '../../data/models/home_banner_slider_model.dart';
import '../../data/models/cms_block_model.dart';
import '../../data/models/home_crafting_memories_model.dart';
import '../../data/models/enhanced_slider_model.dart';

class HomeState {
  final RequestState requestState;
  final String msg;
  final HomeResponse? homeResponse;

  final RequestState bannerRequestState;
  final String bannerMsg;
  final BannersSliderOutputHome? homeBannerSliderData;

  final RequestState cmsBlocksRequestState;
  final String cmsBlocksMsg;
  final CmsBlocksOutput? cmsBlocksData;

  final RequestState craftingMemoriesRequestState;
  final String craftingMemoriesMsg;
  final CraftingMemoriesOutput? craftingMemoriesData;

  final RequestState newArrivalsRequestState;
  final String newArrivalsMsg;
  final EnhancedSliderOutput? newArrivalsData;

  HomeState({
    this.requestState = RequestState.initial,
    this.msg = '',
    this.homeResponse,
    this.bannerRequestState = RequestState.initial,
    this.bannerMsg = '',
    this.homeBannerSliderData,
    this.cmsBlocksRequestState = RequestState.initial,
    this.cmsBlocksMsg = '',
    this.cmsBlocksData,
    this.craftingMemoriesRequestState = RequestState.initial,
    this.craftingMemoriesMsg = '',
    this.craftingMemoriesData,
    this.newArrivalsRequestState = RequestState.initial,
    this.newArrivalsMsg = '',
    this.newArrivalsData,
  });

  HomeState copyWith({
    RequestState? requestState,
    String? msg,
    HomeResponse? homeResponse,
    RequestState? bannerRequestState,
    String? bannerMsg,
    BannersSliderOutputHome? homeBannerSliderData,
    RequestState? cmsBlocksRequestState,
    String? cmsBlocksMsg,
    CmsBlocksOutput? cmsBlocksData,
    RequestState? craftingMemoriesRequestState,
    String? craftingMemoriesMsg,
    CraftingMemoriesOutput? craftingMemoriesData,
    RequestState? newArrivalsRequestState,
    String? newArrivalsMsg,
    EnhancedSliderOutput? newArrivalsData,
  }) => HomeState(
    requestState: requestState ?? this.requestState,
    msg: msg ?? this.msg,
    homeResponse: homeResponse ?? this.homeResponse,
    bannerRequestState: bannerRequestState ?? this.bannerRequestState,
    bannerMsg: bannerMsg ?? this.bannerMsg,
    homeBannerSliderData: homeBannerSliderData ?? this.homeBannerSliderData,
    cmsBlocksRequestState: cmsBlocksRequestState ?? this.cmsBlocksRequestState,
    cmsBlocksMsg: cmsBlocksMsg ?? this.cmsBlocksMsg,
    cmsBlocksData: cmsBlocksData ?? this.cmsBlocksData,
    craftingMemoriesRequestState:
        craftingMemoriesRequestState ?? this.craftingMemoriesRequestState,
    craftingMemoriesMsg: craftingMemoriesMsg ?? this.craftingMemoriesMsg,
    craftingMemoriesData: craftingMemoriesData ?? this.craftingMemoriesData,
    newArrivalsRequestState:
        newArrivalsRequestState ?? this.newArrivalsRequestState,
    newArrivalsMsg: newArrivalsMsg ?? this.newArrivalsMsg,
    newArrivalsData: newArrivalsData ?? this.newArrivalsData,
  );
}
