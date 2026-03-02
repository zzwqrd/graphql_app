import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../../../app_initialize.dart';
import '../models/cart_graphql_queries.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, CartModel>> getCart() async {
    final bool isUserLoggedIn = preferences.getString('auth_token') != null;
    final String? cartId = preferences.getString('cartId');

    final result = await graphQLQuery(
      (!isUserLoggedIn && cartId != null)
          ? CartGraphQLQueries().guestCartQuery(cartId)
          : CartGraphQLQueries().cartQuery,
      fromJson: (json) => CartModel.fromJson(json),
      dataKey: (!isUserLoggedIn && cartId != null) ? 'cart' : 'customerCart',
    );

    return result.fold((error) async {
      // Handle "The cart isn't active" error - indicating order was placed
      if (error.message.contains("The cart isn't active")) {
        print('🛒 Cart is inactive (likely ordered). Creating new cart...');
        await preferences.remove('cartId');
        // Create new empty cart
        final newCartResult = await getCartGuest();
        if (newCartResult.isRight()) {
          // Recursive call to get the new empty cart details
          return getCart();
        }
      }
      return Left(error);
    }, (data) => Right(data));
  }

  //{
  // "data": {
  //   "createEmptyCart": "sZA6XBmN88HKwhsGBfDetdP2bsyzLrp2"
  // }
  //}
  Future<Either<HelperResponse, dynamic>> getCartGuest() async {
    final result = await graphQLQuery(
      CartGraphQLQueries().createEmptyCartMutation,
      fromJson: (json) => CartIdModel.fromGraphQLData(json),
      dataKey: 'createEmptyCart',
    );
    if (result.isRight()) {
      preferences.setString(
        'cartId',
        result.fold((l) => l.message, (r) => r.id),
      );
      return Right(result.fold((l) => l, (r) => r.id));
    } else {
      return Left(
        HelperResponse.badRequest(
          message: result.fold((l) => l.message, (r) => r.id),
        ),
      );
    }
  }

  Future<Either<HelperResponse, CartModel>> addToCart(
    String cartId,
    String sku,
    int quantity,
  ) async {
    return await graphQLMutation(
      CartGraphQLQueries().addToCartMutation(cartId, sku, quantity.toDouble()),
      fromJson: (json) => CartModel.fromJson(json['cart']),
      dataKey: 'addProductsToCart',
    );
  }

  Future<Either<HelperResponse, CartModel>> updateCartItem(
    String cartId,
    String itemId,
    int quantity,
  ) async {
    return await graphQLMutation(
      CartGraphQLQueries().updateCartItemsMutation(
        cartId,
        itemId,
        quantity.toDouble(),
      ),
      fromJson: (json) => CartModel.fromJson(json['cart']),
      dataKey: 'updateCartItems',
    );
  }

  Future<Either<HelperResponse, CartModel>> removeFromCart(
    String cartId,
    String itemId,
  ) async {
    return await graphQLMutation(
      CartGraphQLQueries().removeItemFromCartMutation(cartId, itemId),
      fromJson: (json) => CartModel.fromJson(json['cart']),
      dataKey: 'removeItemFromCart',
    );
  }

  Future<Either<HelperResponse, String>> createEmptyCart() async {
    return await graphQLMutation(
      CartGraphQLQueries().createEmptyCartMutation,
      fromJson: (json) => json as String,
      dataKey: 'createEmptyCart',
    );
  }
}
