import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/usecases/address_usecases.dart';
import 'address_state.dart';

/// Address Cubit - Presentation Layer
/// Manages address operations for both guest and authenticated users
class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase _getAddressesUseCase = GetAddressesUseCase();
  final AddAddressUseCase _addAddressUseCase = AddAddressUseCase();
  final UpdateAddressUseCase _updateAddressUseCase = UpdateAddressUseCase();
  final DeleteAddressUseCase _deleteAddressUseCase = DeleteAddressUseCase();
  final SetDefaultAddressUseCase _setDefaultAddressUseCase =
      SetDefaultAddressUseCase();

  AddressCubit() : super(const AddressState());

  /// Get all addresses
  Future<void> getAddresses() async {
    if (isClosed) return;

    emit(state.copyWith(getAddressesState: RequestState.loading));

    final result = await _getAddressesUseCase.call();

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          state.copyWith(
            getAddressesState: RequestState.error,
            errorMessage: error.message,
            errorType: error.errorType,
          ),
        );
      },
      (addresses) {
        emit(
          state.copyWith(
            getAddressesState: RequestState.done,
            addresses: addresses,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Add a new address
  Future<void> addAddress(AddressEntity address) async {
    if (isClosed) return;

    emit(state.copyWith(addAddressState: RequestState.loading));

    final result = await _addAddressUseCase.call(address);

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          state.copyWith(
            addAddressState: RequestState.error,
            errorMessage: error.message,
            errorType: error.errorType,
          ),
        );
      },
      (newAddress) {
        final updatedAddresses = List<AddressEntity>.from(state.addresses)
          ..add(newAddress);

        emit(
          state.copyWith(
            addAddressState: RequestState.done,
            addresses: updatedAddresses,
            successMessage: 'تم إضافة العنوان بنجاح',
            errorMessage: null,
          ),
        );

        // Refresh addresses to get updated data
        getAddresses();
      },
    );
  }

  /// Update an existing address
  Future<void> updateAddress(AddressEntity address) async {
    if (isClosed) return;

    emit(state.copyWith(updateAddressState: RequestState.loading));

    final result = await _updateAddressUseCase.call(address);

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          state.copyWith(
            updateAddressState: RequestState.error,
            errorMessage: error.message,
            errorType: error.errorType,
          ),
        );
      },
      (updatedAddress) {
        final updatedAddresses = state.addresses.map((a) {
          return a.id == updatedAddress.id ? updatedAddress : a;
        }).toList();

        emit(
          state.copyWith(
            updateAddressState: RequestState.done,
            addresses: updatedAddresses,
            successMessage: 'تم تحديث العنوان بنجاح',
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Delete an address
  Future<void> deleteAddress(String addressId) async {
    if (isClosed) return;

    emit(state.copyWith(deleteAddressState: RequestState.loading));

    final result = await _deleteAddressUseCase.call(addressId);

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          state.copyWith(
            deleteAddressState: RequestState.error,
            errorMessage: error.message,
            errorType: error.errorType,
          ),
        );
      },
      (success) {
        if (success) {
          final updatedAddresses = state.addresses
              .where((address) => address.id != addressId)
              .toList();

          emit(
            state.copyWith(
              deleteAddressState: RequestState.done,
              addresses: updatedAddresses,
              successMessage: 'تم حذف العنوان بنجاح',
              errorMessage: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              deleteAddressState: RequestState.error,
              errorMessage: 'فشل حذف العنوان',
            ),
          );
        }
      },
    );
  }

  /// Set an address as default
  Future<void> setDefaultAddress(String addressId) async {
    if (isClosed) return;

    emit(state.copyWith(setDefaultState: RequestState.loading));

    final result = await _setDefaultAddressUseCase.call(addressId);

    if (isClosed) return;

    result.fold(
      (error) {
        emit(
          state.copyWith(
            setDefaultState: RequestState.error,
            errorMessage: error.message,
            errorType: error.errorType,
          ),
        );
      },
      (defaultAddress) {
        final updatedAddresses = state.addresses.map((address) {
          return address.copyWith(isDefault: address.id == addressId);
        }).toList();

        emit(
          state.copyWith(
            setDefaultState: RequestState.done,
            addresses: updatedAddresses,
            successMessage: 'تم تعيين العنوان الافتراضي',
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Select an address (for checkout)
  void selectAddress(AddressEntity address) {
    if (isClosed) return;

    emit(state.copyWith(selectedAddress: address));
  }

  /// Clear success message
  void clearSuccessMessage() {
    if (isClosed) return;

    emit(state.copyWith(successMessage: null));
  }

  /// Clear error message
  void clearErrorMessage() {
    if (isClosed) return;

    emit(state.copyWith(errorMessage: null));
  }
}
