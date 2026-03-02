import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../models/product_details_model.dart';

class ProductDetailsRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, ProductDetailsResponse>> getProductDetails(
    String sku,
  ) async {
    dev.log(
      '🔍 [ProductDetailsAPI] Fetching product: $sku',
      name: 'ProductDetailsAPI',
    );

    // 1. Determine if input is numeric ID or SKU
    final isNumeric = int.tryParse(sku) != null;
    // 2. Fragment to ensure consistent fields
    const fragment = '''
      items {
          __typename
          uid
          id
          name
          sku
          stock_status
          small_image {
            url
          }
          price_range {
            minimum_price {
              regular_price {
                value
                currency
              }
              final_price {
                value
                currency
              }
              discount {
                amount_off
                percent_off
              }
            }
          }
          description {
            html
          }
          media_gallery {
            url
            label
          }
          rating_summary
          review_count
          reviews {
            items {
              summary
              text
              created_at
              nickname
              average_rating
            }
          }
        }
    ''';
    // 3. Primary Query construction
    String query;
    if (isNumeric) {
      // 'entity_id' is not supported in filter by some Magento schemas.
      // Fallback to 'search' which often indexes ID.
      query = 'query { products(search: "$sku") { $fragment } }';
    } else {
      // For SKUs, robust filtering is best
      query =
          'query { products(filter: { sku: { eq: "$sku" } }) { $fragment } }';
    }

    final result = await graphQLQuery(
      query,
      fromJson: (json) {
        dev.log(
          '📦 [ProductDetailsAPI] Raw Response: ${json.toString().substring(0, json.toString().length > 500 ? 500 : json.toString().length)}...',
          name: 'ProductDetailsAPI',
        );

        final model = ProductDetailsResponse.fromJson(json);

        // Debug product details
        if (model.items.isNotEmpty) {
          final product = model.items.first;
          dev.log(
            '🛍️ [ProductDetailsAPI] Product: ${product.name}',
            name: 'ProductDetailsAPI',
          );
          dev.log(
            '🖼️ [ProductDetailsAPI] Small image raw: ${product.smallImage}',
            name: 'ProductDetailsAPI',
          );
          dev.log(
            '🖼️ [ProductDetailsAPI] Small image processed: ${product.displayImageUrl}',
            name: 'ProductDetailsAPI',
          );
          dev.log(
            '🖼️ [ProductDetailsAPI] Media gallery count: ${product.mediaGallery.length}',
            name: 'ProductDetailsAPI',
          );

          if (product.mediaGallery.isNotEmpty) {
            dev.log(
              '🖼️ [ProductDetailsAPI] First gallery image raw: ${product.mediaGallery.first.url}',
              name: 'ProductDetailsAPI',
            );
            dev.log(
              '🖼️ [ProductDetailsAPI] First gallery image processed: ${product.mediaGallery.first.displayImageUrl}',
              name: 'ProductDetailsAPI',
            );
          }
        }

        return model;
      },
      dataKey: 'products',
    );

    return result.fold(
      (failure) async {
        dev.log(
          '❌ [ProductDetailsAPI] Primary query failed: ${failure.message}',
          name: 'ProductDetailsAPI',
        );

        // 4. Fallback: Search query if primary lookup failed (only for SKUs)
        if (!isNumeric) {
          dev.log(
            '🔄 [ProductDetailsAPI] Trying fallback search...',
            name: 'ProductDetailsAPI',
          );

          final sRes = await graphQLQuery(
            'query { products(search: "$sku") { $fragment } }',
            fromJson: (json) {
              dev.log(
                '📦 [ProductDetailsAPI] Fallback Response: ${json.toString().substring(0, json.toString().length > 300 ? 300 : json.toString().length)}...',
                name: 'ProductDetailsAPI',
              );
              return ProductDetailsResponse.fromJson(json);
            },
            dataKey: 'products',
          );
          return sRes.fold(
            (r) {
              dev.log(
                '❌ [ProductDetailsAPI] Fallback also failed',
                name: 'ProductDetailsAPI',
              );
              return Left(r);
            },
            (r) {
              if (r.items.isNotEmpty) {
                dev.log(
                  '✅ [ProductDetailsAPI] Fallback Success!',
                  name: 'ProductDetailsAPI',
                );
                return Right(r);
              } else {
                dev.log(
                  '❌ [ProductDetailsAPI] Fallback returned empty',
                  name: 'ProductDetailsAPI',
                );
                return Left(failure);
              }
            },
          );
        }
        return Left(failure);
      },
      (response) {
        if (response.items.isEmpty && !isNumeric) {
          dev.log(
            '⚠️ [ProductDetailsAPI] Empty response, trying search fallback...',
            name: 'ProductDetailsAPI',
          );

          // Retry with search if filter returned empty but no error
          return graphQLQuery(
            'query { products(search: "$sku") { $fragment } }',
            fromJson: (json) {
              dev.log(
                '📦 [ProductDetailsAPI] Search Fallback Response: ${json.toString().substring(0, json.toString().length > 300 ? 300 : json.toString().length)}...',
                name: 'ProductDetailsAPI',
              );
              return ProductDetailsResponse.fromJson(json);
            },
            dataKey: 'products',
          );
        }

        dev.log(
          '✅ [ProductDetailsAPI] Success: ${response.items.length} products found',
          name: 'ProductDetailsAPI',
        );
        return Right(response);
      },
    );
  }
}
