import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';

abstract class LoginRulesRepository {
  Future<Either<HelperResponse, LoginResponse>> login(
    LoginRequest loginRequest,
  );
}
