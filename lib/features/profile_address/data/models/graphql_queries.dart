/// GraphQL Queries for Address Management
class AddressGraphQLQueries {
  /// Get customer addresses
  String getCustomerAddressesQuery() {
    return '''
      query {
        customer {
          addresses {
            id
            firstname
            lastname
            street
            city
            region {
              region
              region_code
            }
            postcode
            country_code
            telephone
            default_shipping
            default_billing
          }
        }
      }
    ''';
  }

  /// Create customer address mutation
  String createCustomerAddressMutation() {
    return '''
      mutation createCustomerAddress(\$input: CustomerAddressInput!) {
        createCustomerAddress(input: \$input) {
          id
          firstname
          lastname
          street
          city
          region {
            region
            region_code
          }
          postcode
          country_code
          telephone
          default_shipping
          default_billing
        }
      }
    ''';
  }

  /// Update customer address mutation
  String updateCustomerAddressMutation() {
    return '''
      mutation updateCustomerAddress(\$id: Int!, \$input: CustomerAddressInput!) {
        updateCustomerAddress(id: \$id, input: \$input) {
          id
          firstname
          lastname
          street
          city
          region {
            region
            region_code
          }
          postcode
          country_code
          telephone
          default_shipping
          default_billing
        }
      }
    ''';
  }

  /// Delete customer address mutation
  String deleteCustomerAddressMutation() {
    return '''
      mutation deleteCustomerAddress(\$id: Int!) {
        deleteCustomerAddress(id: \$id)
      }
    ''';
  }

  /// Set default address mutation (via update)
  String setDefaultAddressMutation() {
    return '''
      mutation updateCustomerAddress(\$id: Int!, \$input: CustomerAddressInput!) {
        updateCustomerAddress(id: \$id, input: \$input) {
          id
          firstname
          lastname
          street
          city
          region {
            region
            region_code
          }
          postcode
          country_code
          telephone
          default_shipping
          default_billing
        }
      }
    ''';
  }
}
