/// GraphQL Queries for Checkout
class CheckoutGraphQLQueries {
  /// Get available payment methods
  /// Note: In Magento, payment methods are retrieved from cart
  String getPaymentMethodsQuery() {
    return '''
      query {
        storeConfig {
          payment_methods {
            code
            title
          }
        }
      }
    ''';
  }

  /// Set Guest Email on Cart
  String setGuestEmailOnCartMutation() {
    return r'''
    mutation SetGuestEmail($cartId: String!, $email: String!) {
      setGuestEmailOnCart(input: {
        cart_id: $cartId,
        email: $email
      }) {
        cart {
          email
        }
      }
    }
    ''';
  }

  /// Set Shipping Address (Without Method)
  String setShippingAddressMutation() {
    return r'''
    mutation SetShipping(
      $cartId: String!
      $firstname: String!
      $lastname: String!
      $street: [String!]!
      $city: String!
      $region: String!
      $postcode: String!
      $country_code: String!
      $telephone: String!
    ) {
      setShippingAddressesOnCart(
        input: {
          cart_id: $cartId
          shipping_addresses: [
            {
              address: {
                firstname: $firstname
                lastname: $lastname
                street: $street
                city: $city
                region: $region
                postcode: $postcode
                country_code: $country_code
                telephone: $telephone
              }
            }
          ]
        }
      ) {
        cart {
          shipping_addresses {
            firstname
          }
        }
      }
    }
    ''';
  }

  /// Set Shipping Method
  String setShippingMethodMutation() {
    return r'''
    mutation SetShippingMethod(
      $cartId: String!
      $carrier_code: String!
      $method_code: String!
    ) {
      setShippingMethodsOnCart(
        input: {
          cart_id: $cartId
          shipping_methods: [
            {
              carrier_code: $carrier_code
              method_code: $method_code
            }
          ]
        }
      ) {
        cart {
          shipping_addresses {
            selected_shipping_method {
              carrier_code
              method_code
            }
          }
        }
      }
    }
    ''';
  }

  /// Set Billing Address
  String setBillingAddressMutation() {
    return r'''
    mutation SetBilling(
      $cartId: String!
      $firstname: String!
      $lastname: String!
      $street: [String!]!
      $city: String!
      $region: String!
      $postcode: String!
      $country_code: String!
      $telephone: String!
    ) {
      setBillingAddressOnCart(
        input: {
          cart_id: $cartId
          billing_address: {
            address: {
              firstname: $firstname
              lastname: $lastname
              street: $street
              city: $city
              region: $region
              postcode: $postcode
              country_code: $country_code
              telephone: $telephone
            }
          }
        }
      ) {
        cart {
          billing_address {
            firstname
          }
        }
      }
    }
    ''';
  }

  /// Get available shipping methods for cart
  String getAvailableShippingMethodsQuery() {
    return '''
      query getShippingMethods(\$cartId: String!) {
        cart(cart_id: \$cartId) {
          shipping_addresses {
            available_shipping_methods {
              carrier_code
              method_code
              carrier_title
              method_title
            }
          }
        }
      }
    ''';
  }

  /// Set Payment Method (COD)
  String setPaymentMethodMutation() {
    return r'''
    mutation SetPayment(
      $cartId: String!
      $paymentCode: String!
    ) {
      setPaymentMethodOnCart(
        input: {
          cart_id: $cartId
          payment_method: {
            code: $paymentCode
          }
        }
      ) {
        cart {
          selected_payment_method {
            code
          }
        }
      }
    }
    ''';
  }

  /// Place Order
  String placeOrderMutation() {
    return r'''
    mutation PlaceOrder($cartId: String!) {
      placeOrder(
        input: {
          cart_id: $cartId
        }
      ) {
        order {
          order_id
          order_number
        }
      }
    }
    ''';
  }

  /// Get order details
  String getOrderQuery() {
    return '''
      query getOrder(\$orderNumber: String!) {
        customer {
          orders(filter: {number: {eq: \$orderNumber}}) {
            items {
              id
              number
              order_date
              status
              total {
                grand_total {
                  value
                  currency
                }
                subtotal {
                  value
                }
                total_tax {
                  value
                }
                total_shipping {
                  value
                }
                discounts {
                  amount {
                    value
                  }
                }
              }
              payment_methods {
                name
                type
              }
            }
          }
        }
      }
    ''';
  }
}
