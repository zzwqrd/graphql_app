class HomeSliderModel {
  final String image;
  final int width;
  final int height;

  HomeSliderModel({
    required this.image,
    required this.width,
    required this.height,
  });
}

class PromotionalBanner {
  final String imageUrl;
  final String linkUrl;
  final String? title;
  final String categoryId;
  final String categoryName;

  PromotionalBanner({
    required this.imageUrl,
    required this.linkUrl,
    this.title,
    this.categoryId = '',
    this.categoryName = '',
  });

  factory PromotionalBanner.fromJson(Map<String, dynamic> json) {
    return PromotionalBanner(
      imageUrl: json['image_url'] as String? ?? '',
      linkUrl: json['link_url'] as String? ?? '',
      title: json['title'] as String?,
      categoryId: json['id']?.toString() ?? '',
      categoryName: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'link_url': linkUrl,
      'title': title,
      'id': categoryId,
      'name': categoryName,
    };
  }
}
