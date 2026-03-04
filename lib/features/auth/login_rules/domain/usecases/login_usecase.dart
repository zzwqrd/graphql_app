import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../repositories/login_repository.dart';

abstract class LoginRulesUseCase {
  Future<Either<HelperResponse, LoginResponse>> call(LoginRequest params);
}

class LoginRulesUseCaseImpl implements LoginRulesUseCase {
  final LoginRulesRepository _repository;

  LoginRulesUseCaseImpl({required LoginRulesRepository repository})
    : _repository = repository;

  @override
  Future<Either<HelperResponse, LoginResponse>> call(
    LoginRequest params,
  ) async {
    return await _repository.login(params);
  }
}
