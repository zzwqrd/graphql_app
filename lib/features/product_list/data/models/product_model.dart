import '../../../../core/utils/image_url_helper.dart';

enum SortOption {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  positionAsc,
  positionDesc,
}

class ProductModel {
  final String uid;
  final dynamic id;
  final String name;
  final String sku;
  final SmallImage smallImage;
  final PriceRange priceRange;
  final String stockStatus;
  final double? specialPrice;
  final String? newFromDate;
  final String? newToDate;

  ProductModel({
    required this.uid,
    required this.id,
    required this.name,
    required this.sku,
    required this.smallImage,
    required this.priceRange,
    required this.stockStatus,
    this.specialPrice,
    this.newFromDate,
    this.newToDate,
  });

  ProductModel copyWith({
    String? uid,
    dynamic id,
    String? name,
    String? sku,
    SmallImage? smallImage,
    PriceRange? priceRange,
    String? stockStatus,
    double? specialPrice,
    String? newFromDate,
    String? newToDate,
  }) {
    return ProductModel(
      uid: uid ?? this.uid,
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      smallImage: smallImage ?? this.smallImage,
      priceRange: priceRange ?? this.priceRange,
      stockStatus: stockStatus ?? this.stockStatus,
      specialPrice: specialPrice ?? this.specialPrice,
      newFromDate: newFromDate ?? this.newFromDate,
      newToDate: newToDate ?? this.newToDate,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      uid: json['uid']?.toString() ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      smallImage: SmallImage.fromJson(json['small_image'] ?? {}),
      priceRange: PriceRange.fromJson(json['price_range'] ?? {}),
      stockStatus: json['stock_status'] ?? 'OUT_OF_STOCK',
      specialPrice: (json['special_price'] as num?)?.toDouble(),
      newFromDate: json['new_from_date'],
      newToDate: json['new_to_date'],
    );
  }

  factory ProductModel.empty() {
    return ProductModel(
      uid: '',
      id: '',
      name: '',
      sku: '',
      smallImage: SmallImage(url: ''),
      priceRange: PriceRange.empty(),
      stockStatus: 'OUT_OF_STOCK',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'sku': sku,
      'small_image': smallImage.toJson(),
      'price_range': priceRange.toJson(),
      'stock_status': stockStatus,
      'special_price': specialPrice,
      'new_from_date': newFromDate,
      'new_to_date': newToDate,
    };
  }

  bool get isNew {
    if (newFromDate == null && newToDate == null) return false;
    final now = DateTime.now();
    try {
      final from = newFromDate != null ? DateTime.parse(newFromDate!) : null;
      final to = newToDate != null ? DateTime.parse(newToDate!) : null;
      if (from != null && now.isBefore(from)) return false;
      if (to != null && now.isAfter(to)) return false;
      return true;
    } catch (_) {
      return false;
    }
  }

  bool get hasDiscount =>
      priceRange.minimumPrice.discount.hasDiscount ||
      (specialPrice != null &&
          specialPrice! < priceRange.minimumPrice.regularPrice.value);

  String get localizedName => name;
}

class SmallImage {
  final String url;

  SmallImage({required this.url});

  factory SmallImage.fromJson(Map<String, dynamic> json) {
    return SmallImage(url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'url': url};
  }

  String get displayImageUrl => url?.bestImageUrl ?? '';
}

class PriceRange {
  final Price minimumPrice;

  PriceRange({required this.minimumPrice});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      minimumPrice: Price.fromJson(json['minimum_price'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'minimum_price': minimumPrice.toJson()};
  }

  factory PriceRange.empty() {
    return PriceRange(minimumPrice: Price.empty());
  }
}

class Price {
  final Money regularPrice;
  final Money finalPrice;
  final Discount discount;

  Price({
    required this.regularPrice,
    required this.finalPrice,
    required this.discount,
  });

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      regularPrice: Money.fromJson(json['regular_price'] ?? {}),
      finalPrice: Money.fromJson(json['final_price'] ?? {}),
      discount: Discount.fromJson(json['discount'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'regular_price': regularPrice.toJson(),
      'final_price': finalPrice.toJson(),
      'discount': discount.toJson(),
    };
  }

  factory Price.empty() {
    return Price(
      regularPrice: Money(value: 0.0, currency: 'SAR'),
      finalPrice: Money(value: 0.0, currency: 'SAR'),
      discount: Discount(amountOff: 0.0, percentOff: 0.0),
    );
  }
}

class Money {
  final double value;
  final String currency;

  Money({required this.value, required this.currency});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      value: _tryParseDouble(json['value']),
      currency: json['currency']?.toString() ?? 'SAR',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'currency': currency};
  }

  String get formatted => value.toStringAsFixed(2);
}

double _tryParseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

class Discount {
  final double amountOff;
  final double percentOff;

  Discount({required this.amountOff, required this.percentOff});

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      amountOff: _tryParseDouble(json['amount_off']),
      percentOff: _tryParseDouble(json['percent_off']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount_off': amountOff, 'percent_off': percentOff};
  }

  bool get hasDiscount => percentOff > 0 || amountOff > 0;
}

class Aggregation {
  final String attributeCode;
  final String label;
  final List<AggregationOption> options;

  Aggregation({
    required this.attributeCode,
    required this.label,
    required this.options,
  });

  factory Aggregation.fromJson(Map<String, dynamic> json) {
    return Aggregation(
      attributeCode: json['attribute_code'] ?? '',
      label: json['label'] ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => AggregationOption.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AggregationOption {
  final String label;
  final String value;
  final int count;

  AggregationOption({
    required this.label,
    required this.value,
    required this.count,
  });

  factory AggregationOption.fromJson(Map<String, dynamic> json) {
    return AggregationOption(
      label: json['label'] ?? '',
      value: json['value']?.toString() ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProductListResponse {
  final List<ProductModel> items;
  final List<Aggregation> aggregations;

  ProductListResponse({required this.items, required this.aggregations});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e))
              .toList() ??
          [],
      aggregations:
          (json['aggregations'] as List<dynamic>?)
              ?.map((e) => Aggregation.fromJson(e))
              .toList() ??
          [],
    );
  }
}
