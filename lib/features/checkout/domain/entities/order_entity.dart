/// Order Item Entity
/// Represents a single item in an order
class OrderItemEntity {
  final String productId;
  final String name;
  final String? image;
  final String sku;
  final int quantity;
  final double price;
  final double oldPrice;
  final double discount;
  final double tax;
  final double subtotal;
  final double total;
  final String? variationNames;
  final String? variationId;

  const OrderItemEntity({
    required this.productId,
    required this.name,
    this.image,
    required this.sku,
    required this.quantity,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.tax,
    required this.subtotal,
    required this.total,
    this.variationNames,
    this.variationId,
  });

  OrderItemEntity copyWith({
    String? productId,
    String? name,
    String? image,
    String? sku,
    int? quantity,
    double? price,
    double? oldPrice,
    double? discount,
    double? tax,
    double? subtotal,
    double? total,
    String? variationNames,
    String? variationId,
  }) {
    return OrderItemEntity(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      subtotal: subtotal ?? this.subtotal,
      total: total ?? this.total,
      variationNames: variationNames ?? this.variationNames,
      variationId: variationId ?? this.variationId,
    );
  }
}

/// Order Entity
/// Represents a complete order with all details
class OrderEntity {
  final String? id;
  final String? orderNumber;
  final double subtotal;
  final double tax;
  final double shippingCharge;
  final double discount;
  final double total;
  final String paymentMethodId;
  final String paymentMethodCode;
  final String orderType; // delivery/pickup
  final String? shippingAddressId;
  final String? billingAddressId;
  final String? outletId;
  final String? couponId;
  final List<OrderItemEntity> items;
  final String status;
  final DateTime? createdAt;

  const OrderEntity({
    this.id,
    this.orderNumber,
    required this.subtotal,
    required this.tax,
    required this.shippingCharge,
    required this.discount,
    required this.total,
    required this.paymentMethodId,
    required this.paymentMethodCode,
    required this.orderType,
    this.shippingAddressId,
    this.billingAddressId,
    this.outletId,
    this.couponId,
    required this.items,
    this.status = 'pending',
    this.createdAt,
  });

  OrderEntity copyWith({
    String? id,
    String? orderNumber,
    double? subtotal,
    double? tax,
    double? shippingCharge,
    double? discount,
    double? total,
    String? paymentMethodId,
    String? paymentMethodCode,
    String? orderType,
    String? shippingAddressId,
    String? billingAddressId,
    String? outletId,
    String? couponId,
    List<OrderItemEntity>? items,
    String? status,
    DateTime? createdAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shippingCharge: shippingCharge ?? this.shippingCharge,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentMethodCode: paymentMethodCode ?? this.paymentMethodCode,
      orderType: orderType ?? this.orderType,
      shippingAddressId: shippingAddressId ?? this.shippingAddressId,
      billingAddressId: billingAddressId ?? this.billingAddressId,
      outletId: outletId ?? this.outletId,
      couponId: couponId ?? this.couponId,
      items: items ?? this.items,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
