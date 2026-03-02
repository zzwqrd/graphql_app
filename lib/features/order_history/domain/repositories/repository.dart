import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../data/models/order_model.dart';

abstract class OrderHistoryRepository {
  Future<Either<HelperResponse, OrderData>> getOrders({
    required int pageSize,
    required int currentPage,
  });

  Future<Either<HelperResponse, OrderModel>> getGuestOrder({
    required String orderNumber,
    required String email,
  });
}
