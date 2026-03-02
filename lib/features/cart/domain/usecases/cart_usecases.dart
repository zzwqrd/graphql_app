import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';
import '../../data/repositories_impl/cart_repository_impl.dart';
import '../../../product_list/data/models/product_model.dart';

class GetCartUseCase {
  final CartRepository repository = CartRepositoryImpl();

  Future<Either<HelperResponse, List<CartItem>>> call() async {
    return await repository.getCart();
  }
}

class AddToCartUseCase {
  final CartRepository repository = CartRepositoryImpl();

  Future<Either<HelperResponse, List<CartItem>>> call(
    ProductModel product,
    int quantity,
  ) async {
    return await repository.addToCart(product, quantity);
  }
}

class RemoveFromCartUseCase {
  final CartRepository repository = CartRepositoryImpl();

  Future<Either<HelperResponse, List<CartItem>>> call(String productId) async {
    return await repository.removeFromCart(productId);
  }
}

class UpdateCartQuantityUseCase {
  final CartRepository repository = CartRepositoryImpl();

  Future<Either<HelperResponse, List<CartItem>>> call(
    String productId,
    int quantity,
  ) async {
    return await repository.updateQuantity(productId, quantity);
  }
}

class ClearCartUseCase {
  final CartRepository repository = CartRepositoryImpl();

  Future<Either<HelperResponse, List<CartItem>>> call() async {
    return await repository.clearCart();
  }
}
