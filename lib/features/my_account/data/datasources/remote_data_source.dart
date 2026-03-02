import 'package:dartz/dartz.dart';

import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../../order_history/data/models/order_model.dart';
import '../models/dashboard_model.dart';

class MyAccountRemoteDataSource with ApiClient {
  // Reuse the query or define it again if we want total strict separation.
  // Since it's effectively the same query structure needed for stats (scanning orders),
  // I will define it here as well to ensure total independence.
  static const String dashboardOrdersQuery = '''
    query GetCustomerOrdersStats(\$pageSize: Int = 100, \$currentPage: Int = 1) {
      customer {
        orders(pageSize: \$pageSize, currentPage: \$currentPage) {
          total_count
          items {
            status
          }
        }
      }
    }
  ''';

  Future<Either<HelperResponse, DashboardData>> getDashboardData() async {
    final result = await graphQLQuery<OrderData>(
      dashboardOrdersQuery,
      variables: {'pageSize': 100, 'currentPage': 1},
      requireAuth: true,
      dataKey: 'customer',
      fromJson: (json) {
        // Using OrderData for convenience, though we only fetch status here if we optimize the query.
        // But to re-use OrderModel parsing or just manual parsing:
        // Let's parse manually to avoid fetching full objects
        return OrderData.fromJson(json['orders']);
      },
    );

    return result.fold((error) => Left(error), (orderData) {
      int completed = 0;
      int returned = 0;

      for (var order in orderData.items) {
        final status = order.status.toLowerCase();
        if (status == 'complete' || status == 'completed') {
          completed++;
        } else if (status == 'returned' ||
            status == 'canceled' ||
            status == 'cancelled') {
          returned++;
        }
      }

      return Right(
        DashboardData(
          totalOrders: orderData.totalCount,
          totalCompleted: completed,
          totalReturned: returned,
          walletBalance: 0.00, // Placeholder
        ),
      );
    });
  }
}
