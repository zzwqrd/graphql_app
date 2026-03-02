import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../data/models/wishlist_model.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../../../di/service_locator.dart';

abstract class RemoveFromWishlistUseCase {
  Future<Either<HelperResponse, WishlistModel>> call(
    String wishlistId,
    List<String> itemIds,
  );
}

class RemoveFromWishlistUseCaseImpl implements RemoveFromWishlistUseCase {
  final WishlistRepository repository = WishlistRepositoryImpl();

  @override
  Future<Either<HelperResponse, WishlistModel>> call(
    String wishlistId,
    List<String> itemIds,
  ) async {
    return await repository.removeProductsFromWishlist(wishlistId, itemIds);
  }
}
