import '../../../product_list/data/models/product_model.dart';

import 'package:equatable/equatable.dart'; // Assuming Equatable needs to be imported

class CartItem extends Equatable {
  final String id;
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, product, quantity];

  // Re-adding the totalPrice getter as it was present in the original and likely intended to remain.
  double get totalPrice =>
      product.priceRange.minimumPrice.finalPrice.value * quantity;
}
