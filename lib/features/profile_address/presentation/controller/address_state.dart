import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/address_entity.dart';

/// Address State - Presentation Layer
class AddressState extends Equatable {
  final RequestState getAddressesState;
  final RequestState addAddressState;
  final RequestState updateAddressState;
  final RequestState deleteAddressState;
  final RequestState setDefaultState;

  final List<AddressEntity> addresses;
  final AddressEntity? selectedAddress;
  final String? errorMessage;
  final String? successMessage;
  final ErrorRequestType? errorType;

  const AddressState({
    this.getAddressesState = RequestState.initial,
    this.addAddressState = RequestState.initial,
    this.updateAddressState = RequestState.initial,
    this.deleteAddressState = RequestState.initial,
    this.setDefaultState = RequestState.initial,
    this.addresses = const [],
    this.selectedAddress,
    this.errorMessage,
    this.successMessage,
    this.errorType,
  });

  @override
  List<Object?> get props => [
    getAddressesState,
    addAddressState,
    updateAddressState,
    deleteAddressState,
    setDefaultState,
    addresses,
    selectedAddress,
    errorMessage,
    successMessage,
    errorType,
  ];

  AddressState copyWith({
    RequestState? getAddressesState,
    RequestState? addAddressState,
    RequestState? updateAddressState,
    RequestState? deleteAddressState,
    RequestState? setDefaultState,
    List<AddressEntity>? addresses,
    AddressEntity? selectedAddress,
    String? errorMessage,
    String? successMessage,
    ErrorRequestType? errorType,
  }) {
    return AddressState(
      getAddressesState: getAddressesState ?? this.getAddressesState,
      addAddressState: addAddressState ?? this.addAddressState,
      updateAddressState: updateAddressState ?? this.updateAddressState,
      deleteAddressState: deleteAddressState ?? this.deleteAddressState,
      setDefaultState: setDefaultState ?? this.setDefaultState,
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      errorMessage: errorMessage,
      successMessage: successMessage,
      errorType: errorType,
    );
  }
}
