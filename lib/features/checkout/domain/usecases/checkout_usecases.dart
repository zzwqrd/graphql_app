import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../entities/order_entity.dart';
import '../entities/payment_method_entity.dart';
import '../entities/telr_payment_entity.dart';
import '../repository/checkout_repository.dart';

/// Get Payment Methods Use Case
class GetPaymentMethodsUseCase {
  final CheckoutRepository _repository;

  GetPaymentMethodsUseCase(this._repository);

  Future<Either<HelperResponse, List<PaymentMethodEntity>>> call() async {
    return await _repository.getPaymentMethods();
  }
}

/// Create Order Use Case
class CreateOrderUseCase {
  final CheckoutRepository _repository;

  CreateOrderUseCase(this._repository);

  Future<Either<HelperResponse, OrderEntity>> call(
    OrderEntity order, {
    Map<String, dynamic>? addressDetails,
  }) async {
    return await _repository.createOrder(order, addressDetails: addressDetails);
  }
}

/// Initiate Telr Payment Use Case
class InitiateTelrPaymentUseCase {
  final CheckoutRepository _repository;

  InitiateTelrPaymentUseCase(this._repository);

  Future<Either<HelperResponse, TelrPaymentEntity>> call({
    required String orderId,
    required double amount,
    required String currency,
    required String customerEmail,
    required String customerName,
  }) async {
    return await _repository.initiateTelrPayment(
      orderId: orderId,
      amount: amount,
      currency: currency,
      customerEmail: customerEmail,
      customerName: customerName,
    );
  }
}

/// Verify Payment Status Use Case
class VerifyPaymentStatusUseCase {
  final CheckoutRepository _repository;

  VerifyPaymentStatusUseCase(this._repository);

  Future<Either<HelperResponse, bool>> call({
    required String telrReference,
  }) async {
    return await _repository.verifyPaymentStatus(telrReference: telrReference);
  }
}

/// Update Order Payment Status Use Case
class UpdateOrderPaymentStatusUseCase {
  final CheckoutRepository _repository;

  UpdateOrderPaymentStatusUseCase(this._repository);

  Future<Either<HelperResponse, OrderEntity>> call({
    required String orderId,
    required String status,
    required String? transactionId,
  }) async {
    return await _repository.updateOrderPaymentStatus(
      orderId: orderId,
      status: status,
      transactionId: transactionId,
    );
  }
}
