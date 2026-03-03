import 'package:dartz/dartz.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/home_banner_slider_model.dart';

class HomeBannerRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, BannersSliderOutputHome>> getHomeBanners(
    String actionName,
  ) async {
    return await graphQLQuery(
      '''
      query GetHomeData(\$action_name: String!) {
        homeBannerSlider(action_name: \$action_name) {
          slider {
            slider_id name status location store_ids customer_group_ids priority effect autoWidth autoHeight design loop lazyLoad autoplay autoplayTimeout nav dots is_responsive responsive_items from_date to_date created_at updated_at
          }
          banners {
            banner_id name status type content banner_subtitle image url_banner home_slider_video title newtab product_skus updated_at created_at
          }
        }
      }
      ''',
      variables: {'action_name': "69"},
      dataKey: 'homeBannerSlider',
      fromJson: (json) =>
          BannersSliderOutputHome.fromJson(json as Map<String, dynamic>),
    );
  }
}
