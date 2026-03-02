import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../data/models/wishlist_model.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';

abstract class AddToWishlistUseCase {
  Future<Either<HelperResponse, WishlistModel>> call(
    String wishlistId,
    String sku,
  );
}

class AddToWishlistUseCaseImpl implements AddToWishlistUseCase {
  final WishlistRepository repository = WishlistRepositoryImpl();

  @override
  Future<Either<HelperResponse, WishlistModel>> call(
    String wishlistId,
    String sku,
  ) async {
    return await repository.addProductsToWishlist(wishlistId, sku);
  }
}
