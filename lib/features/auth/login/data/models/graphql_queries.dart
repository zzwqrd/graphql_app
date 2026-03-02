class GraphQLQueries {
  // Singleton instance
  static final GraphQLQueries _instance = GraphQLQueries._internal();
  factory GraphQLQueries() => _instance;
  GraphQLQueries._internal();

  // 🔐 LOGIN MUTATION
  String get loginMutation => '''
    mutation GenerateCustomerToken(\$email: String!, \$password: String!) {
      generateCustomerToken(email: \$email, password: \$password) {
        token
      }
    }
  ''';

  // 👤 CUSTOMER QUERY
  String get customerQuery => '''
    query GetCustomer {
      customer {
        id
        firstname
        lastname
        email
        date_of_birth
        gender
        is_subscribed
        addresses {
          firstname
          lastname
          street
          city
          region {
            region_code
            region
          }
          postcode
          country_code
          telephone
        }
      }
    }
  ''';

  // 📦 CUSTOMER ORDERS QUERY
  String get customerOrders => '''
    query GetCustomerOrders(\$pageSize: Int = 20, \$currentPage: Int = 1) {
      customer {
        orders(pageSize: \$pageSize, currentPage: \$currentPage) {
          total_count
          items {
            id
            order_number
            created_at
            status
            grand_total
            total_item_count
            items {
              product_name
              product_sku
              product_sale_price {
                value
                currency
              }
              quantity_ordered
            }
          }
        }
      }
    }
  ''';

  // ✏️ UPDATE CUSTOMER MUTATION
  String get updateCustomer => '''
    mutation UpdateCustomer(
      \$firstname: String
      \$lastname: String
      \$email: String
      \$password: String
    ) {
      updateCustomer(
        input: {
          firstname: \$firstname
          lastname: \$lastname
          email: \$email
          password: \$password
        }
      ) {
        customer {
          firstname
          lastname
          email
        }
      }
    }
  ''';
  // 🔍 GLOBAL SEARCH PRODUCTS QUERY (Comprehensive search across all categories)
  String get searchProducts => '''
    query SearchProducts(\$search: String!, \$pageSize: Int = 20, \$currentPage: Int = 1) {
      products(
        search: \$search
        pageSize: \$pageSize
        currentPage: \$currentPage
      ) {
        items {
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
        total_count
      }
    }
  ''';
  // 🕒 RECENTLY VIEWED PRODUCTS QUERY
  String get getSearchHistory => '''
    query GetRecentlyViewedProducts {
      customer {
        recently_viewed_products(pageSize: 10) {
          items {
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
      }
    }
  ''';
  // ❤️ GET WISHLIST QUERY
  String get getWishlist => '''
    query GetWishlist {
      customer {
        wishlist {
          id
          items_count
          items_v2(currentPage: 1, pageSize: 20) {
            items {
              id
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
          }
        }
      }
    }
  ''';

  // ➕ ADD TO WISHLIST MUTATION
  String get addProductsToWishlist => '''
    mutation AddProductsToWishlist(\$wishlistId: ID!, \$sku: String!) {
      addProductsToWishlist(
        wishlistId: \$wishlistId
        wishlistItems: [{ sku: \$sku, quantity: 1 }]
      ) {
        wishlist {
          id
          items_count
          items_v2(currentPage: 1, pageSize: 20) {
            items {
              id
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
          }
        }
        user_errors {
          code
          message
        }
      }
    }
  ''';

  // ➖ REMOVE FROM WISHLIST MUTATION
  String get removeProductsFromWishlist => '''
    mutation RemoveProductsFromWishlist(\$wishlistId: ID!, \$itemIds: [ID!]!) {
      removeProductsFromWishlist(
        wishlistId: \$wishlistId
        wishlistItemsIds: \$itemIds
      ) {
        wishlist {
          id
          items_count
          items_v2(currentPage: 1, pageSize: 20) {
            items {
              id
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
