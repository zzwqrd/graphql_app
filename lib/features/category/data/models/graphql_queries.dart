class CategoryGraphQLQueries {
  // Singleton instance
  static final CategoryGraphQLQueries _instance =
      CategoryGraphQLQueries._internal();
  factory CategoryGraphQLQueries() => _instance;
  CategoryGraphQLQueries._internal();

  String get categoriesQuery => '''
    query {
      categories {
        items {
          children {
            id
            uid
            name
            image
            children {
              id
              uid
              name
              image
            }
          }
        }
      }
    }
    ''';

  String categoryByIdQuery(String categoryUid) =>
      '''
    query {
      categories(filters: {category_uid: {eq: "$categoryUid"}}) {
        items {
          uid
          id
          name
          children {
            uid
            id
            name
            image
            children {
              uid
              id
              name
              image
            }
          }
        }
      }
    }
    ''';

  String queryWithFilters(String filterString) =>
      '''
    query {
      categories($filterString) {
        items {
          uid
          name
          children {
            uid
            name
            image
          }
          products {
            items {
              uid
              name
              sku
              small_image {
                url
              }
            }
          }
        }
      }
    }
    ''';
}
