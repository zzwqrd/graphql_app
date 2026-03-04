import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/graphql_queries.dart';
import '../../data/models/login_model.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStateBloc> {
  final ApiClient _apiClient = ApiClient();
  final GraphQLQueries queries = GraphQLQueries();
  LoginBloc() : super(const LoginStateBloc()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginStateBloc> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));

    try {
      final result = await _apiClient.graphQLQuery(
        queries.loginMutation,
        variables: {"email": event.email, "password": event.password},
        fromJson: (json) => LoginResponse.fromJson(json),
        dataKey: 'generateCustomerToken',
      );

      result.fold(
        (l) => emit(
          state.copyWith(
            requestState: RequestState.error,
            errorMessage: l.message,
          ),
        ),
        (r) => emit(
          state.copyWith(
            requestState: RequestState.done,
            loginData: r, // If you want to pass data back
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
