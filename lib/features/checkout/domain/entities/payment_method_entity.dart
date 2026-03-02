/// Payment Method Entity
/// Represents a payment method available for checkout
class PaymentMethodEntity {
  final String id;
  final String name;
  final String code;
  final String? image;
  final bool isActive;
  final int sortOrder;

  const PaymentMethodEntity({
    required this.id,
    required this.name,
    required this.code,
    this.image,
    required this.isActive,
    required this.sortOrder,
  });

  PaymentMethodEntity copyWith({
    String? id,
    String? name,
    String? code,
    String? image,
    bool? isActive,
    int? sortOrder,
  }) {
    return PaymentMethodEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentMethodEntity &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.image == image &&
        other.isActive == isActive &&
        other.sortOrder == sortOrder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        image.hashCode ^
        isActive.hashCode ^
        sortOrder.hashCode;
  }
}
