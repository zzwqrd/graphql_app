import '../../../../core/utils/enums.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_method_entity.dart';

/// Checkout State
/// Manages all state for checkout process
class CheckoutState {
  // Request States
  final RequestState paymentMethodsState;
  final RequestState orderCreationState;
  final RequestState paymentInitiationState;
  final RequestState paymentVerificationState;

  // Data
  final List<PaymentMethodEntity> paymentMethods;
  final int selectedPaymentIndex;
  final OrderEntity? createdOrder;
  // Telr Payment Data
  final String? telrTokenUrl;
  final String? telrOrderUrl;
  final String? telrWebViewUrl;
  final String? telrReference;
  final bool paymentVerified;

  // Messages
  final String? errorMessage;
  final String? successMessage;

  const CheckoutState({
    this.paymentMethodsState = RequestState.initial,
    this.orderCreationState = RequestState.initial,
    this.paymentInitiationState = RequestState.initial,
    this.paymentVerificationState = RequestState.initial,
    this.paymentMethods = const [],
    this.selectedPaymentIndex = -1,
    this.createdOrder,
    this.telrTokenUrl,
    this.telrOrderUrl,
    this.telrWebViewUrl,
    this.telrReference,
    this.paymentVerified = false,
    this.errorMessage,
    this.successMessage,
  });

  CheckoutState copyWith({
    RequestState? paymentMethodsState,
    RequestState? orderCreationState,
    RequestState? paymentInitiationState,
    RequestState? paymentVerificationState,
    List<PaymentMethodEntity>? paymentMethods,
    int? selectedPaymentIndex,
    OrderEntity? createdOrder,
    String? telrTokenUrl,
    String? telrOrderUrl,
    String? telrWebViewUrl,
    String? telrReference,
    bool? paymentVerified,
    String? errorMessage,
    String? successMessage,
  }) {
    return CheckoutState(
      paymentMethodsState: paymentMethodsState ?? this.paymentMethodsState,
      orderCreationState: orderCreationState ?? this.orderCreationState,
      paymentInitiationState:
          paymentInitiationState ?? this.paymentInitiationState,
      paymentVerificationState:
          paymentVerificationState ?? this.paymentVerificationState,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentIndex: selectedPaymentIndex ?? this.selectedPaymentIndex,
      createdOrder: createdOrder ?? this.createdOrder,
      telrTokenUrl: telrTokenUrl ?? this.telrTokenUrl,
      telrOrderUrl: telrOrderUrl ?? this.telrOrderUrl,
      telrWebViewUrl: telrWebViewUrl ?? this.telrWebViewUrl,
      telrReference: telrReference ?? this.telrReference,
      paymentVerified: paymentVerified ?? this.paymentVerified,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  /// Clear error message
  CheckoutState clearError() {
    return copyWith(errorMessage: '');
  }

  /// Clear success message
  CheckoutState clearSuccess() {
    return copyWith(successMessage: '');
  }

  /// Reset state
  CheckoutState reset() {
    return const CheckoutState();
  }
}
