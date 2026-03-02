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
}
