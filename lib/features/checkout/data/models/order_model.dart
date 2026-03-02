import '../../domain/entities/order_entity.dart';

/// Order Item Model
class OrderItemModel {
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

  const OrderItemModel({
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      sku: json['sku']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      oldPrice: double.tryParse(json['old_price']?.toString() ?? '0') ?? 0.0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      variationNames: json['variation_names']?.toString(),
      variationId: json['variation_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'image': image,
      'sku': sku,
      'quantity': quantity,
      'price': price,
      'old_price': oldPrice,
      'discount': discount,
      'tax': tax,
      'subtotal': subtotal,
      'total': total,
      'variation_names': variationNames,
      'variation_id': variationId,
    };
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      productId: productId,
      name: name,
      image: image,
      sku: sku,
      quantity: quantity,
      price: price,
      oldPrice: oldPrice,
      discount: discount,
      tax: tax,
      subtotal: subtotal,
      total: total,
      variationNames: variationNames,
      variationId: variationId,
    );
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      productId: entity.productId,
      name: entity.name,
      image: entity.image,
      sku: entity.sku,
      quantity: entity.quantity,
      price: entity.price,
      oldPrice: entity.oldPrice,
      discount: entity.discount,
      tax: entity.tax,
      subtotal: entity.subtotal,
      total: entity.total,
      variationNames: entity.variationNames,
      variationId: entity.variationId,
    );
  }
}

/// Order Model
class OrderModel {
  final String? id;
  final String? orderNumber;
  final double subtotal;
  final double tax;
  final double shippingCharge;
  final double discount;
  final double total;
  final String paymentMethodId;
  final String paymentMethodCode;
  final String orderType;
  final String? shippingAddressId;
  final String? billingAddressId;
  final String? outletId;
  final String? couponId;
  final List<OrderItemModel> items;
  final String status;
  final DateTime? createdAt;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString(),
      orderNumber: json['order_number']?.toString(),
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      shippingCharge:
          double.tryParse(json['shipping_charge']?.toString() ?? '0') ?? 0.0,
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      paymentMethodId: json['payment_method_id']?.toString() ?? '',
      paymentMethodCode: json['payment_method_code']?.toString() ?? '',
      orderType: json['order_type']?.toString() ?? 'delivery',
      shippingAddressId: json['shipping_address_id']?.toString(),
      billingAddressId: json['billing_address_id']?.toString(),
      outletId: json['outlet_id']?.toString(),
      couponId: json['coupon_id']?.toString(),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      'subtotal': subtotal,
      'tax': tax,
      'shipping_charge': shippingCharge,
      'discount': discount,
      'total': total,
      'payment_method_id': paymentMethodId,
      'payment_method_code': paymentMethodCode,
      'order_type': orderType,
      if (shippingAddressId != null) 'shipping_address_id': shippingAddressId,
      if (billingAddressId != null) 'billing_address_id': billingAddressId,
      if (outletId != null) 'outlet_id': outletId,
      if (couponId != null) 'coupon_id': couponId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderNumber: orderNumber,
      subtotal: subtotal,
      tax: tax,
      shippingCharge: shippingCharge,
      discount: discount,
      total: total,
      paymentMethodId: paymentMethodId,
      paymentMethodCode: paymentMethodCode,
      orderType: orderType,
      shippingAddressId: shippingAddressId,
      billingAddressId: billingAddressId,
      outletId: outletId,
      couponId: couponId,
      items: items.map((item) => item.toEntity()).toList(),
      status: status,
      createdAt: createdAt,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      subtotal: entity.subtotal,
      tax: entity.tax,
      shippingCharge: entity.shippingCharge,
      discount: entity.discount,
      total: entity.total,
      paymentMethodId: entity.paymentMethodId,
      paymentMethodCode: entity.paymentMethodCode,
      orderType: entity.orderType,
      shippingAddressId: entity.shippingAddressId,
      billingAddressId: entity.billingAddressId,
      outletId: entity.outletId,
      couponId: entity.couponId,
      items: entity.items
          .map((item) => OrderItemModel.fromEntity(item))
          .toList(),
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
