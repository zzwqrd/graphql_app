import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../data/models/wishlist_model.dart';

abstract class WishlistRepository {
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
