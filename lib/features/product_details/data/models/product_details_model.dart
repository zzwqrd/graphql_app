import '../../../../core/utils/image_url_helper.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../product_list/data/models/product_model.dart';

class ProductDetailsModel {
  final String uid;
  final String name;
  final String sku;
  final String? smallImage;
  final PriceRange priceRange;
  final String stockStatus;
  final String description; // HTML
  final List<MediaGalleryEntry> mediaGallery;
  final double ratingSummary;
  final int reviewCount;
  final List<ReviewModel> reviews;

  ProductDetailsModel({
    required this.uid,
    required this.name,
    required this.sku,
    this.smallImage,
    required this.priceRange,
    required this.stockStatus,
    required this.description,
    required this.mediaGallery,
    required this.ratingSummary,
    required this.reviewCount,
    required this.reviews,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Extract small_image URL
    String? imageUrl;
    if (json['small_image'] != null) {
      final smallImageData = json['small_image'];
      if (smallImageData is Map<String, dynamic>) {
        imageUrl = smallImageData['url']?.toString();
      } else if (smallImageData is String) {
        imageUrl = smallImageData;
      }
    }

    return ProductDetailsModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      smallImage: imageUrl,
      priceRange: PriceRange.fromJson(json['price_range'] ?? {}),
      stockStatus: json['stock_status'] ?? 'OUT_OF_STOCK',
      description: json['description'] != null
          ? json['description']['html'] ?? ''
          : '',
      mediaGallery:
          (json['media_gallery'] as List<dynamic>?)
              ?.map((e) => MediaGalleryEntry.fromJson(e))
              .toList() ??
          [],
      ratingSummary: (json['rating_summary'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      reviews:
          (json['reviews']?['items'] as List<dynamic>?)
              ?.map((e) => ReviewModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Use ImageUrlHelper extension to get the best image URL
  String get displayImageUrl => smallImage.bestImageUrl;

  String get localizedName => trValue(
    ar: name,
    en: name,
  ); // TODO: Add specific Arabic field if available in API

  ProductModel toProductModel() {
    return ProductModel(
      id: null,
      uid: uid,
      name: name,
      sku: sku,
      smallImage: SmallImage(url: displayImageUrl),
      priceRange: priceRange,
      stockStatus: stockStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'sku': sku,
      'small_image': {'url': smallImage},
      'price_range': priceRange.toJson(),
      'stock_status': stockStatus,
      'description': description,
      'media_gallery': mediaGallery.map((e) => e.toJson()).toList(),
      'rating_summary': ratingSummary,
      'review_count': reviewCount,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}

class ReviewModel {
  final String summary;
  final String text;
  final String createdAt;
  final String nickname;
  final double averageRating;

  ReviewModel({
    required this.summary,
    required this.text,
    required this.createdAt,
    required this.nickname,
    required this.averageRating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      summary: json['summary'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
      nickname: json['nickname'] ?? 'Anonymous',
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary,
      'text': text,
      'created_at': createdAt,
      'nickname': nickname,
      'average_rating': averageRating,
    };
  }
}

class MediaGalleryEntry {
  final String url;
  final String label;

  MediaGalleryEntry({required this.url, required this.label});

  factory MediaGalleryEntry.fromJson(Map<String, dynamic> json) {
    return MediaGalleryEntry(
      url: json['url'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'label': label};
  }

  /// Use ImageUrlHelper extension to get the best image URL
  String get displayImageUrl => url.bestImageUrl;
}

class ProductDetailsResponse {
  final List<ProductDetailsModel> items;

  ProductDetailsResponse({required this.items});

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailsResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ProductDetailsModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
