import '../../../product_list/data/models/product_model.dart';
import 'home_category_model.dart';
import 'section_model.dart';
import 'slider_model.dart';

class HomeResponse {
  final List<HomeSliderModel> sliders;
  final List<HomeSectionModel> sections;
  final List<HomeCategoryModel> categories;
  final List<ProductModel> bestSellerProducts;
  final List<ProductModel> mostSearchedProducts;
  final List<ProductModel> newArrivalsProducts;
  final List<ProductModel> specialOffersProducts;
  final List<PromotionalBanner> promotionalBanners;

  HomeResponse({
    required this.sliders,
    required this.sections,
    required this.categories,
    required this.bestSellerProducts,
    required this.mostSearchedProducts,
    required this.newArrivalsProducts,
    required this.specialOffersProducts,
    required this.promotionalBanners,
  });

  /// 📐 Helper to find a section title from CMS sections or fallback
  String getTitle(HomeSectionType type, {required String fallback}) {
    try {
      return sections.firstWhere((s) => s.type == type).title;
    } catch (_) {
      return fallback;
    }
  }
}
