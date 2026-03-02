import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/flash_helper.dart';
import '../../domain/usecases/usecase.dart';
import 'state.dart';

/// Cubit for managing map location operations
class MapLocationCubit extends Cubit<MapLocationState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase =
      GetCurrentLocationUseCase();
  final GetAddressFromCoordinatesUseCase getAddressUseCase =
      GetAddressFromCoordinatesUseCase();
  final CheckLocationPermissionUseCase checkPermissionUseCase =
      CheckLocationPermissionUseCase();
  final RequestLocationPermissionUseCase requestPermissionUseCase =
      RequestLocationPermissionUseCase();

  MapLocationCubit() : super(MapLocationState());

  /// Check and request location permission
  Future<void> checkAndRequestPermission() async {
    emit(state.copyWith(permissionState: RequestState.loading));

    // First check if permission is already granted
    final checkResult = await checkPermissionUseCase.call();

    await checkResult.fold(
      (error) async {
        emit(
          state.copyWith(
            permissionState: RequestState.error,
            msg: error.message,
            hasPermission: false,
          ),
        );
        FlashHelper.showToast(error.message, type: MessageTypeTost.fail);
      },
      (hasPermission) async {
        if (hasPermission) {
          emit(
            state.copyWith(
              permissionState: RequestState.done,
              hasPermission: true,
            ),
          );
        } else {
          // Request permission
          final requestResult = await requestPermissionUseCase.call();
          requestResult.fold(
            (error) {
              emit(
                state.copyWith(
                  permissionState: RequestState.error,
                  msg: error.message,
                  hasPermission: false,
                ),
              );
              FlashHelper.showToast(error.message, type: MessageTypeTost.fail);
            },
            (granted) {
              emit(
                state.copyWith(
                  permissionState: RequestState.done,
                  hasPermission: granted,
                ),
              );
              if (!granted) {
                FlashHelper.showToast(
                  'يجب منح صلاحيات الموقع لاستخدام هذه الميزة',
                  type: MessageTypeTost.fail,
                );
              }
            },
          );
        }
      },
    );
  }

  /// Get current device location
  Future<void> getCurrentLocation() async {
    emit(state.copyWith(requestState: RequestState.loading));

    final result = await getCurrentLocationUseCase.call();

    result.fold(
      (error) {
        emit(
          state.copyWith(requestState: RequestState.error, msg: error.message),
        );
        FlashHelper.showToast(error.message, type: MessageTypeTost.fail);
      },
      (location) {
        // final position = LatLng(location.latitude, location.longitude);
        emit(
          state.copyWith(
            requestState: RequestState.done,
            // currentPosition: position,
            // selectedPosition: position,
            currentAddress: location.address,
            selectedLocation: location,
          ),
        );
      },
    );
  }

  /// Get address from coordinates
  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    emit(state.copyWith(addressState: RequestState.loading));

    final result = await getAddressUseCase.call(lat, lng);

    result.fold(
      (error) {
        emit(
          state.copyWith(addressState: RequestState.error, msg: error.message),
        );
        // Don't show error toast for geocoding failures, just use default
        emit(
          state.copyWith(
            addressState: RequestState.done,
            currentAddress: 'Unknown Location Found',
          ),
        );
      },
      (location) {
        emit(
          state.copyWith(
            addressState: RequestState.done,
            currentAddress: location.address,
            selectedLocation: location,
          ),
        );
      },
    );
  }

  /// Update camera position when map is moved
  // void updateCameraPosition(LatLng position) {
  //   emit(state.copyWith(selectedPosition: position));
  //   // Debounce geocoding to avoid too many requests
  //   getAddressFromCoordinates(position.latitude, position.longitude);
  // }

  /// Set selected location
  // void setSelectedLocation(LatLng position, String address) {
  //   emit(state.copyWith(selectedPosition: position, currentAddress: address));
  // }

  /// Reset state
  void reset() {
    emit(MapLocationState());
  }
}
