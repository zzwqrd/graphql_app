import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../entities/order_entity.dart';
import '../entities/payment_method_entity.dart';
import '../entities/telr_payment_entity.dart';

/// Checkout Repository Interface
/// Defines contract for checkout operations
abstract class CheckoutRepository {
  /// Get available payment methods
  Future<Either<HelperResponse, List<PaymentMethodEntity>>> getPaymentMethods();

  /// Create order in Magento
  Future<Either<HelperResponse, OrderEntity>> createOrder(
    OrderEntity order, {
    Map<String, dynamic>? addressDetails,
  });

  /// Initiate Telr payment session
  Future<Either<HelperResponse, TelrPaymentEntity>> initiateTelrPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String customerEmail,
    required String customerName,
  });

  /// Verify payment status from Telr
  Future<Either<HelperResponse, bool>> verifyPaymentStatus({
    required String telrReference,
  });

  /// Update order payment status
  Future<Either<HelperResponse, OrderEntity>> updateOrderPaymentStatus({
    required String orderId,
    required String status,
    required String? transactionId,
  });
}
