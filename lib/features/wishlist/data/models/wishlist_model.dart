import '../../../product_list/data/models/product_model.dart';

class WishlistModel {
  final String id;
  final int itemsCount;
  final List<WishlistItemModel> items;

  WishlistModel({
    required this.id,
    required this.itemsCount,
    required this.items,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      id: json['id'] ?? '',
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      items:
          (json['items_v2']['items'] as List<dynamic>?)
              ?.map((e) => WishlistItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class WishlistItemModel {
  final String id;
  final ProductModel product;

  WishlistItemModel({required this.id, required this.product});

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] ?? '',
      product: ProductModel.fromJson(json['product'] ?? {}),
    );
  }
}
