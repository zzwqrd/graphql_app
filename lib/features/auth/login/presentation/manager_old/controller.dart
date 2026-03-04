import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/api_client.dart';
import '../../../../../core/utils/enums.dart';
import '../../data/models/graphql_queries.dart';
import '../../data/models/login_model.dart';
import 'state.dart';

class LoginCubitOld extends Cubit<LoginStateOld> {
  final ApiClient _apiClient = ApiClient();
  LoginCubitOld() : super(LoginStateOld());

  LoginData loginData = LoginData();
  final GraphQLQueries queries = GraphQLQueries();

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(requestState: RequestState.loading));
    final result = await _apiClient.graphQLQuery(
      queries.loginMutation,
      variables: {"email": email, "password": password},
      fromJson: (json) => LoginResponse.fromJson(json),
      dataKey: 'generateCustomerToken',
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          requestState: RequestState.error,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(state.copyWith(requestState: RequestState.done)),
    );
  }
}
