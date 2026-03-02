import '../../../../core/utils/enums.dart';
import '../../data/models/wishlist_model.dart';

class WishlistState {
  final RequestState requestState;
  final WishlistModel? wishlist;
  final String msg;
  final String? itemId; // For specific item loading/actions
  final bool isGuest;

  final Set<String>
  loadingProductIds; // To track which products are currently being added/removed

  // Pagination fields
  final int currentPage;
  final bool hasMorePages;
  final bool isPaginationLoading;

  WishlistState({
    this.requestState = RequestState.loading,
    this.wishlist,
    this.msg = '',
    this.itemId,
    this.isGuest = false,
    this.loadingProductIds = const {},
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isPaginationLoading = false,
  });

  WishlistState copyWith({
    RequestState? requestState,
    WishlistModel? wishlist,
    String? msg,
    String? itemId,
    bool? isGuest,
    Set<String>? loadingProductIds,
    int? currentPage,
    bool? hasMorePages,
    bool? isPaginationLoading,
  }) {
    return WishlistState(
      requestState: requestState ?? this.requestState,
      wishlist: wishlist ?? this.wishlist,
      msg: msg ?? this.msg,
      itemId: itemId ?? this.itemId,
      isGuest: isGuest ?? this.isGuest,
      loadingProductIds: loadingProductIds ?? this.loadingProductIds,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
    );
  }
}
