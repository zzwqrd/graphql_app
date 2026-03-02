import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/home_response.dart';

abstract class HomeRepository {
  Future<Either<HelperResponse, HomeResponse>> getHome();
}
