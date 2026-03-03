import 'package:dartz/dartz.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/enhanced_slider_model.dart';

class HomeNewArrivalsRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, EnhancedSliderOutput>>
  getEnhancedSliderProducts(String sliderName) async {
    return await graphQLQuery(
      '''
      query getEnhancedSliderProducts(\$slider_name: String!) {
        getEnhancedSliderProducts(slider_name: \$slider_name) {
          slider_id
          title
          slider_name
          slider_name_arabic
          display_title
          discover_all
          status
          description
          type
          products_number
          items {
            id
            sku
            name
            stock_status
            image
            average_rating
            rating_count
            customAttributesAjmalData {
              display_category
              display_size
              gender
              arabic_product_name
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
          }
        }
      }
      ''',
      variables: {'slider_name': sliderName},
      dataKey: 'getEnhancedSliderProducts',
      fromJson: (json) {
        // Since the dataKey pulls the content of getEnhancedSliderProducts directly
        // we can cast it as Map<String, dynamic> and parse
        return EnhancedSliderOutput.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
