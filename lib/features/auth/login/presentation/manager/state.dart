import '../../../../../core/utils/enums.dart';
import '../../data/models/login_model.dart';

class LoginState {
  final RequestState requestState;
  final String? errorMessage;
  final LoginData? loginData;

  LoginState({
    this.requestState = RequestState.initial,
    this.errorMessage,
    this.loginData,
  });

  LoginState copyWith({
    RequestState? requestState,
    String? errorMessage,
    LoginData? loginData,
  }) {
    return LoginState(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      loginData: loginData ?? this.loginData,
    );
  }
}
