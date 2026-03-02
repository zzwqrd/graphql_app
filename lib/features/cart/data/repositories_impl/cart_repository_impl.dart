import 'package:dartz/dartz.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../../../app_initialize.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../../../product_list/data/models/product_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource = CartRemoteDataSource();
  static String? _cartId;

  Future<String> _getCartId() async {
    if (preferences.getString('auth_token') != null) {
      if (_cartId != null) return _cartId!;
      final result = await remoteDataSource.getCart();
      return result.fold((error) => throw Exception(error.message), (cart) {
        _cartId = cart.id;
        return _cartId!;
      });
    } else {
      _cartId = preferences.getString('cartId');
      if (_cartId != null) return _cartId!;
      final result = await remoteDataSource.getCartGuest();
      return result.fold((error) => throw Exception(error.message), (cart) {
        _cartId = cart.id;
        return _cartId!;
      });
    }
  }

  static List<CartItem>? _itemsCache;

  @override
  Future<Either<HelperResponse, List<CartItem>>> getCart() async {
    if (_itemsCache != null) {
      _fetchAndCache(); // Refresh in background
      return Right(_itemsCache!);
    }
    return _fetchAndCache();
  }

  Future<Either<HelperResponse, List<CartItem>>> _fetchAndCache() async {
    final result = await remoteDataSource.getCart();
    return result.fold((error) => Left(error), (cart) {
      _cartId = cart.id;
      _itemsCache = cart.items;
      return Right(cart.items);
    });
  }

  @override
  Future<Either<HelperResponse<dynamic>, String>> getCartGuest() async {
    final result = await remoteDataSource.getCartGuest();
    return result.fold((error) => Left(error), (cart) {
      _cartId = cart.id;
      return Right(cart.id);
    });
  }

  @override
  Future<Either<HelperResponse, List<CartItem>>> addToCart(
    ProductModel product,
    int quantity,
  ) async {
    try {
      final cartId = await _getCartId();
      final result = await remoteDataSource.addToCart(
        cartId,
        product.sku,
        quantity,
      );
      return result.fold((error) => Left(error), (cart) => Right(cart.items));
    } catch (e) {
      return Left(HelperResponse.badRequest(message: e.toString()));
    }
  }

  @override
  Future<Either<HelperResponse, List<CartItem>>> removeFromCart(
    String productId,
  ) async {
    try {
      final cartId = await _getCartId();
      // Note: productId here should be the Cart Item ID for remote.
      // Assuming the UI passes the correct ID (CartItem.id) which is mapped from GraphQL 'id'.
      final result = await remoteDataSource.removeFromCart(cartId, productId);
      return result.fold((error) => Left(error), (cart) => Right(cart.items));
    } catch (e) {
      return Left(HelperResponse.badRequest(message: e.toString()));
    }
  }

  @override
  Future<Either<HelperResponse, List<CartItem>>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final cartId = await _getCartId();
      final result = await remoteDataSource.updateCartItem(
        cartId,
        productId,
        quantity,
      );
      return result.fold((error) => Left(error), (cart) => Right(cart.items));
    } catch (e) {
      return Left(HelperResponse.badRequest(message: e.toString()));
    }
  }

  @override
  Future<Either<HelperResponse, List<CartItem>>> clearCart() async {
    // GraphQL usually doesn't have a clear cart, but we can create a new empty one.
    final result = await remoteDataSource.createEmptyCart();
    return result.fold(
      (error) => Left(error),
      (success) => Right([]), // Return empty list on success
    );
  }
}
