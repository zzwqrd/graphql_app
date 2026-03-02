import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/dashboard_model.dart';

class MyAccountRepositoryImpl implements MyAccountRepository {
  final _dataSource = MyAccountRemoteDataSource();

  @override
  Future<Either<HelperResponse, DashboardData>> getDashboardData() async {
    return await _dataSource.getDashboardData();
  }
}
