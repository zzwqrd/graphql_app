import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/checkout_usecases.dart';
import '../../data/repositories/checkout_repository_impl.dart';
import 'checkout_state.dart';

/// Checkout Cubit
/// Manages checkout flow and payment processing
class CheckoutCubit extends Cubit<CheckoutState> {
  late final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;
  late final CreateOrderUseCase _createOrderUseCase;
  late final InitiateTelrPaymentUseCase _initiateTelrPaymentUseCase;
  late final VerifyPaymentStatusUseCase _verifyPaymentStatusUseCase;
  late final UpdateOrderPaymentStatusUseCase _updateOrderPaymentStatusUseCase;

  CheckoutCubit() : super(const CheckoutState()) {
    final repository = CheckoutRepositoryImpl();
    _getPaymentMethodsUseCase = GetPaymentMethodsUseCase(repository);
    _createOrderUseCase = CreateOrderUseCase(repository);
    _initiateTelrPaymentUseCase = InitiateTelrPaymentUseCase(repository);
    _verifyPaymentStatusUseCase = VerifyPaymentStatusUseCase(repository);
    _updateOrderPaymentStatusUseCase = UpdateOrderPaymentStatusUseCase(
      repository,
    );
  }

  /// Get available payment methods
  Future<void> getPaymentMethods() async {
    emit(state.copyWith(paymentMethodsState: RequestState.loading));

    final result = await _getPaymentMethodsUseCase.call();

    result.fold(
      (error) {
        emit(
          state.copyWith(
            paymentMethodsState: RequestState.error,
            errorMessage: error.message,
          ),
        );
      },
      (methods) {
        emit(
          state.copyWith(
            paymentMethodsState: RequestState.done,
            paymentMethods: methods,
          ),
        );
      },
    );
  }

  /// Select payment method
  void selectPaymentMethod(int index) {
    emit(state.copyWith(selectedPaymentIndex: index));
  }

  /// Create order
  Future<void> createOrder(
    OrderEntity order, {
    Map<String, dynamic>? addressDetails,
  }) async {
    emit(state.copyWith(orderCreationState: RequestState.loading));

    final result = await _createOrderUseCase.call(
      order,
      addressDetails: addressDetails,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            orderCreationState: RequestState.error,
            errorMessage: error.message,
          ),
        );
      },
      (createdOrder) {
        emit(
          state.copyWith(
            orderCreationState: RequestState.done,
            createdOrder: createdOrder,
          ),
        );
      },
    );
  }

  /// Initiate Telr payment
  Future<void> initiateTelrPayment({
    required String orderId,
    required double amount,
    required String currency,
    required String customerEmail,
    required String customerName,
  }) async {
    emit(state.copyWith(paymentInitiationState: RequestState.loading));

    final result = await _initiateTelrPaymentUseCase.call(
      orderId: orderId,
      amount: amount,
      currency: currency,
      customerEmail: customerEmail,
      customerName: customerName,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            paymentInitiationState: RequestState.error,
            errorMessage: error.message,
          ),
        );
      },
      (paymentEntity) {
        emit(
          state.copyWith(
            paymentInitiationState: RequestState.done,
            telrTokenUrl: paymentEntity.tokenUrl,
            telrOrderUrl: paymentEntity.orderUrl,
            telrWebViewUrl: paymentEntity.webViewUrl,
            telrReference: paymentEntity.orderRef,
          ),
        );
      },
    );
  }

  /// Verify payment status
  Future<void> verifyPaymentStatus(String telrReference) async {
    emit(
      state.copyWith(
        paymentVerificationState: RequestState.loading,
        telrReference: telrReference,
      ),
    );

    final result = await _verifyPaymentStatusUseCase.call(
      telrReference: telrReference,
    );

    result.fold(
      (error) {
        emit(
          state.copyWith(
            paymentVerificationState: RequestState.error,
            errorMessage: error.message,
            paymentVerified: false,
          ),
        );
      },
      (isVerified) {
        emit(
          state.copyWith(
            paymentVerificationState: RequestState.done,
            paymentVerified: isVerified,
            successMessage: isVerified ? 'تم الدفع بنجاح' : 'فشل الدفع',
          ),
        );

        // Update order status if payment verified
        if (isVerified && state.createdOrder != null) {
          updateOrderPaymentStatus(
            orderId: state.createdOrder!.id!,
            status: 'paid',
            transactionId: telrReference,
          );
        }
      },
    );
  }

  /// Update order payment status
  Future<void> updateOrderPaymentStatus({
    required String orderId,
    required String status,
    required String transactionId,
  }) async {
    final result = await _updateOrderPaymentStatusUseCase.call(
      orderId: orderId,
      status: status,
      transactionId: transactionId,
    );

    result.fold(
      (error) {
        // Log error but don't emit state change
        print('Failed to update order status: ${error.message}');
      },
      (updatedOrder) {
        emit(state.copyWith(createdOrder: updatedOrder));
      },
    );
  }

  /// Complete checkout process
  Future<void> completeCheckout({
    required OrderEntity order,
    required String customerEmail,
    required String customerName,
    Map<String, dynamic>? addressDetails,
  }) async {
    // Step 1: Create order with address details
    await createOrder(order, addressDetails: addressDetails);

    if (state.orderCreationState == RequestState.error) {
      return;
    }

    // Step 2: Initiate payment if order created successfully
    if (state.createdOrder != null) {
      if (order.paymentMethodCode == 'cashondelivery') {
        // COD Order placed successfully, no need for payment gateway
        return;
      }

      await initiateTelrPayment(
        orderId: state.createdOrder!.id!,
        amount: order.total,
        currency: 'AED',
        customerEmail: customerEmail,
        customerName: customerName,
      );
    }
  }

  /// Reset checkout state
  void resetCheckout() {
    emit(state.reset());
  }

  /// Clear error message
  void clearError() {
    emit(state.clearError());
  }

  /// Clear success message
  void clearSuccess() {
    emit(state.clearSuccess());
  }
}
