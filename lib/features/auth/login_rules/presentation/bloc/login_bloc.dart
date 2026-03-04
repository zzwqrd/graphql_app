import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/login_request_model.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginRulesBloc extends Bloc<LoginRulesEvent, LoginRulesState> {
  LoginRulesBloc({required LoginRulesUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginRulesState()) {
    on<LoginRulesSubmitted>(_onLoginSubmitted);
  }

  final LoginRulesUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(
    LoginRulesSubmitted event,
    Emitter<LoginRulesState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));

    final request = LoginRequest(email: event.email, password: event.password);

    final result = await _loginUseCase(request);

    result.fold(
      (failure) => emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(requestState: RequestState.done, loginData: response),
      ),
    );
  }
}
