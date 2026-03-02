import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/order_model.dart';

class OrderHistoryRepositoryImpl implements OrderHistoryRepository {
  final _dataSource = OrderHistoryRemoteDataSource();

  @override
  Future<Either<HelperResponse, OrderData>> getOrders({
    required int pageSize,
    required int currentPage,
  }) async {
    return await _dataSource.getOrders(
      pageSize: pageSize,
      currentPage: currentPage,
    );
  }

  @override
  Future<Either<HelperResponse, OrderModel>> getGuestOrder({
    required String orderNumber,
    required String email,
  }) async {
    return await _dataSource.getGuestOrder(
      orderNumber: orderNumber,
      email: email,
    );
  }
}
