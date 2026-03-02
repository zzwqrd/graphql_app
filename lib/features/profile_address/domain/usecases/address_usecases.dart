import 'package:dartz/dartz.dart';
import '../../../../core/services/helper_respons.dart';
import '../entities/address_entity.dart';
import '../repository/address_repository.dart';
import '../../data/repositories/address_repository_impl.dart';

/// Get Addresses Use Case
class GetAddressesUseCase {
  final AddressRepository repository;

  GetAddressesUseCase({AddressRepository? repository})
    : repository = repository ?? AddressRepositoryImpl();

  Future<Either<HelperResponse, List<AddressEntity>>> call() async {
    return await repository.getAddresses();
  }
}

/// Add Address Use Case
class AddAddressUseCase {
  final AddressRepository repository;

  AddAddressUseCase({AddressRepository? repository})
    : repository = repository ?? AddressRepositoryImpl();

  Future<Either<HelperResponse, AddressEntity>> call(
    AddressEntity address,
  ) async {
    return await repository.addAddress(address);
  }
}

/// Update Address Use Case
class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase({AddressRepository? repository})
    : repository = repository ?? AddressRepositoryImpl();

  Future<Either<HelperResponse, AddressEntity>> call(
    AddressEntity address,
  ) async {
    return await repository.updateAddress(address);
  }
}

/// Delete Address Use Case
class DeleteAddressUseCase {
  final AddressRepository repository;

  DeleteAddressUseCase({AddressRepository? repository})
    : repository = repository ?? AddressRepositoryImpl();

  Future<Either<HelperResponse, bool>> call(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}

/// Set Default Address Use Case
class SetDefaultAddressUseCase {
  final AddressRepository repository;

  SetDefaultAddressUseCase({AddressRepository? repository})
    : repository = repository ?? AddressRepositoryImpl();

  Future<Either<HelperResponse, AddressEntity>> call(String addressId) async {
    return await repository.setDefaultAddress(addressId);
  }
}
