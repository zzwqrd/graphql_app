import 'package:dartz/dartz.dart';
import '../../../../app_initialize.dart';
import '../../../../core/services/helper_respons.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/telr_payment_entity.dart';
import '../../domain/repository/checkout_repository.dart';
import '../data_sources/checkout_remote_data_source.dart';
import '../models/order_model.dart';

/// Checkout Repository Implementation
class CheckoutRepositoryImpl implements CheckoutRepository {
  late final CheckoutRemoteDataSource _remoteDataSource;

  CheckoutRepositoryImpl() {
    _remoteDataSource = CheckoutRemoteDataSource();
  }

  /// Get Telr credentials from secure storage
  Future<Map<String, String>> _getTelrCredentials() async {
    // TODO: Use flutter_secure_storage for production
    final storeId = preferences.getString('telr_store_id') ?? 'test_store';
    final authKey = preferences.getString('telr_auth_key') ?? 'test_key';
    final isTestMode = preferences.getBool('telr_test_mode') ?? true;

    return {
      'store_id': storeId,
      'auth_key': authKey,
      'is_test_mode': isTestMode.toString(),
    };
  }

  @override
  Future<Either<HelperResponse, List<PaymentMethodEntity>>>
  getPaymentMethods() async {
    try {
      final result = await _remoteDataSource.getPaymentMethods();
      return result.fold(
        (error) => Left(error),
        (methods) => Right(methods.map((m) => m.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل تحميل طرق الدفع: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, OrderEntity>> createOrder(
    OrderEntity order, {
    Map<String, dynamic>? addressDetails,
  }) async {
    try {
      if (addressDetails == null) {
        return Left(
          HelperResponse.badRequest(
            message: 'عنوان التوصيل مطلوب لإتمام الطلب',
          ),
        );
      }
      final orderModel = OrderModel.fromEntity(order);
      print('repo: createOrder addressDetails: $addressDetails');
      final result = await _remoteDataSource.createOrder(
        orderModel,
        address: addressDetails,
      );

      return result.fold(
        (error) => Left(error),
        (createdOrder) => Right(createdOrder.toEntity()),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل إنشاء الطلب: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, TelrPaymentEntity>> initiateTelrPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String customerEmail,
    required String customerName,
  }) async {
    try {
      final credentials = await _getTelrCredentials();

      final result = await _remoteDataSource.initiateTelrPayment(
        storeId: credentials['store_id']!,
        authKey: credentials['auth_key']!,
        orderId: orderId,
        amount: amount,
        currency: currency,
        customerEmail: customerEmail,
        customerName: customerName,
        isTestMode: credentials['is_test_mode'] == 'true',
      );

      return result.fold(
        (error) => Left(error),
        (response) => Right(
          TelrPaymentEntity(
            tokenUrl: response.tokenUrl,
            orderUrl: response.orderUrl,
            webViewUrl: response.order.url,
            orderRef: response.order.ref,
          ),
        ),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل بدء عملية الدفع: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, bool>> verifyPaymentStatus({
    required String telrReference,
  }) async {
    try {
      final credentials = await _getTelrCredentials();

      final result = await _remoteDataSource.verifyPaymentStatus(
        storeId: credentials['store_id']!,
        authKey: credentials['auth_key']!,
        telrReference: telrReference,
      );

      return result;
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل التحقق من حالة الدفع: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, OrderEntity>> updateOrderPaymentStatus({
    required String orderId,
    required String status,
    required String? transactionId,
  }) async {
    try {
      // TODO: Implement GraphQL mutation to update order status
      // For now, return success
      return Right(
        OrderEntity(
          id: orderId,
          subtotal: 0,
          tax: 0,
          shippingCharge: 0,
          discount: 0,
          total: 0,
          paymentMethodId: '',
          paymentMethodCode: '',
          orderType: '',
          items: [],
          status: status,
        ),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل تحديث حالة الطلب: ${e.toString()}',
        ),
      );
    }
  }
}
