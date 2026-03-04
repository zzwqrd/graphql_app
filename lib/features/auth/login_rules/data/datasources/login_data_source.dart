import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../../login/data/models/graphql_queries.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

abstract class LoginRulesDataSource {
  Future<Either<HelperResponse, LoginResponse>> login(
    LoginRequest loginRequest,
  );
}

class LoginRulesDataSourceImpl implements LoginRulesDataSource {
  const LoginRulesDataSourceImpl({
    required ApiClient apiClient,
    required GraphQLQueries queries,
  }) : _apiClient = apiClient,
       _queries = queries;

  final ApiClient _apiClient;
  final GraphQLQueries _queries;

  @override
  Future<Either<HelperResponse, LoginResponse>> login(
    LoginRequest loginRequest,
  ) async {
    return await _apiClient.graphQLMutation(
      _queries.loginMutation,
      variables: loginRequest.toJson(),
      requireAuth: false,
      dataKey: 'generateCustomerToken',
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }
}
