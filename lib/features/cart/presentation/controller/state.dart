import '../../../../core/utils/enums.dart';
import '../../domain/entities/cart_item.dart';

class CartState {
  final RequestState requestState;
  final RequestState updateCount;
  final RequestState removeFromCart;
  final RequestState clearCart;
  final RequestState addToCart;
  final RequestState couponState;
  final RequestState createOrderState;

  final String msg;
  final List<CartItem> items;
  final double totalAmount;
  final String? itemId; // For specific item loading/actions

  CartState({
    this.requestState = RequestState.initial,
    this.updateCount = RequestState.initial,
    this.removeFromCart = RequestState.initial,
    this.clearCart = RequestState.initial,
    this.addToCart = RequestState.initial,
    this.couponState = RequestState.initial,
    this.createOrderState = RequestState.initial,
    this.msg = '',
    this.items = const [],
    this.totalAmount = 0.0,
    this.itemId,
  });

  CartState copyWith({
    RequestState? requestState,
    RequestState? updateCount,
    RequestState? removeFromCart,
    RequestState? clearCart,
    RequestState? addToCart,
    RequestState? couponState,
    RequestState? createOrderState,
    String? msg,
    List<CartItem>? items,
    double? totalAmount,
    String? itemId,
    bool clearItemId = false,
  }) {
    return CartState(
      requestState: requestState ?? this.requestState,
      updateCount: updateCount ?? this.updateCount,
      removeFromCart: removeFromCart ?? this.removeFromCart,
      clearCart: clearCart ?? this.clearCart,
      addToCart: addToCart ?? this.addToCart,
      couponState: couponState ?? this.couponState,
      createOrderState: createOrderState ?? this.createOrderState,
      msg: msg ?? this.msg,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      itemId: clearItemId ? null : (itemId ?? this.itemId),
    );
  }
}
