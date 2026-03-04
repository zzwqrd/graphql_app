import 'package:dartz/dartz.dart';
import '../../../../../core/auth/auth_manager.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_data_source.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

class LoginRulesRepositoryImpl implements LoginRulesRepository {
  const LoginRulesRepositoryImpl({required LoginRulesDataSource dataSource})
    : _dataSource = dataSource;

  final LoginRulesDataSource _dataSource;

  @override
  Future<Either<HelperResponse, LoginResponse>> login(
    LoginRequest loginRequest,
  ) async {
    final result = await _dataSource.login(loginRequest);

    return await result.fold((failure) => Left(failure), (response) async {
      if (response.token.isNotEmpty) {
        await AuthManager.saveAuthData(
          token: response.token,
          email: response.customer?.email,
          name:
              '${response.customer?.firstname} ${response.customer?.lastname}',
          customerId: response.customer?.email,
        );
      }
      return Right(response);
    });
  }
}
