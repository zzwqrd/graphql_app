import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums.dart';
import '../../domain/usecases/usecase.dart';
import 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final HomeUseCase _homeUseCase = HomeUseCaseImpl();

  Future<void> getHome() async {
    if (state.homeResponse == null) {
      emit(state.copyWith(requestState: RequestState.loading));
    }
    final result = await _homeUseCase.getHome();
    result.fold(
      (error) {
        if (state.homeResponse == null) {
          emit(
            state.copyWith(
              requestState: RequestState.error,
              msg: error.message,
            ),
          );
        }
      },
      (homeResponse) {
        emit(
          state.copyWith(
            requestState: RequestState.done,
            homeResponse: homeResponse,
          ),
        );
      },
    );
  }

  Future<void> getHomeBanners(String actionName) async {
    if (state.homeBannerSliderData == null) {
      emit(state.copyWith(bannerRequestState: RequestState.loading));
    }
    final result = await _homeUseCase.getHomeBanners(actionName);
    result.fold(
      (error) {
        if (state.homeBannerSliderData == null) {
          emit(
            state.copyWith(
              bannerRequestState: RequestState.error,
              bannerMsg: error.message,
            ),
          );
        }
      },
      (data) {
        emit(
          state.copyWith(
            bannerRequestState: RequestState.done,
            homeBannerSliderData: data,
          ),
        );
      },
    );
  }

  Future<void> getProductCmsBlocks(List<String> identifiers) async {
    if (state.cmsBlocksData == null) {
      emit(state.copyWith(cmsBlocksRequestState: RequestState.loading));
    }
    final result = await _homeUseCase.getProductCmsBlocks(identifiers);
    result.fold(
      (error) {
        if (state.cmsBlocksData == null) {
          emit(
            state.copyWith(
              cmsBlocksRequestState: RequestState.error,
              cmsBlocksMsg: error.message,
            ),
          );
        }
      },
      (data) {
        emit(
          state.copyWith(
            cmsBlocksRequestState: RequestState.done,
            cmsBlocksData: data,
          ),
        );
      },
    );
  }

  Future<void> getCraftingMemoriesBlock() async {
    if (state.craftingMemoriesData == null) {
      emit(state.copyWith(craftingMemoriesRequestState: RequestState.loading));
    }
    final result = await _homeUseCase.getCraftingMemoriesBlock();
    result.fold(
      (error) {
        if (state.craftingMemoriesData == null) {
          emit(
            state.copyWith(
              craftingMemoriesRequestState: RequestState.error,
              craftingMemoriesMsg: error.message,
            ),
          );
        }
      },
      (data) {
        emit(
          state.copyWith(
            craftingMemoriesRequestState: RequestState.done,
            craftingMemoriesData: data,
          ),
        );
      },
    );
  }

  Future<void> getEnhancedSliderProducts(String sliderName) async {
    if (state.newArrivalsData == null) {
      emit(state.copyWith(newArrivalsRequestState: RequestState.loading));
    }
    final result = await _homeUseCase.getEnhancedSliderProducts(sliderName);
    result.fold(
      (error) {
        if (state.newArrivalsData == null) {
          emit(
            state.copyWith(
              newArrivalsRequestState: RequestState.error,
              newArrivalsMsg: error.message,
            ),
          );
        }
      },
      (data) {
        emit(
          state.copyWith(
            newArrivalsRequestState: RequestState.done,
            newArrivalsData: data,
          ),
        );
      },
    );
  }
}
