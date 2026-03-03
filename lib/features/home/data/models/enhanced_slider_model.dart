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
      items: json['items'] != null
          ? (json['items'] as List)
                .map(
                  (i) => EnhancedSliderItem.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : [],
    );
  }
}

class EnhancedSliderItem {
  final String uid; // Fallback from id or SKU if uid missing
  final String sku;
  final String name;
  final String image;
  final PriceRange priceRange;
  final String stockStatus;
  final CustomAttributesAjmalData? customAttributes;
  final double averageRating;
  final int ratingCount;

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
  });

  factory EnhancedSliderItem.fromJson(Map<String, dynamic> json) {
    // Attempting to extract single custom attribute item
    CustomAttributesAjmalData? customAttrs;
    if (json['customAttributesAjmalData'] != null &&
        (json['customAttributesAjmalData'] as List).isNotEmpty) {
      customAttrs = CustomAttributesAjmalData.fromJson(
        (json['customAttributesAjmalData'] as List).first
            as Map<String, dynamic>,
      );
    }

    double calcAvgRating = 0.0;
    if (json['average_rating'] != null) {
      calcAvgRating = (json['average_rating'] as num).toDouble();
      // If the backend returns percentage out of 100, convert to 5 star scale
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
      image: (json['image'] as String?)?.bestImageUrl ?? '',
      priceRange: PriceRange.fromJson(json['price_range'] ?? {}),
      stockStatus: json['stock_status'] ?? 'OUT_OF_STOCK',
      customAttributes: customAttrs,
      averageRating: calcAvgRating,
      ratingCount: ratCount,
    );
  }
}

class CustomAttributesAjmalData {
  final String? displayCategory;
  final String? displaySize;
  final String? gender;
  final String? arabicProductName;

  CustomAttributesAjmalData({
    this.displayCategory,
    this.displaySize,
    this.gender,
    this.arabicProductName,
  });

  factory CustomAttributesAjmalData.fromJson(Map<String, dynamic> json) {
    return CustomAttributesAjmalData(
      displayCategory: json['display_category'] as String?,
      displaySize: json['display_size'] as String?,
      gender: json['gender'] as String?,
      arabicProductName: json['arabic_product_name'] as String?,
    );
  }
}
