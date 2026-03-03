import 'package:dartz/dartz.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/helper_respons.dart';
import '../models/cms_block_model.dart';

class CmsBlockRemoteDataSource with ApiClient {
  Future<Either<HelperResponse, CmsBlocksOutput>> getProductCmsBlocks(
    List<String> identifiers,
  ) async {
    return await graphQLQuery(
      '''
      query getProductCmsBlocks(\$identifiers: [String!]) {
        cmsBlocks(identifiers: \$identifiers) {
          items {
            identifier
            content
            title
          }
        }
      }
      ''',
      variables: {'identifiers': identifiers},
      dataKey: 'cmsBlocks',
      fromJson: (json) =>
          CmsBlocksOutput.fromJson(json as Map<String, dynamic>),
    );
  }
}
