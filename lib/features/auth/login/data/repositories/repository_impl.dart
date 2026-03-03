import 'package:dartz/dartz.dart';

import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart' show LoginRepository;
import '../datasources/data_source.dart';
import '../models/login_model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSourceImpl loginDataSource;

  LoginRepositoryImpl(this.loginDataSource);

  @override
  Future<Either<HelperResponse, LoginData>> completeLogin(
    LoginModel loginModel,
  ) async {
    return await loginDataSource.completeLogin(loginModel);
  }
}
