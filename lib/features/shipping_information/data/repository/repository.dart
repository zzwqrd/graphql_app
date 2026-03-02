import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../../domain/entities/entity.dart';
import '../../domain/usecases/usecase.dart';
import '../data_source/location_data_source.dart';

/// Implementation of LocationRepository
class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource = LocationDataSource();

  @override
  Future<Either<HelperResponse, AddressLocation>> getCurrentLocation() async {
    // Get current position
    final positionResult = await dataSource.getCurrentPosition();

    return positionResult.fold((error) => Left(error), (position) async {
      // Convert position to address
      final addressResult = await dataSource.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      return addressResult.fold(
        (error) => Left(error),
        (addressModel) => Right(addressModel.toEntity()),
      );
    });
  }

  @override
  Future<Either<HelperResponse, AddressLocation>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final result = await dataSource.getAddressFromLatLng(latitude, longitude);

    return result.fold(
      (error) => Left(error),
      (addressModel) => Right(addressModel.toEntity()),
    );
  }

  @override
  Future<Either<HelperResponse, bool>> checkLocationPermission() async {
    return await dataSource.checkPermission();
  }

  @override
  Future<Either<HelperResponse, bool>> requestLocationPermission() async {
    return await dataSource.requestPermission();
  }
}
