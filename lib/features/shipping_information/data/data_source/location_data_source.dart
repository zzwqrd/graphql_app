import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/services/helper_respons.dart';
import '../model/model.dart';

/// Data source for location operations
class LocationDataSource {
  /// Get current device position
  Future<Either<HelperResponse, Position>> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(
          HelperResponse.badRequest(
            message: 'خدمات الموقع غير مفعلة. الرجاء تفعيلها من الإعدادات',
            statusCode: 0,
          ),
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      return Right(position);
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل الحصول على الموقع الحالي: ${e.toString()}',
          statusCode: 0,
        ),
      );
    }
  }

  /// Convert coordinates to address using geocoding
  Future<Either<HelperResponse, AddressLocationModel>> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return Left(
          HelperResponse.notFound(
            message: 'لم يتم العثور على عنوان لهذا الموقع',
            statusCode: 0,
          ),
        );
      }

      Placemark place = placemarks.first;

      // Build address string
      String address = '';
      if (place.street != null && place.street!.isNotEmpty) {
        address += place.street!;
      }
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        address += address.isEmpty
            ? place.subLocality!
            : ', ${place.subLocality}';
      }
      if (place.locality != null && place.locality!.isNotEmpty) {
        address += address.isEmpty ? place.locality! : ', ${place.locality}';
      }
      if (place.country != null && place.country!.isNotEmpty) {
        address += address.isEmpty ? place.country! : ', ${place.country}';
      }

      if (address.isEmpty) {
        address = 'Unknown Location Found';
      }

      return Right(
        AddressLocationModel(
          latitude: latitude,
          longitude: longitude,
          address: address,
          city: place.locality,
          country: place.country,
        ),
      );
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل تحويل الإحداثيات إلى عنوان: ${e.toString()}',
          statusCode: 0,
        ),
      );
    }
  }

  /// Check location permission status
  Future<Either<HelperResponse, bool>> checkPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      bool hasPermission =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      return Right(hasPermission);
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل فحص صلاحيات الموقع: ${e.toString()}',
          statusCode: 0,
        ),
      );
    }
  }

  /// Request location permission
  Future<Either<HelperResponse, bool>> requestPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return Left(
          HelperResponse.forbidden(
            message:
                'تم رفض صلاحيات الموقع بشكل دائم. الرجاء تفعيلها من إعدادات التطبيق',
            statusCode: 0,
          ),
        );
      }

      if (permission == LocationPermission.denied) {
        return Left(
          HelperResponse.forbidden(
            message: 'تم رفض صلاحيات الموقع',
            statusCode: 0,
          ),
        );
      }
      return Right(true);
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل طلب صلاحيات الموقع: ${e.toString()}',
          statusCode: 0,
        ),
      );
    }
  }
}
