import 'package:dartz/dartz.dart';

import '../../../../core/services/helper_respons.dart';
import '../../data/models/home_response.dart';
import '../../data/repository_impl/repository.dart';

abstract class HomeUseCase {
  Future<Either<HelperResponse, HomeResponse>> getHome();
}

class HomeUseCaseImpl implements HomeUseCase {
  final _homeRepository = HomeRepositoryImpl();

  @override
  Future<Either<HelperResponse, HomeResponse>> getHome() async {
    return await _homeRepository.getHome();
  }
}
