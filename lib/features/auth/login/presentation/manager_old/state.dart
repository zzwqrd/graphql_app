import '../../../../../core/utils/enums.dart';
import '../../data/models/login_model.dart';

class LoginStateOld {
  final RequestState requestState;
  final String? errorMessage;
  final LoginData? loginData;

  LoginStateOld({
    this.requestState = RequestState.initial,
    this.errorMessage,
    this.loginData,
  });

  LoginStateOld copyWith({
    RequestState? requestState,
    String? errorMessage,
    LoginData? loginData,
  }) {
    return LoginStateOld(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      loginData: loginData ?? this.loginData,
    );
  }
}
