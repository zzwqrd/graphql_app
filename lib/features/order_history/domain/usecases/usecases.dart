import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories_impl/repository_impl.dart';

abstract class GetOrdersUseCase {
  Future<Either<HelperResponse, OrderData>> call({
    required int pageSize,
    required int currentPage,
  });
}

class GetOrdersUseCaseImpl implements GetOrdersUseCase {
  final _repository = OrderHistoryRepositoryImpl();

  @override
  Future<Either<HelperResponse, OrderData>> call({
    required int pageSize,
    required int currentPage,
  }) async {
    return await _repository.getOrders(
      pageSize: pageSize,
      currentPage: currentPage,
    );
  }
}

abstract class GetGuestOrderUseCase {
  Future<Either<HelperResponse, OrderModel>> call({
    required String orderNumber,
    required String email,
  });
}

class GetGuestOrderUseCaseImpl implements GetGuestOrderUseCase {
  final _repository = OrderHistoryRepositoryImpl();

  @override
  Future<Either<HelperResponse, OrderModel>> call({
    required String orderNumber,
    required String email,
  }) async {
    return await _repository.getGuestOrder(
      orderNumber: orderNumber,
      email: email,
    );
  }
}
