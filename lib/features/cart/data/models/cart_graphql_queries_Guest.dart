class CartGraphQLQueriesGuest {
  static final CartGraphQLQueriesGuest _instance =
      CartGraphQLQueriesGuest._internal();
  factory CartGraphQLQueriesGuest() => _instance;
  CartGraphQLQueriesGuest._internal();

  // 🔹 1. إنشاء سلة جديدة للزائر
  String get createEmptyCartMutation => '''
    mutation CreateEmptyCart {
      createEmptyCart
    }
  ''';

  String addToGuestCartMutation(String cartId, String sku, double quantity) =>
      '''
    mutation AddToGuestCart(\$cartId: String!, \$sku: String!, \$quantity: Float!) {
      addProductsToCart(
        cartId: \$cartId
        cartItems: [
          {
            sku: \$sku
            quantity: \$quantity
          }
        ]
      ) {
        cart {
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
        user_errors {
          code
          message
        }
      }
    }
  ''';

  // في CartGraphQLQueriesGuest
  String getGuestCartQuery(String cartId) => '''
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

  // 🔹 4. تحديث كمية منتج
  String updateGuestCartItemMutation(
    String cartId,
    String itemId,
    double quantity,
  ) => '''
    mutation UpdateGuestCartItem(\$cartId: String!, \$itemId: ID!, \$quantity: Float!) {
      updateCartItems(
        input: {
          cart_id: \$cartId
          cart_items: [
            {
              cart_item_uid: \$itemId
              quantity: \$quantity
            }
          ]
        }
      ) {
        cart {
          id
          items {
            uid
            quantity
            product {
              uid
              name
              sku
            }
          }
        }
        user_errors {
          code
          message
        }
      }
    }
  ''';

  // 🔹 5. حذف منتج من سلة الزائر
  String removeFromGuestCartMutation(String cartId, String itemId) => '''
    mutation RemoveFromGuestCart(\$cartId: String!, \$itemId: ID!) {
      removeItemFromCart(
        input: {
          cart_id: \$cartId
          cart_item_uid: \$itemId
        }
      ) {
        cart {
          id
          items {
            uid
            quantity
            product {
              uid
              name
              sku
            }
          }
        }
        user_errors {
          code
          message
        }
      }
    }
  ''';
}
