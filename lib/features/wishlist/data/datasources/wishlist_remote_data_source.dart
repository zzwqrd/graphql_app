import 'package:dartz/dartz.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/wishlist_graphql_queries.dart';
import '../models/wishlist_model.dart';

abstract class WishlistRemoteDataSource {
  Future<Either<HelperResponse, WishlistModel>> getWishlist({
    int currentPage = 1,
    int pageSize = 20,
  });
  Future<Either<HelperResponse, WishlistModel>> addProductsToWishlist(
    String wishlistId,
    String sku,
  );
  Future<Either<HelperResponse, WishlistModel>> removeProductsFromWishlist(
    String wishlistId,
    List<String> itemIds,
  );
}

class WishlistRemoteDataSourceImpl
    with ApiClient
    implements WishlistRemoteDataSource {
  @override
  Future<Either<HelperResponse, WishlistModel>> getWishlist({
    int currentPage = 1,
    int pageSize = 20,
  }) async {
    return await graphQLQuery(
      WishlistGraphQLQueries().getWishlist(
        currentPage: currentPage,
        pageSize: pageSize,
      ),
      fromJson: (json) {
        final wishlist = json['wishlist'];
        if (wishlist == null) {
          return WishlistModel(id: '', itemsCount: 0, items: []);
        }
        return WishlistModel.fromJson(wishlist);
      },
      dataKey: 'customer',
    );
  }

  @override
  Future<Either<HelperResponse, WishlistModel>> addProductsToWishlist(
    String wishlistId,
    String sku,
  ) async {
    return await graphQLQuery(
      WishlistGraphQLQueries().addProductsToWishlist,
      variables: {'wishlistId': wishlistId, 'sku': sku},
      fromJson: (json) {
        final wishlist = json['wishlist'];
        if (wishlist == null) {
          return WishlistModel(id: '', itemsCount: 0, items: []);
        }
        return WishlistModel.fromJson(wishlist);
      },
      dataKey: 'addProductsToWishlist',
    );
  }

  @override
  Future<Either<HelperResponse, WishlistModel>> removeProductsFromWishlist(
    String wishlistId,
    List<String> itemIds,
  ) async {
    return await graphQLQuery(
      WishlistGraphQLQueries().removeProductsFromWishlist,
      variables: {'wishlistId': wishlistId, 'itemIds': itemIds},
      fromJson: (json) {
        final wishlist = json['wishlist'];
        if (wishlist == null) {
          return WishlistModel(id: '', itemsCount: 0, items: []);
        }
        return WishlistModel.fromJson(wishlist);
      },
      dataKey: 'removeProductsFromWishlist',
    );
  }
}
