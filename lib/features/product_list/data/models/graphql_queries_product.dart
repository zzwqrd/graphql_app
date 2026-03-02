import 'product_model.dart';

class ProductGraphQLQueries {
  // Singleton instance
  static final ProductGraphQLQueries _instance =
      ProductGraphQLQueries._internal();
  factory ProductGraphQLQueries() => _instance;
  ProductGraphQLQueries._internal();

  String get _productFragment => '''
    __typename
    ... on SimpleProduct {
      uid
      id
      name
      sku
      stock_status
      small_image { url }
      price_range {
        minimum_price {
          regular_price { value currency }
          final_price { value currency }
          discount { amount_off percent_off }
        }
      }
    }
    ... on ConfigurableProduct {
      uid
      id
      name
      sku
      stock_status
      small_image { url }
      price_range {
        minimum_price {
          regular_price { value currency }
          final_price { value currency }
          discount { amount_off percent_off }
        }
      }
    }
    ... on BundleProduct {
      uid
      id
      name
      sku
      stock_status
      small_image { url }
      price_range {
        minimum_price {
          regular_price { value currency }
          final_price { value currency }
          discount { amount_off percent_off }
        }
      }
    }
    ... on GroupedProduct {
      uid
      id
      name
      sku
      stock_status
      small_image { url }
      price_range {
        minimum_price {
          regular_price { value currency }
          final_price { value currency }
          discount { amount_off percent_off }
        }
      }
    }
    ... on DownloadableProduct {
      uid
      id
      name
      sku
      stock_status
      small_image { url }
      price_range {
        minimum_price {
          regular_price { value currency }
          final_price { value currency }
          discount { amount_off percent_off }
        }
      }
    }
    ... on VirtualProduct {
      uid
      id
      name
      sku
      stock_status
      small_image { url }
      price_range {
        minimum_price {
          regular_price { value currency }
          final_price { value currency }
          discount { amount_off percent_off }
        }
      }
    }
  ''';

  String query({
    required String categoryUid,
    Map<String, List<String>>? filters,
    SortOption? sortOption,
    String? searchQuery,
    int page = 1,
  }) {
    // 1. Build Filter String
    final List<String> filterParts = [];
    filterParts.add('category_id: {eq: "$categoryUid"}');

    if (filters != null) {
      filters.forEach((key, values) {
        if (key == 'price' && values.isNotEmpty) {
          final parts = values.first.split('_');
          if (parts.length == 2) {
            final from = parts[0];
            final to = parts[1];
            String priceFilter = 'price: {from: "$from"';
            if (to != '*') {
              priceFilter += ', to: "$to"';
            }
            priceFilter += '}';
            filterParts.add(priceFilter);
          }
        }
      });
    }
    final filterString = 'filter: {${filterParts.join(', ')}}';

    // 2. Build Sort String
    String sortString = '';
    if (sortOption != null) {
      switch (sortOption) {
        case SortOption.nameAsc:
          sortString = 'sort: {name: ASC}';
          break;
        case SortOption.nameDesc:
          sortString = 'sort: {name: DESC}';
          break;
        case SortOption.priceAsc:
          sortString = 'sort: {price: ASC}';
          break;
        case SortOption.priceDesc:
          sortString = 'sort: {price: DESC}';
          break;
        case SortOption.positionAsc:
          sortString = 'sort: {position: ASC}';
          break;
        case SortOption.positionDesc:
          sortString = 'sort: {position: DESC}';
          break;
      }
    }

    // 3. Build Search String
    String searchString = '';
    if (searchQuery != null && searchQuery.isNotEmpty) {
      searchString = 'search: "$searchQuery"';
    }

    // Combine arguments
    final List<String> args = [filterString];
    if (sortString.isNotEmpty) args.add(sortString);
    if (searchString.isNotEmpty) args.add(searchString);
    args.add('currentPage: $page');
    args.add('pageSize: 20');

    return '''
    query {
      products(${args.join(', ')}) {
        items {
          $_productFragment
        }
        aggregations {
          attribute_code
          label
          options {
            label
            value
            count
          }
        }
      }
    }
    ''';
  }
}
