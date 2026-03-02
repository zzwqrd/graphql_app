import 'dart:developer' as dev;
import 'package:dartz/dartz.dart';
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../models/graphql_queries.dart';
import '../models/models.dart';

class CategoryRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, ModelsCategories>> getCategories() async {
    dev.log('🔍 [CategoryAPI] Fetching all categories...', name: 'CategoryAPI');

    final result = await graphQLQuery(
      CategoryGraphQLQueries().categoriesQuery,
      fromJson: (json) {
        dev.log(
          '📦 [CategoryAPI] Raw Response: ${json.toString().substring(0, json.toString().length > 500 ? 500 : json.toString().length)}...',
          name: 'CategoryAPI',
        );

        final model = ModelsCategories.fromJson(json);

        // Debug first category's image
        if (model.items.isNotEmpty && model.items.first.children.isNotEmpty) {
          final firstChild = model.items.first.children.first;
          dev.log(
            '🖼️ [CategoryAPI] First category image raw: ${firstChild.image}',
            name: 'CategoryAPI',
          );
          dev.log(
            '🖼️ [CategoryAPI] First category image processed: ${firstChild.displayImageUrl}',
            name: 'CategoryAPI',
          );
        }

        return model;
      },
      dataKey: 'categories',
    );

    result.fold(
      (error) => dev.log(
        '❌ [CategoryAPI] Error: ${error.message}',
        name: 'CategoryAPI',
      ),
      (success) => dev.log(
        '✅ [CategoryAPI] Success: ${success.items.length} categories loaded',
        name: 'CategoryAPI',
      ),
    );

    return result;
  }

  Future<Either<HelperResponse, ModelsCategories>> getCategoryById(
    String categoryUid,
  ) async {
    dev.log(
      '🔍 [CategoryAPI] Fetching category by ID: $categoryUid',
      name: 'CategoryAPI',
    );

    final result = await graphQLQuery(
      CategoryGraphQLQueries().categoryByIdQuery(categoryUid),
      fromJson: (json) {
        dev.log(
          '📦 [CategoryAPI] Raw Response for $categoryUid: ${json.toString().substring(0, json.toString().length > 500 ? 500 : json.toString().length)}...',
          name: 'CategoryAPI',
        );

        final model = ModelsCategories.fromJson(json);

        // Debug category details
        if (model.items.isNotEmpty) {
          final category = model.items.first;
          dev.log(
            '🖼️ [CategoryAPI] Category image raw: ${category.image}',
            name: 'CategoryAPI',
          );
          dev.log(
            '🖼️ [CategoryAPI] Category image processed: ${category.displayImageUrl}',
            name: 'CategoryAPI',
          );
          dev.log(
            '📦 [CategoryAPI] Products count: ${category.products.items.length}',
            name: 'CategoryAPI',
          );

          if (category.products.items.isNotEmpty) {
            final firstProduct = category.products.items.first;
            dev.log(
              '🛍️ [CategoryAPI] First product image raw: ${firstProduct.smallImage}',
              name: 'CategoryAPI',
            );
            dev.log(
              '🛍️ [CategoryAPI] First product image processed: ${firstProduct.displayImageUrl}',
              name: 'CategoryAPI',
            );
          }
        }

        return model;
      },
      dataKey: 'categories',
    );

    result.fold(
      (error) => dev.log(
        '❌ [CategoryAPI] Error: ${error.message}',
        name: 'CategoryAPI',
      ),
      (success) => dev.log(
        '✅ [CategoryAPI] Success: Category loaded with ${success.items.length} items',
        name: 'CategoryAPI',
      ),
    );

    return result;
  }

  Future<Either<HelperResponse, ModelsCategories>> getCategoriesWithFilters({
    String? parentUid,
    List<String>? uids,
    String? name,
  }) async {
    final filters = <String>[];

    if (parentUid != null) {
      filters.add('parent_category_uid: {eq: "$parentUid"}');
    }

    if (uids != null && uids.isNotEmpty) {
      final uidsString = uids.map((uid) => '"$uid"').join(', ');
      filters.add('category_uid: {in: [$uidsString]}');
    }

    if (name != null) {
      filters.add('name: {eq: "$name"}');
    }

    final filterString = filters.isNotEmpty
        ? 'filters: {${filters.join(', ')}}'
        : '';

    dev.log(
      '🔍 [CategoryAPI] Fetching categories with filters: $filterString',
      name: 'CategoryAPI',
    );

    final result = await graphQLQuery(
      CategoryGraphQLQueries().queryWithFilters(filterString),
      fromJson: (json) {
        dev.log(
          '📦 [CategoryAPI] Filtered Response: ${json.toString().substring(0, json.toString().length > 300 ? 300 : json.toString().length)}...',
          name: 'CategoryAPI',
        );
        return ModelsCategories.fromJson(json);
      },
      dataKey: 'categories',
    );

    result.fold(
      (error) => dev.log(
        '❌ [CategoryAPI] Filter Error: ${error.message}',
        name: 'CategoryAPI',
      ),
      (success) => dev.log(
        '✅ [CategoryAPI] Filter Success: ${success.items.length} categories',
        name: 'CategoryAPI',
      ),
    );

    return result;
  }
}
