import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../models/graphql_queries.dart';
import '../models/login_model.dart';

abstract class LoginDataSource {
  Future<Either<HelperResponse, LoginResponse>> login(LoginModel loginModel);
  Future<Either<HelperResponse, Customer>> getCustomerData({
    required String token,
  });
}

class LoginDataSourceImpl with ApiClient implements LoginDataSource {
  final GraphQLQueries queries = GraphQLQueries();

  @override
  Future<Either<HelperResponse, LoginResponse>> login(
    LoginModel loginModel,
  ) async {
    return await graphQLMutation(
      queries.loginMutation,
      variables: {'email': loginModel.email, 'password': loginModel.password},
      requireAuth: false,
      dataKey: 'generateCustomerToken',
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }

  @override
  Future<Either<HelperResponse, Customer>> getCustomerData({
    required String token,
  }) async {
    return await graphQLQuery<Customer>(
      queries.customerQuery,
      headers: {'Authorization': 'Bearer $token'},
      requireAuth: true,
      fromJson: (json) => Customer.fromJson(json),
      dataKey: 'customer',
    );
  }
}
