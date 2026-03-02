import '../../domain/entities/payment_method_entity.dart';

/// Payment Method Model
/// Data model for payment methods from GraphQL
class PaymentMethodModel {
  final String id;
  final String name;
  final String code;
  final String? image;
  final bool isActive;
  final int sortOrder;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    required this.code,
    this.image,
    required this.isActive,
    required this.sortOrder,
  });

  /// Convert from JSON (GraphQL response)
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      image: json['image']?.toString(),
      isActive: json['is_active'] == true || json['isActive'] == true,
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? '0') ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'image': image,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }

  /// Convert to Entity
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      name: name,
      code: code,
      image: image,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  /// Convert from Entity
  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      name: entity.name,
      code: entity.code,
      image: entity.image,
      isActive: entity.isActive,
      sortOrder: entity.sortOrder,
    );
  }
}
