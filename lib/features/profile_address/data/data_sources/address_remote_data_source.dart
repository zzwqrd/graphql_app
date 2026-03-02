import 'package:dartz/dartz.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/address_model.dart';
import '../models/graphql_queries.dart';

/// Remote Data Source for Authenticated Users
/// Uses ApiClient mixin for GraphQL operations
class AddressRemoteDataSource with ApiClient {
  final _queries = AddressGraphQLQueries();

  /// Get customer addresses from GraphQL
  Future<Either<HelperResponse, List<AddressModel>>>
  getCustomerAddresses() async {
    return await graphQLQuery<List<AddressModel>>(
      _queries.getCustomerAddressesQuery(),
      fromJson: (json) {
        if (json is Map<String, dynamic> && json.containsKey('addresses')) {
          final List<dynamic> addressesJson = json['addresses'] ?? [];
          return addressesJson
              .map(
                (item) => AddressModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        return [];
      },
      dataKey: 'customer',
    );
  }

  /// Create a new customer address via GraphQL mutation
  Future<Either<HelperResponse, AddressModel>> createCustomerAddress(
    AddressModel address,
  ) async {
    final variables = {
      'input': {
        'firstname': 'Customer', // TODO: Get from user profile
        'lastname': 'Name',
        'street': [address.street],
        if (address.city != null) 'city': address.city,
        if (address.region != null) 'region': {'region': address.region},
        if (address.postcode != null) 'postcode': address.postcode,
        if (address.country != null) 'country_code': address.country,
        if (address.telephone != null) 'telephone': address.telephone,
        'default_shipping': address.isDefault,
        'default_billing': address.isDefault,
      },
    };

    return await graphQLMutation<AddressModel>(
      _queries.createCustomerAddressMutation(),
      variables: variables,
      fromJson: (json) => AddressModel.fromJson(json as Map<String, dynamic>),
      dataKey: 'createCustomerAddress',
    );
  }

  /// Update an existing customer address
  Future<Either<HelperResponse, AddressModel>> updateCustomerAddress(
    AddressModel address,
  ) async {
    if (address.id == null) {
      return Left(
        HelperResponse.badRequest(message: 'Address ID is required for update'),
      );
    }

    final variables = {
      'id': int.parse(address.id!),
      'input': {
        'firstname': 'Customer',
        'lastname': 'Name',
        'street': [address.street],
        if (address.city != null) 'city': address.city,
        if (address.region != null) 'region': {'region': address.region},
        if (address.postcode != null) 'postcode': address.postcode,
        if (address.country != null) 'country_code': address.country,
        if (address.telephone != null) 'telephone': address.telephone,
        'default_shipping': address.isDefault,
        'default_billing': address.isDefault,
      },
    };

    return await graphQLMutation<AddressModel>(
      _queries.updateCustomerAddressMutation(),
      variables: variables,
      fromJson: (json) => AddressModel.fromJson(json as Map<String, dynamic>),
      dataKey: 'updateCustomerAddress',
    );
  }

  /// Delete a customer address
  Future<Either<HelperResponse, bool>> deleteCustomerAddress(
    String addressId,
  ) async {
    final variables = {'id': int.parse(addressId)};

    return await graphQLMutation<bool>(
      _queries.deleteCustomerAddressMutation(),
      variables: variables,
      fromJson: (json) => json == true,
      dataKey: 'deleteCustomerAddress',
    );
  }

  /// Set default shipping address
  Future<Either<HelperResponse, AddressModel>> setDefaultAddress(
    String addressId,
  ) async {
    final variables = {
      'id': int.parse(addressId),
      'input': {'default_shipping': true, 'default_billing': true},
    };

    return await graphQLMutation<AddressModel>(
      _queries.setDefaultAddressMutation(),
      variables: variables,
      fromJson: (json) => AddressModel.fromJson(json as Map<String, dynamic>),
      dataKey: 'updateCustomerAddress',
    );
  }
}
