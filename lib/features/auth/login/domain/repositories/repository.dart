import 'package:dartz/dartz.dart';

import '../../../../../core/services/helper_respons.dart';

import '../../data/models/login_model.dart';

abstract class LoginRepository {
  Future<Either<HelperResponse, LoginData>> completeLogin(
    LoginModel loginModel,
  );
}
