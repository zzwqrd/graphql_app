import 'package:equatable/equatable.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/login_model.dart';

class LoginStateBloc extends Equatable {
  final RequestState requestState;
  final String? errorMessage;
  final LoginResponse? loginData;

  const LoginStateBloc({
    this.requestState = RequestState.initial,
    this.errorMessage,
    this.loginData,
  });

  LoginStateBloc copyWith({
    RequestState? requestState,
    String? errorMessage,
    LoginResponse? loginData,
  }) {
    return LoginStateBloc(
      requestState: requestState ?? this.requestState,
      errorMessage: errorMessage ?? this.errorMessage,
      loginData: loginData ?? this.loginData,
    );
  }

  @override
  List<Object?> get props => [requestState, errorMessage, loginData];
}
