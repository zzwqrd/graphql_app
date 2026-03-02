import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories_impl/repository_impl.dart';

abstract class GetDashboardDataUseCase {
  Future<Either<HelperResponse, DashboardData>> call();
}

class GetDashboardDataUseCaseImpl implements GetDashboardDataUseCase {
  final _repository = MyAccountRepositoryImpl();

  @override
  Future<Either<HelperResponse, DashboardData>> call() async {
    return await _repository.getDashboardData();
  }
}
