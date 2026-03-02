// models/categories.dart
class ModelsCategories {
  final List<CategoryItem>? items;

  ModelsCategories({this.items});

  factory ModelsCategories.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;

    return ModelsCategories(
      items: itemsList?.map((item) => CategoryItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((item) => item.toJson()).toList(),
  };
}

class CategoryItem {
  final String? name;
  final Products? products;
  final List<Children>? children;

  CategoryItem({this.name, this.products, this.children});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      name: json['name'],
      products: json['products'] != null
          ? Products.fromJson(json['products'])
          : null,
      children: json['children'] != null
          ? (json['children'] as List)
                .map((child) => Children.fromJson(child))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'products': products?.toJson(),
    'children': children?.map((child) => child.toJson()).toList(),
  };
}

class Products {
  final List<ProductItem>? items;

  Products({this.items});

  factory Products.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;

    return Products(
      items: itemsList?.map((item) => ProductItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((item) => item.toJson()).toList(),
  };
}

class ProductItem {
  final String? name;
  final SmallImage? smallImage;

  ProductItem({this.name, this.smallImage});

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
      name: json['name'],
      smallImage: json['small_image'] != null
          ? SmallImage.fromJson(json['small_image'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'small_image': smallImage?.toJson(),
  };
}

class SmallImage {
  final String? url;

  SmallImage({this.url});

  factory SmallImage.fromJson(Map<String, dynamic> json) {
    return SmallImage(url: json['url']);
  }

  Map<String, dynamic> toJson() => {'url': url};

  String get imageUrl {
    if (url == null || url!.isEmpty) return '';

    // If it's an S3 URL, extract the path and proxy through main site
    if (url!.contains('-media-bucket.s3')) {
      final uri = Uri.parse(url!);
      final path = uri.path;
      return 'https://ar-qa.ajmal.com/media$path';
    }

    // If it's already a full URL (but not S3), return as is
    if (url!.startsWith('http')) return url!;

    // If it's a relative path, add base URL
    String path = url!;
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return 'https://ar-qa.ajmal.com$path';
  }
}

class Children {
  final String? name;
  final String? image;

  Children({this.name, this.image});

  factory Children.fromJson(Map<String, dynamic> json) {
    return Children(name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() => {'name': name, 'image': image};

  String? get imageUrl {
    if (image == null || image!.isEmpty) return null;

    // If it's an S3 URL, extract the path and proxy through main site
    if (image!.contains('-media-bucket.s3')) {
      final uri = Uri.parse(image!);
      final path = uri.path;
      return 'https://ar-qa.ajmal.com/media$path';
    }

    // If it's already a full URL (but not S3), return as is
    if (image!.startsWith('http')) return image;

    // If it's a relative path, add base URL
    String path = image!;
    if (!path.startsWith('/')) {
      if (!path.contains('/')) {
        path = '/media/catalog/category/$path';
      } else {
        path = '/$path';
      }
    }
    return 'https://ar-qa.ajmal.com$path';
  }
}
