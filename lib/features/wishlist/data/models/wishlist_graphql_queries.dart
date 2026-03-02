class WishlistGraphQLQueries {
  static final WishlistGraphQLQueries _instance =
      WishlistGraphQLQueries._internal();
  factory WishlistGraphQLQueries() => _instance;
  WishlistGraphQLQueries._internal();

  // Get wishlist with pagination support
  String getWishlist({int currentPage = 1, int pageSize = 20}) =>
      '''
    query {
      customer {
        wishlist {
          id
          items_count
          items_v2(currentPage: $currentPage, pageSize: $pageSize) {
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
            page_info {
              current_page
              page_size
              total_pages
            }
          }
        }
      }
    }
  ''';

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
      }
    }
  ''';

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
      }
    }
  ''';
}
