class OrderData {
  final int totalCount;
  final List<OrderModel> items;

  OrderData({required this.totalCount, required this.items});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      totalCount: json['total_count'] ?? 0,
      items:
          (json['items'] as List?)
              ?.map((e) => OrderModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String createdAt;
  final String status;
  final double grandTotal;
  final int totalItemCount;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.status,
    required this.grandTotal,
    required this.totalItemCount,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      createdAt: json['created_at'] ?? '',
      status: json['status'] ?? '',
      grandTotal: (json['grand_total'] is num)
          ? (json['grand_total'] as num).toDouble()
          : 0.0,
      totalItemCount: json['total_item_count'] ?? 0,
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'created_at': createdAt,
      'status': status,
      'grand_total': grandTotal,
      'total_item_count': totalItemCount,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class OrderItemModel {
  final String productName;
  final String productSku;
  final Money? productSalePrice;
  final double quantityOrdered;

  OrderItemModel({
    required this.productName,
    required this.productSku,
    this.productSalePrice,
    required this.quantityOrdered,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productName: json['product_name'] ?? '',
      productSku: json['product_sku'] ?? '',
      productSalePrice: json['product_sale_price'] != null
          ? Money.fromJson(json['product_sale_price'])
          : null,
      quantityOrdered: (json['quantity_ordered'] is num)
          ? (json['quantity_ordered'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'product_sku': productSku,
      'product_sale_price': productSalePrice?.toJson(),
      'quantity_ordered': quantityOrdered,
    };
  }
}

class Money {
  final double value;
  final String currency;

  Money({required this.value, required this.currency});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      value: (json['value'] is num) ? (json['value'] as num).toDouble() : 0.0,
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'currency': currency};
  }
}
