import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/login_response_model.dart';

class LoginRulesState extends Equatable {
  final RequestState requestState;
  final String? errorMessage;
  final LoginResponse? loginData;

  const LoginRulesState({
    this.requestState = RequestState.initial,
    this.errorMessage,
    this.loginData,
  });

  LoginRulesState copyWith({
    RequestState? requestState,
    String? errorMessage,
    LoginResponse? loginData,
  }) {
    return LoginRulesState(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      loginData: loginData ?? this.loginData,
    );
  }

  @override
  List<Object?> get props => [requestState, errorMessage, loginData];
}
