import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../data/models/wishlist_model.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';

abstract class GetWishlistUseCase {
  Future<Either<HelperResponse, WishlistModel>> call({
    int currentPage = 1,
    int pageSize = 20,
  });
}

class GetWishlistUseCaseImpl implements GetWishlistUseCase {
  final WishlistRepository repository = WishlistRepositoryImpl();

  @override
  Future<Either<HelperResponse, WishlistModel>> call({
    int currentPage = 1,
    int pageSize = 20,
  }) async {
    return await repository.getWishlist(
      currentPage: currentPage,
      pageSize: pageSize,
    );
  }
}
