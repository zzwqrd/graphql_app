import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../entities/address_entity.dart';

/// Address Repository Interface - Domain Layer
/// Defines contract for address data operations
abstract class AddressRepository {
  /// Get all addresses for current user (authenticated or guest)
  Future<Either<HelperResponse, List<AddressEntity>>> getAddresses();

  /// Add a new address
  Future<Either<HelperResponse, AddressEntity>> addAddress(
    AddressEntity address,
  );

  /// Update an existing address
  Future<Either<HelperResponse, AddressEntity>> updateAddress(
    AddressEntity address,
  );

  /// Delete an address by ID
  Future<Either<HelperResponse, bool>> deleteAddress(String addressId);

  /// Set an address as default
  Future<Either<HelperResponse, AddressEntity>> setDefaultAddress(
    String addressId,
  );
}
