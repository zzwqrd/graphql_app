import 'package:dartz/dartz.dart';

import '../../../../../core/services/helper_respons.dart';
import '../../data/models/login_model.dart';
import '../../data/repositories/repository_impl.dart';

abstract class LoginUsecase {
  Future<Either<HelperResponse, LoginData>> call(LoginModel loginModel);
}

class LoginUseCaseImpl implements LoginUsecase {
  final loginRepository = LoginRepositoryImpl();

  @override
  Future<Either<HelperResponse, LoginData>> call(LoginModel loginModel) async {
    return await loginRepository.completeLogin(loginModel);
  }
}
