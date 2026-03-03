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
    infinite
    speed
    autoplay
    autoplay_speed
    rtl
    display_price
    display_cart
    display_wishlist
    display_compare
    products_number
    items {
      id
      sku
      name
      qty
      type_id
      stock_status
      attribute_set_id
      has_options
      required_options
      created_at
      updated_at
      row_id
      created_in
      updated_in
      status
      visibility
      tax_class_id
      short_description
      meta_keyword
      meta_title
      meta_description
      image
      small_image
      swatch_image
      thumbnail
      page_layout
      options_container
      url_key
      msrp_display_actual_price_type
      gift_message_available
      gift_wrapping_available
      is_returnable
      weight
      is_salable
      rating_count
      special_price
      average_rating
      media_gallery {
        disabled
        label
        position
        url
        __typename
      }
      customAttributesAjmalData {
        top_note_name
        top_note_image
        heart_note_name
        heart_note_image
        base_note_name
        base_note_image
        display_category
        product_video_url
        product_video_link
        display_size
        gender
        product_lasting_hours
        ingredient
        product_color
        arabic_product_name
        arabic_short_description
        slider_video
        can_be_returned
        promotion_text
        available_for_pickup
        __typename
      }
      rating {
        vote_id
        value
        percent
        __typename
      }
      price_range {
        minimum_price {
          regular_price {
            value
            currency
            __typename
          }
          final_price {
            value
            currency
            __typename
          }
          discount {
            amount_off
            percent_off
            __typename
          }
          __typename
        }
        maximum_price {
          regular_price {
            value
            currency
            __typename
          }
          final_price {
            value
            currency
            __typename
          }
          discount {
            amount_off
            percent_off
            __typename
          }
          __typename
        }
        __typename
      }
      price_tiers {
        quantity
        final_price {
          value
          currency
          __typename
        }
        __typename
      }
      ... on SliderConfigurableProduct {
        configurable_options {
          id
          attribute_id
          label
          attribute_code
          values {
            value_index
            label
            swatch_data {
              value
              __typename
            }
            __typename
          }
          __typename
        }
        variants {
          product {
            id
            sku
            name
            stock_status
            image {
              url
              __typename
            }
            price_range {
              minimum_price {
                regular_price {
                  value
                  currency
                  __typename
                }
                final_price {
                  value
                  currency
                  __typename
                }
                discount {
                  amount_off
                  percent_off
                  __typename
                }
                __typename
              }
              maximum_price {
                regular_price {
                  value
                  currency
                  __typename
                }
                final_price {
                  value
                  currency
                  __typename
                }
                discount {
                  amount_off
                  percent_off
                  __typename
                }
                __typename
              }
              __typename
            }
            __typename
          }
          attributes {
            code
            value_index
            label
            __typename
          }
          __typename
        }
        __typename
      }
      ... on SliderBundleProduct {
        dynamic_sku
        dynamic_price
        dynamic_weight
        items {
          option_id
          title
          sku
          type
          required
          position
          options {
            id
            uid
            label
            quantity
            price
            position
            product {
              id
              uid
              name
              sku
              image {
                url
                __typename
              }
              url_key
              stock_status
              rating_summary
              review_count
              customAttributesAjmalData {
                top_note_name
                top_note_image
                heart_note_name
                product_about_video_link
                heart_note_image
                base_note_name
                base_note_image
                display_category
                display_size
                gender
                bundle_type
                product_lasting_hours
                ingredient
                how_to_use
                when_to_use
                product_about
                blog_tag
                amber_name
                amber_image
                ambergris_name
                ambergris_image
                bergamot_orange_name
                bergamot_orange_image
                patchouli_name
                patchouli_image
                citrus_name
                citrus_image
                linalool_name
                linalool_image
                muskmallow_name
                muskmallow_image
                oakmoss_name
                oakmoss_image
                oud_name
                oud_image
                ylang_yang_name
                ylang_yang_image
                custom_review
                product_video_url
                product_video_link
                error
                arabic_product_name
                arabic_short_description
                arabic_description
                top_note_india
                heart_note_india
                base_note_india
                ingredients_india
                fragrance_family_india
                can_be_returned
                promotion_text
                available_for_pickup
                product_page_promo_text
                __typename
              }
              price_tiers {
                quantity
                final_price {
                  value
                  currency
                  __typename
                }
                __typename
              }
              price_range {
                minimum_price {
                  discount {
                    amount_off
                    percent_off
                    __typename
                  }
                  fixed_product_taxes {
                    amount {
                      currency
                      value
                      __typename
                    }
                    label
                    __typename
                  }
                  final_price {
                    currency
                    value
                    __typename
                  }
                  regular_price {
                    currency
                    value
                    __typename
                  }
                  __typename
                }
                __typename
              }
              __typename
            }
            __typename
          }
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
  }
}
      ''',
      variables: {'slider_name': sliderName},
      dataKey: 'getEnhancedSliderProducts',
      fromJson: (json) {
        return EnhancedSliderOutput.fromJson(json as Map<String, dynamic>);
      },
    );
  }
}
