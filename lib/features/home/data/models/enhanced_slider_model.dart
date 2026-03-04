import 'package:graphql_app/core/routes/go_router_config.dart';

import '../../../../features/product_list/data/models/product_model.dart';
import '../../../../core/utils/image_url_helper.dart';

class EnhancedSliderOutput {
  final int? sliderId;
  final String? title;
  final String? sliderName;
  final String? sliderNameArabic;
  final int? displayTitle;
  final String? discoverAll;
  final int? status;
  final String? description;
  final String? type;
  final int? productsNumber;
  final List<EnhancedSliderItem> items;

  EnhancedSliderOutput({
    this.sliderId,
    this.title,
    this.sliderName,
    this.sliderNameArabic,
    this.displayTitle,
    this.discoverAll,
    this.status,
    this.description,
    this.type,
    this.productsNumber,
    required this.items,
  });

  factory EnhancedSliderOutput.fromJson(Map<String, dynamic> json) {
    return EnhancedSliderOutput(
      sliderId: json['slider_id'] as int?,
      title: json['title'] as String?,
      sliderName: json['slider_name'] as String?,
      sliderNameArabic: json['slider_name_arabic'] as String?,
      displayTitle: json['display_title'] as int?,
      discoverAll: json['discover_all'] as String?,
      status: json['status'] as int?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      productsNumber: json['products_number'] as int?,
      items: (json['items'] is List)
          ? (json['items'] as List)
                .where((i) => i != null && i is Map<String, dynamic>)
                .map(
                  (i) => EnhancedSliderItem.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}

class EnhancedSliderItem {
  final String uid;
  final String sku;
  final String name;
  final String image;
  final PriceRange priceRange;
  final String stockStatus;
  final CustomAttributesAjmalData? customAttributes;
  final double averageRating;
  final int ratingCount;
  final List<ProductRating> ratings;

  EnhancedSliderItem({
    required this.uid,
    required this.sku,
    required this.name,
    required this.image,
    required this.priceRange,
    required this.stockStatus,
    this.customAttributes,
    this.averageRating = 0,
    this.ratingCount = 0,
    this.ratings = const [],
  });

  factory EnhancedSliderItem.fromJson(Map<String, dynamic> json) {
    CustomAttributesAjmalData? customAttrs;
    final dynamic ajmalData = json['customAttributesAjmalData'];
    if (ajmalData != null && ajmalData is List && ajmalData.isNotEmpty) {
      if (ajmalData.first != null && ajmalData.first is Map<String, dynamic>) {
        customAttrs = CustomAttributesAjmalData.fromJson(
          ajmalData.first as Map<String, dynamic>,
        );
      }
    }

    double calcAvgRating = 0.0;
    if (json['average_rating'] != null) {
      calcAvgRating = (json['average_rating'] as num).toDouble();
      if (calcAvgRating > 5) {
        calcAvgRating = calcAvgRating * 5 / 100;
      }
    }

    int ratCount = 0;
    if (json['rating_count'] != null) {
      ratCount = (json['rating_count'] as num).toInt();
    }

    return EnhancedSliderItem(
      uid: json['uid']?.toString() ?? json['id']?.toString() ?? '',
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      image: (json['image'] is String)
          ? (json['image'] as String).bestImageUrl
          : '',
      priceRange: PriceRange.fromJson(json['price_range'] ?? {}),
      stockStatus: json['stock_status'] ?? 'OUT_OF_STOCK',
      customAttributes: customAttrs,
      averageRating: calcAvgRating,
      ratingCount: ratCount,
      ratings: json['rating'] is List
          ? (json['rating'] as List)
                .where((r) => r != null && r is Map<String, dynamic>)
                .map((r) => ProductRating.fromJson(r as Map<String, dynamic>))
                .toList()
          : [],
    );
  }
}

class CustomAttributesAjmalData {
  final String? displayCategory;
  final String? displaySize;
  final String? gender;
  final String? arabicProductName;
  final String? availableForPickup;

  CustomAttributesAjmalData({
    this.displayCategory,
    this.displaySize,
    this.gender,
    this.arabicProductName,
    this.availableForPickup,
  });

  factory CustomAttributesAjmalData.fromJson(Map<String, dynamic> json) {
    return CustomAttributesAjmalData(
      displayCategory: json['display_category'] as String?,
      displaySize: json['display_size'] as String?,
      gender: json['gender'] as String?,
      arabicProductName: json['arabic_product_name'] as String?,
      availableForPickup: json['available_for_pickup'] as String?,
    );
  }
}

class ProductRating {
  final String? voteId;
  final String? value;
  final String? percent;

  ProductRating({this.voteId, this.value, this.percent});

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
      voteId: json['vote_id']?.toString(),
      value: json['value']?.toString(),
      percent: json['percent']?.toString(),
    );
  }
}
