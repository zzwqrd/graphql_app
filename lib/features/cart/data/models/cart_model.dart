import 'cart_item_model.dart';

class CartModel {
  final String id;
  final List<CartItemModel> items;
  final double grandTotal;
  final int? totalQuantity;
  final bool isEmpty;

  CartModel({
    required this.id,
    required this.items,
    required this.grandTotal,
    this.totalQuantity = 0,
    this.isEmpty = false,
  });

  // إنشاء سلة فارغة
  factory CartModel.empty() => CartModel(
    id: '',
    items: [],
    grandTotal: 0.0,
    totalQuantity: 0,
    isEmpty: true,
  );

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // إذا كان JSON فارغاً
    if (json.isEmpty) {
      return CartModel.empty();
    }

    return CartModel(
      id: json['id']?.toString() ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      grandTotal:
          (json['prices']?['grand_total']?['value'] as num?)?.toDouble() ?? 0.0,
      totalQuantity: json['total_quantity'] as int? ?? 0,
      isEmpty: false,
    );
  }
}

class CartIdModel {
  final String id;

  const CartIdModel(this.id);

  // من JSON (مثلاً إذا أردت دعم استجابة على شكل object لاحقًا)
  factory CartIdModel.fromJson(Map<String, dynamic> json) {
    return CartIdModel(json['createEmptyCart'] as String);
  }

  // لكن للاستجابة الحالية (اللي هي string مباشرة)، نستخدم هذه:
  factory CartIdModel.fromRawString(String rawId) {
    return CartIdModel(rawId);
  }

  // للتوافق مع fromJson في graphQLMutation (إذا أردت استخدامه)
  static CartIdModel fromGraphQLData(dynamic data) {
    if (data is String) {
      return CartIdModel(data);
    } else if (data is Map<String, dynamic>) {
      return CartIdModel.fromJson(data);
    } else {
      throw const FormatException('Invalid data format for CartIdModel');
    }
  }

  @override
  String toString() => 'CartIdModel(id: $id)';
}
// import 'cart_item_model.dart';

// class CartModel {
//   final String id;
//   final List<CartItemModel> items;
//   final double grandTotal;

//   CartModel({required this.id, required this.items, required this.grandTotal});

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       id: json['id'] ?? '',
//       items: (json['items'] as List<dynamic>? ?? [])
//           .map((e) => CartItemModel.fromJson(e))
//           .toList(),
//       grandTotal:
//           (json['prices']?['grand_total']?['value'] as num?)?.toDouble() ?? 0.0,
//     );
//   }
// }
