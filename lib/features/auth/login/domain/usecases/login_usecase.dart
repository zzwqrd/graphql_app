import 'package:dartz/dartz.dart';

import '../../../../../core/services/helper_respons.dart';
import '../../data/models/login_model.dart';
import '../repositories/repository.dart';

abstract class LoginUsecase {
  Future<Either<HelperResponse, LoginData>> call(LoginModel loginModel);
}

class LoginUseCaseImpl implements LoginUsecase {
  final LoginRepository loginRepository;

  LoginUseCaseImpl(this.loginRepository);

  @override
  Future<Either<HelperResponse, LoginData>> call(LoginModel loginModel) async {
    return await loginRepository.completeLogin(loginModel);
  }
}
