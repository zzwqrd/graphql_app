import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/dashboard_model.dart';

abstract class MyAccountRepository {
  Future<Either<HelperResponse, DashboardData>> getDashboardData();
}
