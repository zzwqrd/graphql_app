import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:telr_mobile_payment_sdk/telr_mobile_payment_sdk.dart';
import '../../../../app_initialize.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../../../di/service_locator.dart';
import '../../../cart/presentation/controller/controller.dart';
import '../../../cart/presentation/controller/state.dart';
import '../../domain/entities/order_entity.dart';
import '../controller/checkout_cubit.dart';
import '../controller/checkout_state.dart';
import '../widgets/checkout_order_summary.dart';
import '../widgets/confirm_order_button.dart';
import '../widgets/payment_method_card.dart';

/// Checkout View
/// Main checkout screen with payment methods and order summary
class CheckoutView extends StatefulWidget {
  final bool isDelivery;
  final String? shippingAddressId;
  final String? billingAddressId;
  final String? outletId;
  // Address details
  final String? addressStreet;
  final String? addressCity;
  final String? addressRegion;
  final String? addressPostcode;
  final String? addressTelephone;
  final String? addressEmail;
  final String? addressFirstname;
  final String? addressLastname;

  const CheckoutView({
    super.key,
    required this.isDelivery,
    this.shippingAddressId,
    this.billingAddressId,
    this.outletId,
    this.addressStreet,
    this.addressCity,
    this.addressRegion,
    this.addressPostcode,
    this.addressTelephone,
    this.addressEmail,
    this.addressFirstname,
    this.addressLastname,
  });

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late CheckoutCubit _checkoutCubit;
  late CartCubit _cartCubit;

  @override
  void initState() {
    super.initState();
    _checkoutCubit = CheckoutCubit();
    _cartCubit = sl<CartCubit>();

    // Load payment methods
    _checkoutCubit.getPaymentMethods();
  }

  @override
  void dispose() {
    _checkoutCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
      child: BlocProvider(
        create: (_) => _checkoutCubit,
        child: Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F39)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'معلومات الدفع',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F1F39),
              ),
            ),
          ),
          body: BlocConsumer<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              // Handle errors
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty) {
                FlashHelper.showToast(state.errorMessage!);
                _checkoutCubit.clearError();
              }

              // Handle COD Success
              if (state.orderCreationState == RequestState.done &&
                  state.createdOrder != null &&
                  state.createdOrder!.paymentMethodCode == 'cashondelivery') {
                FlashHelper.showToast(
                  'تم استلام طلبك بنجاح',
                  type: MessageTypeTost.success,
                );
                // Navigate to Order Success or Home
                pushAndRemoveUntil('/layout');
                return;
              }

              // Handle Online Payment Success - navigate to payment gateway
              if (state.paymentInitiationState == RequestState.done) {
                if (state.telrTokenUrl != null && state.telrOrderUrl != null) {
                  // Use Telr SDK
                  _handleTelrPayment(state.telrTokenUrl!, state.telrOrderUrl!);
                } else if (state.telrWebViewUrl != null) {
                  // Fallback to webview or error
                }
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Payment Methods Section
                    Text(
                      'اختر طريقة الدفع',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F1F39),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Payment Methods Grid
                    _buildPaymentMethodsGrid(state),

                    SizedBox(height: 24.h),

                    // Divider
                    Container(height: 1.h, color: const Color(0xFFEFF0F6)),

                    SizedBox(height: 24.h),

                    // Order Summary
                    BlocBuilder<CartCubit, CartState>(
                      bloc: _cartCubit,
                      builder: (context, cartState) {
                        // Calculate totals from cart items
                        final subtotal = cartState.totalAmount;
                        final tax = 0.0; // TODO: Calculate tax from cart items
                        final shipping = widget.isDelivery
                            ? 0.0
                            : 0.0; // TODO: Get from shipping calculation

                        return CheckoutOrderSummary(
                          subtotal: subtotal,
                          tax: tax,
                          shippingCharge: shipping,
                          discount: 0.0, // TODO: Add coupon discount
                          total: subtotal + tax + shipping,
                        );
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Confirm Order Button
                    BlocBuilder<CartCubit, CartState>(
                      bloc: _cartCubit,
                      builder: (context, cartState) {
                        return ConfirmOrderButton(
                          onPressed: () =>
                              _handleConfirmOrder(state, cartState),
                          isLoading:
                              state.orderCreationState ==
                                  RequestState.loading ||
                              state.paymentInitiationState ==
                                  RequestState.loading,
                          isEnabled: state.selectedPaymentIndex != -1,
                        );
                      },
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsGrid(CheckoutState state) {
    if (state.paymentMethodsState == RequestState.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF01BE5F)),
      );
    }

    if (state.paymentMethodsState == RequestState.error) {
      return Center(
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: const Color(0xFF6E7191),
            ),
            SizedBox(height: 8.h),
            Text(
              'فشل تحميل طرق الدفع',
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6E7191)),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => _checkoutCubit.getPaymentMethods(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state.paymentMethods.isEmpty) {
      return Center(
        child: Text(
          'لا توجد طرق دفع متاحة',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6E7191)),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.5,
      ),
      itemCount: state.paymentMethods.length,
      itemBuilder: (context, index) {
        final paymentMethod = state.paymentMethods[index];
        return PaymentMethodCard(
          paymentMethod: paymentMethod,
          isSelected: state.selectedPaymentIndex == index,
          onTap: () => _checkoutCubit.selectPaymentMethod(index),
        );
      },
    );
  }

  Future<void> _handleConfirmOrder(
    CheckoutState checkoutState,
    CartState cartState,
  ) async {
    if (checkoutState.selectedPaymentIndex == -1) {
      FlashHelper.showToast(
        'الرجاء اختيار طريقة الدفع',
        type: MessageTypeTost.fail,
      );
      return;
    }

    final cartId = preferences.getString('cartId');

    if (cartId == null || cartId.isEmpty) {
      FlashHelper.showToast('السلة فارغة', type: MessageTypeTost.fail);
      return;
    }

    final selectedPaymentMethod =
        checkoutState.paymentMethods[checkoutState.selectedPaymentIndex];

    // Calculate totals
    final subtotal = cartState.totalAmount;
    final tax = 0.0; // TODO: Calculate tax from cart items
    final shipping = widget.isDelivery
        ? 0.0
        : 0.0; // TODO: Get from shipping calculation
    final total = subtotal + tax + shipping;

    // Create order entity from cart with address details
    final order = OrderEntity(
      id: cartId, // Use actual cart_id from Magento
      subtotal: subtotal,
      tax: tax,
      shippingCharge: shipping,
      discount: 0.0, // TODO: Add coupon discount
      total: total,
      paymentMethodId: selectedPaymentMethod.id,
      paymentMethodCode: selectedPaymentMethod.code,
      orderType: widget.isDelivery ? 'delivery' : 'pickup',
      shippingAddressId: widget.shippingAddressId,
      billingAddressId: widget.billingAddressId,
      outletId: widget.outletId,
      items: [], // TODO: Convert cart items to order items
    );

    // Complete checkout with address details
    _checkoutCubit.completeCheckout(
      order: order,
      customerEmail: widget.addressEmail ?? '[email protected]',
      customerName: widget.addressFirstname ?? 'Customer',
      addressDetails: {
        'firstname': widget.addressFirstname ?? 'Customer',
        'lastname': widget.addressLastname ?? 'Name',
        'email': widget.addressEmail ?? '[email protected]',
        'street': _sanitizedStreet(widget.addressStreet),
        'city': widget.addressCity ?? 'City',
        'region': widget.addressRegion ?? 'Region',
        'postcode': widget.addressPostcode ?? '12345',
        'telephone': widget.addressTelephone ?? '0500000000',
      },
    );
  }

  String _sanitizedStreet(String? input) {
    if (input == null || input.isEmpty) return 'Street Address';
    // Fix for AddressEntity toString() being passed effectively
    if (input.contains('AddressEntity')) {
      // Try to extract the street (assume it's the 3rd item in props list based on logs)
      // Log: AddressEntity(null, Home, 1600 Amphitheatre Pkwy, ...)
      try {
        final parts = input.split(',');
        if (parts.length > 2) {
          return parts[2].trim();
        }
      } catch (e) {
        return 'Street Address';
      }
    }
    return input;
  }

  Future<void> _handleTelrPayment(String tokenUrl, String orderUrl) async {
    try {
      // final dynamic result = await TelrSdk.presentPayment(
      //   tokenUrl,
      //   orderUrl,
      // );

      // if (result.success) {
      //   FlashHelper.showToast('تم الدفع بنجاح', type: MessageTypeTost.success);
      //
      //   // Verify payment on backend to update order status
      //   // We know implicit success via SDK, but good to double check or just navigate
      //   // Ideally we might get a transaction ref from SDK result if available,
      //   // but current SDK signature might be simple.
      //   // Assuming result.message might contain ref or we just check status of the order we created.
      //
      //   // For now, let's navigate to success
      //   // TODO: Navigate to Order Success Screen
      //   // Navigate to Home/Layout
      //   pushAndRemoveUntil('/layout');
      // } else {
      //   FlashHelper.showToast(
      //     'فشل الدفع: ${result.message}',
      //     type: MessageTypeTost.fail,
      //   );
      // }
    } catch (e) {
      FlashHelper.showToast(
        'حدث خطأ غير متوقع: $e',
        type: MessageTypeTost.fail,
      );
    }
  }
}
