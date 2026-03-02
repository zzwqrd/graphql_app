import '../../../../core/utils/image_url_helper.dart';

class ModelsCategories {
  final List<CategoryItem> items;

  ModelsCategories({required this.items});

  factory ModelsCategories.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final categories = data['categories'] ?? data;

    return ModelsCategories(
      items:
          (categories['items'] as List<dynamic>?)
              ?.map((e) => CategoryItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class CategoryItem {
  final String uid;
  final int id;
  final String name;
  final List<CategoryItem> children;
  final ProductList products;
  final String? image;

  CategoryItem({
    required this.uid,
    required this.id,
    required this.name,
    required this.children,
    required this.products,
    this.image,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      uid: json['uid']?.toString() ?? '',
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      children: _parseChildren(json['children']),
      products: json['products'] != null
          ? ProductList.fromJson(json['products'])
          : ProductList(items: []),
    );
  }
  String get displayImageUrl => image?.bestImageUrl ?? '';
  static List<CategoryItem> _parseChildren(dynamic childrenData) {
    if (childrenData == null) return [];

    if (childrenData is List) {
      return childrenData
          .where((item) => item is Map<String, dynamic>)
          .map((item) => CategoryItem.fromJson(item))
          .toList();
    }

    return [];
  }
}

class ProductList {
  final List<ProductItem> items;

  ProductList({required this.items});

  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ProductItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ProductItem {
  final String uid;
  final String name;
  final String sku;
  final String? smallImage;

  ProductItem({
    required this.uid,
    required this.name,
    required this.sku,
    this.smallImage,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    // التعامل مع البيانات المتداخلة
    dynamic smallImageData = json['small_image'];
    String? imageUrl;

    if (smallImageData is Map<String, dynamic>) {
      imageUrl = smallImageData['url'];
    } else if (smallImageData is String) {
      imageUrl = smallImageData;
    }

    return ProductItem(
      uid: json['uid']?.toString() ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      smallImage: imageUrl,
    );
  }
  String get displayImageUrl => smallImage?.bestImageUrl ?? '';
}
