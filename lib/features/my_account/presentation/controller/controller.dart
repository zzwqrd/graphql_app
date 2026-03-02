import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/auth/auth_manager.dart';
import '../../../../../core/utils/enums.dart';
import '../../domain/usecases/usecases.dart';
import 'state.dart';

class MyAccountController extends Cubit<MyAccountState> {
  MyAccountController() : super(const MyAccountState());

  final _getDashboardDataUseCase = GetDashboardDataUseCaseImpl();

  Future<void> getDashboardData({bool skipIfGuest = false}) async {
    // Skip API call for guest users if requested
    if (skipIfGuest && AuthManager.isGuest) {
      emit(state.copyWith(requestState: RequestState.done));
      return;
    }

    emit(state.copyWith(requestState: RequestState.loading));

    final result = await _getDashboardDataUseCase.call();

    result.fold(
      (error) {
        emit(
          state.copyWith(
            requestState: RequestState.error,
            errorMessage: error.message,
          ),
        );
      },
      (data) {
        emit(
          state.copyWith(requestState: RequestState.done, dashboardData: data),
        );
      },
    );
  }
}
