import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile_address/domain/entities/address_entity.dart';
import 'shipping_information_state.dart';

class ShippingInformationCubit extends Cubit<ShippingInformationState> {
  ShippingInformationCubit() : super(const ShippingInformationState());

  void toggleDeliveryMethod(bool isDelivery) {
    emit(
      state.copyWith(
        isDelivery: isDelivery,
        selectedAddressIndex: -1, // Reset selection when toggling
      ),
    );
  }

  void selectAddress(int index) {
    emit(state.copyWith(selectedAddressIndex: index));
  }

  void addAddress(AddressEntity address) {
    final updatedAddresses = List<AddressEntity>.from(state.addresses)
      ..add(address);
    emit(
      state.copyWith(
        addresses: updatedAddresses,
        selectedAddressIndex: updatedAddresses.length - 1, // Auto-select new
        toastMessage: 'تم إضافة العنوان بنجاح',
      ),
    );
    // Clear toast message after emission to prevent showing it again on rebuilds
    // In a real app, you might use a listener, but for now this is simple state
    emit(state.copyWith(toastMessage: null));
  }

  void updateAddress(AddressEntity oldAddress, AddressEntity newAddress) {
    final index = state.addresses.indexOf(oldAddress);
    if (index != -1) {
      final updatedAddresses = List<AddressEntity>.from(state.addresses);
      updatedAddresses[index] = newAddress;
      emit(
        state.copyWith(
          addresses: updatedAddresses,
          toastMessage: 'تم تحديث العنوان بنجاح',
        ),
      );
      emit(state.copyWith(toastMessage: null));
    }
  }

  void applyCoupon(String code) {
    if (code.isNotEmpty) {
      // Mock logic as per original view
      emit(
        state.copyWith(
          isCouponApplied: true,
          savedAmount: 50.0,
          toastMessage: 'تم تطبيق الكوبون بنجاح',
        ),
      );
      emit(state.copyWith(toastMessage: null));
    } else {
      emit(state.copyWith(toastMessage: 'الرجاء إدخال رمز الكوبون'));
      emit(state.copyWith(toastMessage: null));
    }
  }

  void removeCoupon() {
    emit(state.copyWith(isCouponApplied: false, savedAmount: 0.0));
  }

  void clearMessage() {
    emit(state.copyWith(errorMessage: null, toastMessage: null));
  }
}
