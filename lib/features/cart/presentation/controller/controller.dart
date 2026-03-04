import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../../../product_list/data/models/product_model.dart';
import '../../../../gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase = GetCartUseCase();
  final AddToCartUseCase addToCartUseCase = AddToCartUseCase();
  final RemoveFromCartUseCase removeFromCartUseCase = RemoveFromCartUseCase();
  final UpdateCartQuantityUseCase updateCartQuantityUseCase =
      UpdateCartQuantityUseCase();
  final ClearCartUseCase clearCartUseCase = ClearCartUseCase();

  CartCubit() : super(CartState());

  Future<void> getCart() async {
    if (state.items.isEmpty) {
      emit(
        state.copyWith(
          requestState: RequestState.loading,
          updateCount: RequestState.initial,
          removeFromCart: RequestState.initial,
          clearCart: RequestState.initial,
          addToCart: RequestState.initial,
          couponState: RequestState.initial,
          createOrderState: RequestState.initial,
          msg: '',
        ),
      );
    }

    final result = await getCartUseCase.call();
    result.fold(
      (error) {
        if (state.items.isEmpty) {
          emit(
            state.copyWith(
              requestState: RequestState.error,
              msg: error.message,
            ),
          );
        }

        FlashHelper.showToast(error.message, type: MessageTypeTost.fail);
      },
      (items) {
        final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);

        emit(
          state.copyWith(
            requestState: RequestState.done,
            items: items,
            totalAmount: total,
          ),
        );
      },
    );
  }

  addToCart(ProductModel product, int quantity) async {
    emit(
      state.copyWith(
        addToCart: RequestState.loading,
        requestState: RequestState.initial,
        updateCount: RequestState.initial,
        removeFromCart: RequestState.initial,
        clearCart: RequestState.initial,
        couponState: RequestState.initial,
        createOrderState: RequestState.initial,
        itemId: product.uid,
      ),
    );

    final result = await addToCartUseCase.call(product, quantity);
    result.fold(
      (error) {
        String errorMessage = error.message;

        if (errorMessage.toLowerCase().contains('qty') ||
            errorMessage.toLowerCase().contains('stock') ||
            errorMessage.toLowerCase().contains('available') ||
            errorMessage.toLowerCase().contains('quantity')) {
          errorMessage = 'الكمية المطلوبة غير متوفرة في المخزن';
        }
        if (isClosed) return;
        emit(state.copyWith(addToCart: RequestState.error, msg: errorMessage));

        FlashHelper.showToast(errorMessage, type: MessageTypeTost.fail);

        emit(state.copyWith(addToCart: RequestState.done, clearItemId: true));
      },
      (items) {
        final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
        final msg = LocaleKeys.cart_item_added_success.tr();
        if (isClosed) return;
        emit(
          state.copyWith(
            addToCart: RequestState.done,
            msg: msg,
            items: items,
            totalAmount: total,
            clearItemId: true,
          ),
        );

        FlashHelper.showToast(msg, type: MessageTypeTost.success);
      },
    );
  }

  Future<void> removeFromCart(String itemId) async {
    emit(
      state.copyWith(
        removeFromCart: RequestState.loading,
        requestState: RequestState.initial,
        updateCount: RequestState.initial,
        clearCart: RequestState.initial,
        addToCart: RequestState.initial,
        couponState: RequestState.initial,
        createOrderState: RequestState.initial,
        itemId: itemId,
      ),
    );

    final result = await removeFromCartUseCase.call(itemId);
    result.fold(
      (error) {
        emit(
          state.copyWith(
            removeFromCart: RequestState.error,
            msg: error.message,
          ),
        );

        FlashHelper.showToast(error.message, type: MessageTypeTost.fail);

        emit(
          state.copyWith(removeFromCart: RequestState.done, clearItemId: true),
        );
      },
      (items) {
        final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
        final msg = LocaleKeys.cart_item_removed_success.tr();
        emit(
          state.copyWith(
            removeFromCart: RequestState.done,
            msg: msg,
            items: items,
            totalAmount: total,
            clearItemId: true,
          ),
        );

        FlashHelper.showToast(msg, type: MessageTypeTost.success);
      },
    );
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    emit(
      state.copyWith(
        updateCount: RequestState.loading,
        requestState: RequestState.initial,
        removeFromCart: RequestState.initial,
        clearCart: RequestState.initial,
        addToCart: RequestState.initial,
        couponState: RequestState.initial,
        createOrderState: RequestState.initial,
        itemId: itemId,
      ),
    );

    final result = await updateCartQuantityUseCase.call(itemId, quantity);
    result.fold(
      (error) {
        String message = error.message;
        if (message.toLowerCase().contains('qty') ||
            message.toLowerCase().contains('stock') ||
            message.toLowerCase().contains('available')) {
          message.isEmpty
              ? message = LocaleKeys.cart_quantity_not_available.tr()
              : message;
        }

        emit(state.copyWith(updateCount: RequestState.error, msg: message));

        FlashHelper.showToast(message, type: MessageTypeTost.fail);
        // Reset to done to clear loading
        emit(state.copyWith(updateCount: RequestState.done, clearItemId: true));
      },
      (items) {
        final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
        final msg = LocaleKeys.cart_quantity_updated_success.tr();

        emit(
          state.copyWith(
            updateCount: RequestState.done,
            msg: msg,
            items: items,
            totalAmount: total,
            clearItemId: true,
          ),
        );

        FlashHelper.showToast(msg, type: MessageTypeTost.success);
      },
    );
  }

  Future<void> clearCart() async {
    emit(state.copyWith(clearCart: RequestState.loading));
    final result = await clearCartUseCase.call();
    result.fold(
      (error) {
        emit(state.copyWith(clearCart: RequestState.error, msg: error.message));

        FlashHelper.showToast(error.message, type: MessageTypeTost.fail);
      },
      (items) {
        emit(
          state.copyWith(
            clearCart: RequestState.done,
            items: items,
            totalAmount: 0.0,
          ),
        );

        FlashHelper.showToast(
          "Cart cleared successfully",
          type: MessageTypeTost.success,
        );
      },
    );
  }
}
