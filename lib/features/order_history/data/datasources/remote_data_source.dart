import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../models/order_model.dart';

class OrderHistoryRemoteDataSource with ApiClient {
  // 📦 CUSTOMER ORDERS QUERY
  static const String customerOrdersQuery = '''
    query GetCustomerOrders(\$pageSize: Int = 20, \$currentPage: Int = 1) {
      customer {
        orders(pageSize: \$pageSize, currentPage: \$currentPage) {
          total_count
          items {
            id
            order_number
            created_at
            status
            grand_total
            total_item_count
            items {
              product_name
              product_sku
              product_sale_price {
                value
                currency
              }
              quantity_ordered
            }
          }
        }
      }
    }
  ''';

  // 📦 GUEST ORDER QUERY
  static const String guestOrderQuery = '''
    query GetGuestOrder(\$orderNumber: String!, \$email: String!) {
      guestOrder(input: { number: \$orderNumber, email: \$email }) {
        id
        order_number
        created_at
        status
        grand_total
        total {
          grand_total {
            value
            currency
          }
        }
        items {
          product_name
          product_sku
          product_sale_price {
            value
            currency
          }
          quantity_ordered
        }
      }
    }
  ''';

  /// Fetches the customer's order history
  Future<Either<HelperResponse, OrderData>> getOrders({
    int pageSize = 20,
    int currentPage = 1,
  }) async {
    final result = await graphQLQuery<OrderData>(
      customerOrdersQuery,
      variables: {'pageSize': pageSize, 'currentPage': currentPage},
      requireAuth: true,
      dataKey: 'customer',
      fromJson: (json) {
        return OrderData.fromJson(json['orders']);
      },
    );
    return result.fold((error) => Left(error), (orderData) => Right(orderData));
  }

  /// Fetches a guest order by order number and email
  Future<Either<HelperResponse, OrderModel>> getGuestOrder({
    required String orderNumber,
    required String email,
  }) async {
    final result = await graphQLQuery<OrderModel>(
      guestOrderQuery,
      variables: {'orderNumber': orderNumber, 'email': "TestM@yopmail.com"},
      requireAuth: false,
      dataKey: 'guestOrder',
      fromJson: (json) => OrderModel.fromJson(json),
    );
    return result.fold((error) => Left(error), (order) => Right(order));
  }
}
