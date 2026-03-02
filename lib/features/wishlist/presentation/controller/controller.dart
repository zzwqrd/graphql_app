import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_manager.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../../product_list/data/models/product_model.dart';
import '../../data/models/wishlist_model.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';
import 'state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistUseCase getWishlistUseCase = GetWishlistUseCaseImpl();
  final AddToWishlistUseCase addToWishlistUseCase = AddToWishlistUseCaseImpl();
  final RemoveFromWishlistUseCase removeFromWishlistUseCase =
      RemoveFromWishlistUseCaseImpl();
  bool get isGuest => AuthManager.isGuest;

  WishlistCubit() : super(WishlistState());

  Future<void> getWishlist() async {
    if (!isClosed) {
      emit(state.copyWith(requestState: RequestState.loading));
    }

    final result = await getWishlistUseCase.call(currentPage: 1, pageSize: 20);

    result.fold(
      (error) {
        if (!isClosed) {
          emit(
            state.copyWith(
              requestState: RequestState.error,
              msg: error.message,
            ),
          );
        }
      },
      (wishlist) {
        if (!isClosed) {
          emit(
            state.copyWith(
              requestState: RequestState.done,
              wishlist: wishlist,
              currentPage: 1,
              hasMorePages: wishlist.items.length >= 20,
            ),
          );
        }
      },
    );
  }

  Future<void> toggleWishlist(String productUid, String sku) async {
    if (isGuest) {
      FlashHelper.failToast("يجب عليك تسجيل الدخول اولا");
      emit(state.copyWith(requestState: RequestState.error, isGuest: isGuest));
    }
    if (state.wishlist == null) {
      await getWishlist();
      if (state.wishlist == null) return;
    }

    if (state.loadingProductIds.contains(productUid)) return;

    final newLoadingIds = Set<String>.from(state.loadingProductIds)
      ..add(productUid);
    if (!isClosed) {
      emit(
        state.copyWith(loadingProductIds: newLoadingIds, itemId: productUid),
      );
    }

    final wishlistItem = state.wishlist!.items.firstWhere(
      (item) {
        return item.product.uid == productUid;
      },
      orElse: () {
        return WishlistItemModel(id: '', product: ProductModel.empty());
      },
    );

    final isInWishlist = wishlistItem.id.isNotEmpty;
    final wishlistId = state.wishlist!.id;

    final result = isInWishlist
        ? await removeFromWishlistUseCase.call(wishlistId, [wishlistItem.id])
        : await addToWishlistUseCase.call(wishlistId, sku);

    result.fold(
      (error) {
        if (!isClosed) {
          emit(state.copyWith(msg: error.message));
        }
      },
      (updatedWishlist) {
        if (isInWishlist) {
          final updatedItems = state.wishlist!.items
              .where((item) => item.product.uid != productUid)
              .toList();

          final localWishlist = WishlistModel(
            id: state.wishlist!.id,
            itemsCount: updatedItems.length,
            items: updatedItems,
          );
          FlashHelper.showToast(
            "تمت الإزالة من المفضلة",
            type: MessageTypeTost.warning,
          );
          if (!isClosed) {
            emit(state.copyWith(wishlist: localWishlist));
          }
        } else {
          FlashHelper.showToast(
            "تمت الإضافة إلى المفضلة",
            type: MessageTypeTost.success,
          );
          if (!isClosed) {
            emit(state.copyWith(wishlist: updatedWishlist));
          }
        }
      },
    );

    if (!isClosed) {
      emit(
        state.copyWith(
          loadingProductIds: Set<String>.from(state.loadingProductIds)
            ..remove(productUid),
        ),
      );
    }
  }

  Future<void> loadMoreWishlist() async {
    if (state.isPaginationLoading ||
        !state.hasMorePages ||
        state.wishlist == null) {
      return;
    }

    if (!isClosed) {
      emit(state.copyWith(isPaginationLoading: true));
    }

    final nextPage = state.currentPage + 1;
    final result = await getWishlistUseCase.call(
      currentPage: nextPage,
      pageSize: 20,
    );

    result.fold(
      (error) {
        if (!isClosed) {
          emit(state.copyWith(isPaginationLoading: false, msg: error.message));
        }
      },
      (newWishlist) {
        final updatedItems = [...state.wishlist!.items, ...newWishlist.items];
        final updatedWishlist = WishlistModel(
          id: state.wishlist!.id,
          itemsCount: state.wishlist!.itemsCount,
          items: updatedItems,
        );

        if (!isClosed) {
          emit(
            state.copyWith(
              isPaginationLoading: false,
              wishlist: updatedWishlist,
              currentPage: nextPage,
              hasMorePages: newWishlist.items.length >= 20,
            ),
          );
        }
      },
    );
  }
}
