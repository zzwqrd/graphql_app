import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../entities/cart_item.dart';
import '../../../product_list/data/models/product_model.dart';

abstract class CartRepository {
  Future<Either<HelperResponse, List<CartItem>>> getCart();
  Future<Either<HelperResponse, String>> getCartGuest();
  Future<Either<HelperResponse, List<CartItem>>> addToCart(
    ProductModel product,
    int quantity,
  );
  Future<Either<HelperResponse, List<CartItem>>> removeFromCart(
    String productId,
  );
  Future<Either<HelperResponse, List<CartItem>>> updateQuantity(
    String productId,
    int quantity,
  );
  Future<Either<HelperResponse, List<CartItem>>> clearCart();
}
