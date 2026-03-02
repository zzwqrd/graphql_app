import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/helper_respons.dart';
import '../../../../di/service_locator.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repository/address_repository.dart';
import '../data_sources/address_local_data_source.dart';
import '../data_sources/address_remote_data_source.dart';
import '../models/address_model.dart';

/// Address Repository Implementation
/// Handles both authenticated (GraphQL) and guest (local) users
class AddressRepositoryImpl implements AddressRepository {
  late final AddressRemoteDataSource _remoteDataSource;
  late final AddressLocalDataSource _localDataSource;

  AddressRepositoryImpl() {
    _remoteDataSource = AddressRemoteDataSource();
    _localDataSource = AddressLocalDataSource(prefs: sl<SharedPreferences>());
  }

  /// Check if user is authenticated
  Future<bool> _isAuthenticated() async {
    final prefs = sl<SharedPreferences>();
    final token = prefs.getString('customer_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<HelperResponse, List<AddressEntity>>> getAddresses() async {
    try {
      final isAuth = await _isAuthenticated();

      if (isAuth) {
        // Get addresses from GraphQL
        final result = await _remoteDataSource.getCustomerAddresses();
        return result.fold(
          (error) => Left(error),
          (addresses) =>
              Right(addresses.map((model) => model.toEntity()).toList()),
        );
      } else {
        // Get addresses from local storage
        final addresses = await _localDataSource.getGuestAddresses();
        return Right(addresses.map((model) => model.toEntity()).toList());
      }
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل تحميل العناوين: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, AddressEntity>> addAddress(
    AddressEntity address,
  ) async {
    try {
      final isAuth = await _isAuthenticated();
      final addressModel = AddressModel.fromEntity(address);

      if (isAuth) {
        // Add via GraphQL
        final result = await _remoteDataSource.createCustomerAddress(
          addressModel,
        );
        return result.fold(
          (error) => Left(error),
          (createdAddress) => Right(createdAddress.toEntity()),
        );
      } else {
        // Add to local storage
        await _localDataSource.saveGuestAddress(addressModel);
        return Right(address);
      }
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل إضافة العنوان: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, AddressEntity>> updateAddress(
    AddressEntity address,
  ) async {
    try {
      final isAuth = await _isAuthenticated();
      final addressModel = AddressModel.fromEntity(address);

      if (isAuth) {
        // Update via GraphQL
        final result = await _remoteDataSource.updateCustomerAddress(
          addressModel,
        );
        return result.fold(
          (error) => Left(error),
          (updatedAddress) => Right(updatedAddress.toEntity()),
        );
      } else {
        // Update in local storage
        await _localDataSource.updateGuestAddress(addressModel);
        return Right(address);
      }
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل تحديث العنوان: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, bool>> deleteAddress(String addressId) async {
    try {
      final isAuth = await _isAuthenticated();

      if (isAuth) {
        // Delete via GraphQL
        final result = await _remoteDataSource.deleteCustomerAddress(addressId);
        return result.fold((error) => Left(error), (success) => Right(success));
      } else {
        // Delete from local storage
        await _localDataSource.deleteGuestAddress(addressId);
        return const Right(true);
      }
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل حذف العنوان: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<HelperResponse, AddressEntity>> setDefaultAddress(
    String addressId,
  ) async {
    try {
      final isAuth = await _isAuthenticated();

      if (isAuth) {
        // Set default via GraphQL
        final result = await _remoteDataSource.setDefaultAddress(addressId);
        return result.fold(
          (error) => Left(error),
          (updatedAddress) => Right(updatedAddress.toEntity()),
        );
      } else {
        // Set default in local storage
        await _localDataSource.setDefaultGuestAddress(addressId);
        final addresses = await _localDataSource.getGuestAddresses();
        final defaultAddress = addresses.firstWhere((a) => a.id == addressId);
        return Right(defaultAddress.toEntity());
      }
    } catch (e) {
      return Left(
        HelperResponse.unknownError(
          message: 'فشل تعيين العنوان الافتراضي: ${e.toString()}',
        ),
      );
    }
  }
}
