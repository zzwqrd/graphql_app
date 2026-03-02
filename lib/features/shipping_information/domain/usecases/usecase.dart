import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../entities/entity.dart';
import '../../data/repository/repository.dart';

/// Use case to get current device location
class GetCurrentLocationUseCase {
  final LocationRepository repository = LocationRepositoryImpl();

  Future<Either<HelperResponse, AddressLocation>> call() async {
    return await repository.getCurrentLocation();
  }
}

/// Use case to convert coordinates to address
class GetAddressFromCoordinatesUseCase {
  final LocationRepository repository = LocationRepositoryImpl();

  Future<Either<HelperResponse, AddressLocation>> call(
    double latitude,
    double longitude,
  ) async {
    return await repository.getAddressFromCoordinates(latitude, longitude);
  }
}

/// Use case to check location permission status
class CheckLocationPermissionUseCase {
  final LocationRepository repository = LocationRepositoryImpl();

  Future<Either<HelperResponse, bool>> call() async {
    return await repository.checkLocationPermission();
  }
}

/// Use case to request location permission
class RequestLocationPermissionUseCase {
  final LocationRepository repository = LocationRepositoryImpl();

  Future<Either<HelperResponse, bool>> call() async {
    return await repository.requestLocationPermission();
  }
}

/// Repository interface for location operations
abstract class LocationRepository {
  Future<Either<HelperResponse, AddressLocation>> getCurrentLocation();
  Future<Either<HelperResponse, AddressLocation>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  );
  Future<Either<HelperResponse, bool>> checkLocationPermission();
  Future<Either<HelperResponse, bool>> requestLocationPermission();
}
