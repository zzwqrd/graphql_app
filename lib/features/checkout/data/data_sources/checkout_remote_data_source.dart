import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/order_model.dart';
import '../models/payment_method_model.dart';
import '../models/graphql_queries.dart';
import '../models/telr_models.dart';

/// Checkout Remote Data Source
/// Handles GraphQL and Telr API calls
class CheckoutRemoteDataSource with ApiClient {
  final _queries = CheckoutGraphQLQueries();
  final Dio _dio = Dio();

  // Telr Configuration
  static const String telrBaseUrl = 'https://secure.telr.com';
  static const String telrCreateSessionEndpoint = '/api/v1/orders';
  static const String telrCheckStatusEndpoint = '/gateway/order/status.json';

  // ... (keeping other methods same)

  /// Get payment methods from Magento
  Future<Either<HelperResponse, List<PaymentMethodModel>>>
  getPaymentMethods() async {
    try {
      final response = await graphQLQuery(
        _queries.getPaymentMethodsQuery(),
        dataKey: 'storeConfig', // The query returns storeConfig
        fromJson: (json) => json,
      );

      return response.fold(
        (error) {
          print('⚠️ Magento API Error: ${error.message}');
          print('Using fallback payment methods due to API error');

          final fallbackMethods = [
            PaymentMethodModel(
              id: 'telr',
              name: 'Telr (Code: telr)',
              code: 'telr',
              image: null,
              isActive: true,
              sortOrder: 0,
            ),
            PaymentMethodModel(
              id: 'telrpayment',
              name: 'Telr (Code: telrpayment)',
              code: 'telrpayment',
              image: null,
              isActive: true,
              sortOrder: 1,
            ),
            PaymentMethodModel(
              id: 'cashondelivery',
              name: 'الدفع عند الاستلام',
              code: 'cashondelivery',
              image: null,
              isActive: true,
              sortOrder: 2,
            ),
          ];
          return Right(fallbackMethods);
        },
        (data) {
          final paymentMethods = <PaymentMethodModel>[];
          if (data is Map<String, dynamic> && data['payment_methods'] != null) {
            final methods = data['payment_methods'] as List;

            print('💳 Available Payment Methods: $methods');

            for (var m in methods) {
              final code = m['code'];
              // Filter logic if needed, or map specific codes to names
              paymentMethods.add(
                PaymentMethodModel(
                  id: code,
                  name: m['title'] ?? code,
                  code: code,
                  image: null,
                  isActive: true,
                  sortOrder: 0,
                ),
              );
            }
          }

          // Fallback if empty (e.g. if query fails or config is hidden)
          if (paymentMethods.isEmpty) {
            print(
              '⚠️ No payment methods found in Store Config, using defaults.',
            );
            paymentMethods.add(
              PaymentMethodModel(
                id: 'telr',
                name: 'بطاقة الائتمان (Telr)',
                code: 'telr',
                image: null,
                isActive: true,
                sortOrder: 0,
              ),
            );
          }

          return Right(paymentMethods);
        },
      );
    } catch (e) {
      print('⚠️ Failed to fetch payment methods: $e');
      print('Using fallback payment methods');

      final fallbackMethods = [
        PaymentMethodModel(
          id: 'telr',
          name: 'Telr (Code: telr)',
          code: 'telr',
          image: null,
          isActive: true,
          sortOrder: 0,
        ),
        PaymentMethodModel(
          id: 'telrpayment',
          name: 'Telr (Code: telrpayment)',
          code: 'telrpayment',
          image: null,
          isActive: true,
          sortOrder: 1,
        ),
        PaymentMethodModel(
          id: 'cashondelivery',
          name: 'الدفع عند الاستلام',
          code: 'cashondelivery',
          image: null,
          isActive: true,
          sortOrder: 2,
        ),
      ];

      return Right(fallbackMethods);
    }
  }

  /// Create order in Magento via GraphQL
  /// This requires setting up the cart first with shipping/billing addresses and payment method
  /// createOrder() (Corrected Version with Separate Shipping Method)
  Future<Either<HelperResponse, OrderModel>> createOrder(
    OrderModel order, {
    required Map<String, dynamic> address,
  }) async {
    try {
      final cartId = order.id;
      if (cartId == null || cartId.isEmpty) {
        return Left(HelperResponse.badRequest(message: 'Cart ID غير صالح'));
      }

      // Preparation
      final email = (address['email'] ?? '[email protected]').toString().trim();
      final countryCode =
          address['country_code'] ?? address['countryCode'] ?? 'SA';
      final street = _parseStreet(address['street']);

      final variables = {
        'cartId': cartId,
        'firstname': address['firstname'],
        'lastname': address['lastname'],
        'street': street,
        'city': address['city'],
        'region': address['region'],
        'postcode': address['postcode'],
        'country_code': countryCode,
        'telephone': address['telephone'],
      };

      // 0️⃣ Set Guest Email
      final emailError = await _setGuestEmail(cartId, "TestM@yopmail.com");
      if (emailError != null) return Left(emailError);

      // 1️⃣ Set Shipping Address
      final shippingError = await _setShippingAddress(variables);
      if (shippingError != null) return Left(shippingError);

      // 2️⃣ Set Shipping Method
      final shippingMethodError = await _setShippingMethod(cartId);
      if (shippingMethodError != null) return Left(shippingMethodError);

      // 3️⃣ Set Billing Address
      final billingError = await _setBillingAddress(variables);
      if (billingError != null) return Left(billingError);

      // 4️⃣ Set Payment Method
      final paymentError = await _setPaymentMethod(
        cartId,
        order.paymentMethodCode,
      );
      if (paymentError != null) return Left(paymentError);

      // 5️⃣ Place Order
      return await _placeOrder(cartId, order);
    } catch (e) {
      return Left(HelperResponse.unknownError(message: 'فشل إنشاء الطلب: $e'));
    }
  }

  // ---------------------------------------------------------------------------
  // 🔒 Private Helper Methods
  // ---------------------------------------------------------------------------

  List<String> _parseStreet(dynamic streetInput) {
    try {
      if (streetInput is List) {
        return streetInput.map((e) => e.toString()).toList();
      } else if (streetInput.toString().contains('AddressEntity')) {
        final inputStr = streetInput.toString();
        try {
          final parts = inputStr.split(',');
          if (parts.length > 2) {
            return [parts[2].trim()];
          }
        } catch (_) {}
      } else {
        return [streetInput.toString()];
      }
    } catch (e) {
      print('⚠️ Error parsing street: $e');
    }
    return ['General Street'];
  }

  Future<HelperResponse?> _setGuestEmail(String cartId, String email) async {
    print('📧 Setting guest email: $email');
    final result = await graphQLMutation(
      _queries.setGuestEmailOnCartMutation(),
      variables: {'cartId': cartId, 'email': email},
      dataKey: null,
      fromJson: (json) => json,
    );
    return result.fold((l) => l, (r) => null);
  }

  Future<HelperResponse?> _setShippingAddress(
    Map<String, dynamic> variables,
  ) async {
    print('📦 Setting shipping address...');
    final result = await graphQLMutation(
      _queries.setShippingAddressMutation(),
      variables: variables,
      dataKey: null,
      fromJson: (json) => json,
    );
    return result.fold((l) => l, (r) => null);
  }

  Future<HelperResponse?> _setShippingMethod(String cartId) async {
    print('🚚 Fetching available shipping methods...');
    String carrierCode = 'flatrate';
    String methodCode = 'flatrate';

    final availableMethodsResult = await graphQLQuery(
      _queries.getAvailableShippingMethodsQuery(),
      variables: {'cartId': cartId},
      dataKey: null,
      fromJson: (json) => json,
    );

    availableMethodsResult.fold(
      (error) => print('⚠️ Could not fetch shipping methods: ${error.message}'),
      (data) {
        if (data is Map<String, dynamic> &&
            data['cart']?['shipping_addresses'] != null) {
          final addresses = data['cart']['shipping_addresses'] as List;
          if (addresses.isNotEmpty) {
            final methods = addresses[0]['available_shipping_methods'] as List?;
            if (methods != null && methods.isNotEmpty) {
              print('✅ Available Shipping Methods: $methods');
              final firstMethod = methods[0];
              carrierCode = firstMethod['carrier_code'];
              methodCode = firstMethod['method_code'];
            }
          }
        }
      },
    );

    print('🚚 Setting shipping method to: $carrierCode / $methodCode');
    final result = await graphQLMutation(
      _queries.setShippingMethodMutation(),
      variables: {
        'cartId': cartId,
        'carrier_code': carrierCode,
        'method_code': methodCode,
      },
      dataKey: null,
      fromJson: (json) => json,
    );
    return result.fold((l) => l, (r) => null);
  }

  Future<HelperResponse?> _setBillingAddress(
    Map<String, dynamic> variables,
  ) async {
    print('💳 Setting billing address...');
    final result = await graphQLMutation(
      _queries.setBillingAddressMutation(),
      variables: variables,
      dataKey: null,
      fromJson: (json) => json,
    );
    return result.fold((l) => l, (r) => null);
  }

  Future<HelperResponse?> _setPaymentMethod(
    String cartId,
    String paymentCode,
  ) async {
    print('💰 Setting payment method...');
    final result = await graphQLMutation(
      _queries.setPaymentMethodMutation(),
      variables: {'cartId': cartId, 'paymentCode': paymentCode},
      dataKey: null,
      fromJson: (json) => json,
    );
    return result.fold((l) => l, (r) => null);
  }

  Future<Either<HelperResponse, OrderModel>> _placeOrder(
    String cartId,
    OrderModel order,
  ) async {
    print('🎯 Placing order...');
    return await graphQLMutation<OrderModel>(
      _queries.placeOrderMutation(),
      variables: {'cartId': cartId},
      dataKey: null,
      fromJson: (json) {
        print('📥 PlaceOrder Response: $json');

        if (json == null) {
          throw Exception('Empty response from server');
        }

        final placeOrderData = json['placeOrder'];
        if (placeOrderData == null) {
          // DEBUG: Include full JSON in error message
          throw Exception('Missing placeOrder key. Response: $json');
        }

        final orderData = placeOrderData['order'];
        if (orderData == null) {
          // DEBUG: Include full JSON in error message
          throw Exception('Missing order key. Response: $json');
        }

        if (orderData is! Map) {
          throw Exception('Order data is not a Map: $orderData');
        }

        return OrderModel(
          id: orderData['order_id']?.toString() ?? '',
          orderNumber: orderData['order_number']?.toString() ?? '',
          total: order.total,
          paymentMethodCode: order.paymentMethodCode,
          status: 'pending',
          createdAt: DateTime.now(),
          subtotal: order.subtotal,
          tax: order.tax,
          shippingCharge: order.shippingCharge,
          discount: order.discount,
          paymentMethodId: order.paymentMethodId,
          orderType: order.orderType,
          items: order.items,
        );
      },
    );
  }

  /// Initiate Telr payment session
  Future<Either<HelperResponse, TelrCreateSessionResponse>>
  initiateTelrPayment({
    required String storeId,
    required String authKey,
    required String orderId,
    required double amount,
    required String currency,
    required String customerEmail,
    required String customerName,
    required bool isTestMode,
  }) async {
    try {
      // Split customer name
      final nameParts = customerName.split(' ');
      final forenames = nameParts.first;
      final surname = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      // Construct standard Telr Request
      final requestBody = {
        'method': 'create',
        'store': storeId,
        'authkey': authKey,
        'framed': 0, // 0 usually for SDK/App
        'order': {
          'cartid': orderId,
          'test': isTestMode ? '1' : '0',
          'amount': amount.toStringAsFixed(2),
          'currency': currency,
          'description': 'Order #$orderId',
        },
        'customer': {
          'email': customerEmail,
          'name': {
            'forenames': forenames,
            'surname': surname.isEmpty ? forenames : surname,
          },
          'phone': '', // Add if available
        },
      };

      final response = await _dio.post(
        '$telrBaseUrl/gateway/order.json', // Use standard gateway endpoint
        data: requestBody,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final telrResponse = TelrCreateSessionResponse.fromJson(response.data);

        if (telrResponse.error != null) {
          return Left(HelperResponse.badRequest(message: telrResponse.error!));
        }

        // Check if we have the required URLs for SDK or at least the webview URL
        if (telrResponse.tokenUrl != null && telrResponse.orderUrl != null) {
          return Right(telrResponse);
        } else if (telrResponse.order.url != null) {
          // Fallback to webview if SDK URLs are missing, though SDK might not work
          return Right(telrResponse);
        }

        return Left(
          HelperResponse.badRequest(message: 'فشل في الحصول على رابط الدفع'),
        );
      }

      return Left(
        HelperResponse.badRequest(message: 'فشل في إنشاء جلسة الدفع'),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'خطأ في الاتصال بخدمة الدفع: ${e.toString()}',
        ),
      );
    }
  }

  /// Verify payment status from Telr
  Future<Either<HelperResponse, bool>> verifyPaymentStatus({
    required String storeId,
    required String authKey,
    required String telrReference,
  }) async {
    try {
      final request = TelrCheckStatusRequest(
        store: storeId,
        authkey: authKey,
        order: TelrOrderRef(ref: telrReference),
      );

      final response = await _dio.post(
        '$telrBaseUrl$telrCheckStatusEndpoint',
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final telrResponse = TelrCheckStatusResponse.fromJson(response.data);

        if (telrResponse.error != null) {
          return Left(HelperResponse.badRequest(message: telrResponse.error!));
        }

        return Right(telrResponse.order.isAuthorised);
      }

      return Left(
        HelperResponse.badRequest(message: 'فشل في التحقق من حالة الدفع'),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'خطأ في التحقق من الدفع: ${e.toString()}',
        ),
      );
    }
  }
}
