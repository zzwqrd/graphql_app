import 'package:dartz/dartz.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/home_crafting_memories_model.dart';

class HomeCraftingMemoriesRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, CraftingMemoriesOutput>>
  getCraftingMemoriesBlock() async {
    return await graphQLQuery(
      '''
      query getProductCmsBlocks(\$identifiers: [String!]) {
        cmsBlocks(identifiers: \$identifiers) {
          items {
            identifier
            content
            title
            __typename
          }
           __typename
        }
      }
      ''',
      variables: {
        'identifiers': ['fragrances-uae-arabic'],
      },
      dataKey: 'cmsBlocks',
      fromJson: (json) =>
          CraftingMemoriesOutput.fromJson(json as Map<String, dynamic>),
    );
  }
}
