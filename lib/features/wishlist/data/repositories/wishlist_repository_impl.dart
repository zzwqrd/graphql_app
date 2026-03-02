import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../data/models/wishlist_model.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource dataSource = WishlistRemoteDataSourceImpl();

  WishlistRepositoryImpl();

  @override
  Future<Either<HelperResponse, WishlistModel>> getWishlist({
    int currentPage = 1,
    int pageSize = 20,
  }) async {
    return await dataSource.getWishlist(
      currentPage: currentPage,
      pageSize: pageSize,
    );
  }

  @override
  Future<Either<HelperResponse, WishlistModel>> addProductsToWishlist(
    String wishlistId,
    String sku,
  ) async {
    return await dataSource.addProductsToWishlist(wishlistId, sku);
  }

  @override
  Future<Either<HelperResponse, WishlistModel>> removeProductsFromWishlist(
    String wishlistId,
    List<String> itemIds,
  ) async {
    return await dataSource.removeProductsFromWishlist(wishlistId, itemIds);
  }
}
