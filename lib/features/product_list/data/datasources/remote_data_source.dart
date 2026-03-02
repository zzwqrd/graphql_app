import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../models/graphql_queries_product.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, ProductListResponse>> getProducts(
    String categoryUid, {
    Map<String, List<String>>? filters,
    SortOption? sortOption,
    String? searchQuery,
    int page = 1,
  }) async {
    // Log the request
    dev.log(
      '🔍 [ProductListAPI] Fetching products for category: $categoryUid',
      name: 'ProductListAPI',
    );

    final result = await graphQLQuery(
      ProductGraphQLQueries().query(
        categoryUid: categoryUid,
        filters: filters,
        sortOption: sortOption,
        searchQuery: searchQuery,
        page: page,
      ),
      fromJson: (json) {
        // Log raw response snippet
        dev.log(
          '📦 [ProductListAPI] Response: ${json.toString().substring(0, json.toString().length > 300 ? 300 : json.toString().length)}...',
          name: 'ProductListAPI',
        );

        final response = ProductListResponse.fromJson(json);

        // Debug first product image
        if (response.items.isNotEmpty) {
          final first = response.items.first;
          dev.log(
            '🛍️ [ProductListAPI] First product: ${first.name}',
            name: 'ProductListAPI',
          );
          dev.log(
            '🖼️ [ProductListAPI] Raw Small Image: ${first.smallImage.url}',
            name: 'ProductListAPI',
          );
          dev.log(
            '🖼️ [ProductListAPI] Processed Image: ${first.smallImage.displayImageUrl}',
            name: 'ProductListAPI',
          );
        }

        return response;
      },
      dataKey: 'products',
    );

    return result;
  }
}
