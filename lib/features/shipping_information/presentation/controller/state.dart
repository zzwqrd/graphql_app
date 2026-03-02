// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/utils/enums.dart';
import '../../domain/entities/entity.dart';

/// State for Map Location feature
class MapLocationState {
  final RequestState requestState;
  final RequestState permissionState;
  final RequestState addressState;

  // final LatLng? currentPosition;
  // final LatLng? selectedPosition;
  final String? currentAddress;
  final AddressLocation? selectedLocation;
  final bool hasPermission;
  final String msg;

  MapLocationState({
    this.requestState = RequestState.initial,
    this.permissionState = RequestState.initial,
    this.addressState = RequestState.initial,
    // this.currentPosition,
    // this.selectedPosition,
    this.currentAddress,
    this.selectedLocation,
    this.hasPermission = false,
    this.msg = '',
  });

  MapLocationState copyWith({
    RequestState? requestState,
    RequestState? permissionState,
    RequestState? addressState,
    // LatLng? currentPosition,
    // LatLng? selectedPosition,
    String? currentAddress,
    AddressLocation? selectedLocation,
    bool? hasPermission,
    String? msg,
    bool clearPosition = false,
    bool clearAddress = false,
  }) {
    return MapLocationState(
      requestState: requestState ?? this.requestState,
      permissionState: permissionState ?? this.permissionState,
      addressState: addressState ?? this.addressState,
      // currentPosition: clearPosition
      //     ? null
      //     : (currentPosition ?? this.currentPosition),
      // selectedPosition: clearPosition
      //     ? null
      //     : (selectedPosition ?? this.selectedPosition),
      currentAddress: clearAddress
          ? null
          : (currentAddress ?? this.currentAddress),
      selectedLocation: clearAddress
          ? null
          : (selectedLocation ?? this.selectedLocation),
      hasPermission: hasPermission ?? this.hasPermission,
      msg: msg ?? this.msg,
    );
  }
}
