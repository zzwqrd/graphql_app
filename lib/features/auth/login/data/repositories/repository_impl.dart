import 'package:dartz/dartz.dart';

import '../../../../../core/auth/auth_manager.dart';
import '../../../../../core/services/dio_services.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart' show LoginRepository;
import '../datasources/data_source.dart';
import '../models/login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl(this.loginDataSource);

  @override
  Future<Either<HelperResponse, LoginData>> completeLogin(
    LoginModel loginModel,
  ) async {
    // 1. Perform Login
    final loginResult = await loginDataSource.login(loginModel);

    return await loginResult.fold((failure) => Left(failure), (
      loginResponse,
    ) async {
      final String token = loginResponse.token;

      // 2. Fetch Customer Data
      final customerResult = await loginDataSource.getCustomerData(
        token: token,
      );

      return await customerResult.fold((failure) => Left(failure), (
        customer,
      ) async {
        // ✅ Side Effects: Save data and update headers
        await AuthManager.saveAuthData(
          token: token,
          email: customer.email,
          name: '${customer.firstname ?? ''} ${customer.lastname ?? ''}',
          customerId: customer.id,
        );

        DioServices.instance.updateAuthToken(token);

        return Right(
          LoginData(
            loginResponse: loginResponse,
            token: token,
            customer: customer,
          ),
        );
      });
    });
  }
}
