enum HomeSectionType { bestSeller, featured, newProducts, custom, mostSearched, newArrivals, specialOffers }

class HomeSectionModel {
  final HomeSectionType type;
  final String title;

  /// Metadata للـ API
  /// مثال:
  /// { identifier: bestseller-products, limit: 10 }
  final Map<String, dynamic> meta;

  HomeSectionModel({
    required this.type,
    required this.title,
    required this.meta,
  });
}
