import 'package:equatable/equatable.dart';
import '../../../profile_address/domain/entities/address_entity.dart';

enum ShippingStatus { initial, loading, success, error }

class ShippingInformationState extends Equatable {
  final ShippingStatus status;
  final bool isDelivery;
  final int selectedAddressIndex;
  final List<AddressEntity> addresses;
  final bool isCouponApplied;
  final double savedAmount;
  final String? errorMessage;
  final String? toastMessage;

  const ShippingInformationState({
    this.status = ShippingStatus.initial,
    this.isDelivery = true,
    this.selectedAddressIndex = -1,
    this.addresses = const [],
    this.isCouponApplied = false,
    this.savedAmount = 0.0,
    this.errorMessage,
    this.toastMessage,
  });

  ShippingInformationState copyWith({
    ShippingStatus? status,
    bool? isDelivery,
    int? selectedAddressIndex,
    List<AddressEntity>? addresses,
    bool? isCouponApplied,
    double? savedAmount,
    String? errorMessage,
    String? toastMessage,
  }) {
    return ShippingInformationState(
      status: status ?? this.status,
      isDelivery: isDelivery ?? this.isDelivery,
      selectedAddressIndex: selectedAddressIndex ?? this.selectedAddressIndex,
      addresses: addresses ?? this.addresses,
      isCouponApplied: isCouponApplied ?? this.isCouponApplied,
      savedAmount: savedAmount ?? this.savedAmount,
      errorMessage: errorMessage ?? this.errorMessage,
      toastMessage: toastMessage ?? this.toastMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    isDelivery,
    selectedAddressIndex,
    addresses,
    isCouponApplied,
    savedAmount,
    errorMessage,
    toastMessage,
  ];
}
