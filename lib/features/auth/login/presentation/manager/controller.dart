import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/auth/auth_manager.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/login_model.dart';
import '../../domain/usecases/login_usecase.dart';
import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(LoginState());

  LoginData loginData = LoginData();

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await _loginUseCase.call(
      LoginModel(email: email.trim(), password: password.trim()),
    );

    result.fold(
      (l) {
        emit(
          state.copyWith(
            requestState: RequestState.error,
            errorMessage: l.message,
          ),
        );
      },
      (r) async {
        loginData = r;

        // 🔐 Save auth data using AuthManager
        await AuthManager.saveAuthData(
          token: r.token!,
          email: email,
          name: r.customer?.firstname,
          customerId: r.customer?.id?.toString(),
        );

        emit(state.copyWith(requestState: RequestState.done));
      },
    );
  }
}
