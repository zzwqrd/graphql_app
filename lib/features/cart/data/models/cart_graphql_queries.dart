class CartGraphQLQueries {
  static final CartGraphQLQueries _instance = CartGraphQLQueries._internal();
  factory CartGraphQLQueries() => _instance;
  CartGraphQLQueries._internal();
  String getCartQuery({bool isLoggedIn = false, String? cartId}) {
    if (isLoggedIn) {
      return _getCustomerCartQuery();
    } else {
      return _getGuestCartQuery(cartId: cartId);
    }
  }

  // للعميل المسجل
  String _getCustomerCartQuery() => '''
    query GetCustomerCart {
      customerCart {
        id
        total_quantity
        items {
          uid
          quantity
          product {
            uid
            name
            sku
            stock_status
            small_image {
              url
            }
            price_range {
              minimum_price {
                regular_price {
                  value
                  currency
                }
                final_price {
                  value
                  currency
                }
                discount {
                  amount_off
                  percent_off
                }
              }
            }
          }
        }
        prices {
          grand_total {
            value
            currency
          }
          subtotal_excluding_tax {
            value
            currency
          }
          subtotal_including_tax {
            value
            currency
          }
        }
        email
      }
    }
  ''';

  // للضيف
  String _getGuestCartQuery({String? cartId}) {
    if (cartId == null || cartId.isEmpty) {
      return '''
        query {
          __typename # استعلام فارغ إذا لم يكن هناك cartId
        }
      ''';
    }

    return '''
      query GetGuestCart(\$cartId: String!) {
        cart(cart_id: \$cartId) {
          id
          total_quantity
          items {
            uid
            quantity
            product {
              uid
              name
              sku
              stock_status
              small_image {
                url
              }
              price_range {
                minimum_price {
                  regular_price {
                    value
                    currency
                  }
                  final_price {
                    value
                    currency
                  }
                  discount {
                    amount_off
                    percent_off
                  }
                }
              }
            }
          }
          prices {
            grand_total {
              value
              currency
            }
            subtotal_excluding_tax {
              value
              currency
            }
            subtotal_including_tax {
              value
              currency
            }
          }
        }
      }
    ''';
  }

  String guestCartQuery(String cartId) =>
      '''
  query {
    cart(cart_id: "$cartId") {
      id
      total_quantity
      items {
        uid
        quantity
        product {
          uid
          name
          sku
          stock_status
          small_image {
            url
          }
          price_range {
            minimum_price {
              regular_price {
                value
                currency
              }
              final_price {
                value
                currency
              }
              discount {
                amount_off
                percent_off
              }
            }
          }
        }
      }
      prices {
        grand_total {
          value
          currency
        }
      }
    }
  }
''';

  String get cartQuery => '''
    query {
      customerCart {
        id
        total_quantity
        items {
          uid
          quantity
          product {
            uid
            name
            sku
            stock_status
            small_image {
              url
            }
            price_range {
              minimum_price {
                regular_price {
                  value
                  currency
                }
                final_price {
                  value
                  currency
                }
                discount {
                  amount_off
                  percent_off
                }
              }
            }
          }
        }
        prices {
          grand_total {
            value
            currency
          }
        }
      }
    }
  ''';

  String addToCartMutation(String cartId, String sku, double quantity) =>
      '''
    mutation {
      addProductsToCart(
        cartId: "$cartId"
        cartItems: [{ sku: "$sku", quantity: $quantity }]
      ) {
        cart {
          items {
            uid
            quantity
            product {
              uid
              name
              sku
              stock_status
              small_image {
                url
              }
              price_range {
                minimum_price {
                  regular_price {
                    value
                    currency
                  }
                  final_price {
                    value
                    currency
                  }
                  discount {
                    amount_off
                    percent_off
                  }
                }
              }
            }
          }
          prices {
            grand_total {
              value
              currency
            }
          }
        }
      }
    }
  ''';

  String updateCartItemsMutation(
    String cartId,
    String cartItemId,
    double quantity,
  ) =>
      '''
    mutation {
      updateCartItems(
        input: {
          cart_id: "$cartId"
          cart_items: [{ cart_item_uid: "$cartItemId", quantity: $quantity }]
        }
      ) {
        cart {
          items {
            uid
            quantity
            product {
              uid
              name
              sku
              stock_status
              small_image {
                url
              }
              price_range {
                minimum_price {
                  regular_price {
                    value
                    currency
                  }
                  final_price {
                    value
                    currency
                  }
                  discount {
                    amount_off
                    percent_off
                  }
                }
              }
            }
          }
          prices {
            grand_total {
              value
              currency
            }
          }
        }
      }
    }
  ''';

  String removeItemFromCartMutation(String cartId, String cartItemId) =>
      '''
    mutation {
      removeItemFromCart(
        input: {
          cart_id: "$cartId"
          cart_item_uid: "$cartItemId"
        }
      ) {
        cart {
          items {
            uid
            quantity
            product {
              uid
              name
              sku
              stock_status
              small_image {
                url
              }
              price_range {
                minimum_price {
                  regular_price {
                    value
                    currency
                  }
                  final_price {
                    value
                    currency
                  }
                  discount {
                    amount_off
                    percent_off
                  }
                }
              }
            }
          }
          prices {
            grand_total {
              value
              currency
            }
          }
        }
      }
    }
  ''';

  String get createEmptyCartMutation => '''
    mutation {
      createEmptyCart
    }
  ''';
}
