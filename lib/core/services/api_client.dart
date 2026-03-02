import 'package:dartz/dartz.dart';

import '../utils/enums.dart';
import 'dio_services.dart';
import 'helper_respons.dart';

/// 🌍 Base Mixin for any DataSource
/// يدعم REST API + GraphQL مع تطبيق كامل لمبادئ SOLID
mixin ApiClient {
  final DioServices _dio = DioServices.instance;

  // 🔧 دالة مساعدة مركزية للـ REST
  Either<HelperResponse, T> _handleApiResponse<T>({
    required HelperResponse response,
    required T Function(dynamic json) fromJson,
  }) {
    if (response.success == true && response.statusCode == 200) {
      return Right(fromJson(response.data));
    } else {
      return Left(response);
    }
  }

  // 🔧 دالة مساعدة مركزية للـ GraphQL
  Either<HelperResponse, T> _handleGraphQLResponse<T>({
    required HelperResponse response,
    required T Function(dynamic json) fromJson,
    String? dataKey,
  }) {
    if (response.success == true && response.statusCode == 200) {
      try {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          // التحقق من وجود أخطاء GraphQL
          if (responseData.containsKey('errors')) {
            final errors = responseData['errors'];
            final errorMessage = errors is List && errors.isNotEmpty
                ? errors[0]['message']?.toString() ?? 'GraphQL error'
                : 'GraphQL error';

            return Left(
              HelperResponse(
                statusCode: 400,
                success: false,
                message: errorMessage,
                errorType: ErrorRequestType.badRequest,
                data: responseData,
                state: ResponseState.badRequest,
              ),
            );
          }

          // استخراج البيانات
          if (responseData.containsKey('data')) {
            final data = responseData['data'];
            if (dataKey != null && data is Map<String, dynamic>) {
              return Right(fromJson(data[dataKey]));
            } else {
              return Right(fromJson(data));
            }
          }
        }

        return Right(fromJson(responseData));
      } catch (e) {
        return Left(
          HelperResponse(
            statusCode: 500,
            success: false,
            errorType: ErrorRequestType.badRequest,

            message: 'GraphQL parsing failed: $e',
            state: ResponseState.badRequest,
            data: response.data,
          ),
        );
      }
    } else {
      return Left(response);
    }
  }

  /// -----------------------------
  /// 🟪 GRAPHQL METHODS
  /// -----------------------------

  /// 🟪 GraphQL Query Request
  Future<Either<HelperResponse, T>> graphQLQuery<T>(
    String query, {
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
    bool requireAuth = true,
    required T Function(dynamic json) fromJson,
    String? dataKey,
  }) async {
    final graphQLData = {
      'query': query,
      if (variables != null) 'variables': variables,
    };

    final response = await _dio.post(
      '/graphql',
      data: graphQLData,
      headers: {'Content-Type': 'application/json', ...?headers},
      requireAuth: requireAuth,
    );

    return _handleGraphQLResponse(
      response: response,
      fromJson: fromJson,
      dataKey: dataKey,
    );
  }

  /// 🟪 GraphQL Mutation Request
  Future<Either<HelperResponse, T>> graphQLMutation<T>(
    String mutation, {
    Map<String, dynamic>? variables,
    Map<String, String>? headers,
    bool requireAuth = true,
    required T Function(dynamic json) fromJson,
    String? dataKey,
  }) async {
    return graphQLQuery<T>(
      mutation,
      variables: variables,
      headers: headers,
      requireAuth: requireAuth,
      fromJson: fromJson,
      dataKey: dataKey,
    );
  }

  /// -----------------------------
  /// 🟩 REST API METHODS
  /// -----------------------------

  /// 🟩 POST Request
  Future<Either<HelperResponse, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? formData,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    bool isFormData = false,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      formData: formData,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
      isFormData: isFormData,
    );

    return _handleApiResponse(response: response, fromJson: fromJson);
  }

  /// 🟦 GET Request
  Future<Either<HelperResponse, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    bool cache = false,
    int retryCount = 0,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
      cache: cache,
      retryCount: retryCount,
    );

    return _handleApiResponse(response: response, fromJson: fromJson);
  }

  /// 🟦 GET Request for Lists
  Future<Either<HelperResponse, List<T>>> getList<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    bool cache = false,
    int retryCount = 0,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
      cache: cache,
      retryCount: retryCount,
    );

    return _handleApiResponse<List<T>>(
      response: response,
      fromJson: (json) {
        if (json is List) {
          return json.map<T>((item) => fromJson(item)).toList();
        }
        throw FormatException('Expected List but got ${json.runtimeType}');
      },
    );
  }

  /// 🟨 PUT Request
  Future<Either<HelperResponse, T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
    );

    return _handleApiResponse(response: response, fromJson: fromJson);
  }

  /// 🟥 DELETE Request
  Future<Either<HelperResponse, T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.delete(
      path,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
    );

    return _handleApiResponse(response: response, fromJson: fromJson);
  }

  /// 🟦 PATCH Request
  Future<Either<HelperResponse, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
    );

    return _handleApiResponse(response: response, fromJson: fromJson);
  }

  /// 📥 DOWNLOAD Request
  Future<Either<HelperResponse, String>> download(
    String urlPath,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    final response = await _dio.download(
      urlPath,
      savePath,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
    );

    return _handleApiResponse<String>(
      response: response,
      fromJson: (json) => savePath,
    );
  }

  /// 📤 UPLOAD Request
  Future<Either<HelperResponse, T>> upload<T>(
    String path, {
    required Map<String, dynamic> formData,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requireAuth = true,
    required T Function(dynamic json) fromJson,
  }) async {
    final response = await _dio.post(
      path,
      formData: formData,
      queryParameters: queryParameters,
      headers: headers,
      requireAuth: requireAuth,
      isFormData: true,
    );

    return _handleApiResponse(response: response, fromJson: fromJson);
  }
}



// class UserDataSourceImpl with ApiClient {
  
//   /// 🟪 EXAMPLE 1: GraphQL Query
//   Future<Either<HelperResponse, UserModel>> getUserProfileGraphQL(String userId) async {
//     const query = '''
//       query GetUser(\$id: ID!) {
//         user(id: \$id) {
//           id
//           name
//           email
//           profileImage
//           createdAt
//         }
//       }
//     ''';

//     return await graphQLQuery<UserModel>(
//       query,
//       variables: {'id': userId},
//       fromJson: (json) => UserModel.fromJson(json),
//       dataKey: 'user',
//     );
//   }

//   /// 🟪 EXAMPLE 2: GraphQL Mutation
//   Future<Either<HelperResponse, bool>> updateUserProfileGraphQL(UpdateUserModel model) async {
//     const mutation = '''
//       mutation UpdateUser(\$input: UpdateUserInput!) {
//         updateUser(input: \$input) {
//           success
//           message
//           user {
//             id
//             name
//             email
//           }
//         }
//       }
//     ''';

//     return await graphQLMutation<bool>(
//       mutation,
//       variables: {'input': model.toJson()},
//       fromJson: (json) => json['success'] ?? false,
//       dataKey: 'updateUser',
//     );
//   }

//   /// 🟩 EXAMPLE 3: REST POST
//   Future<Either<HelperResponse, UserModel>> login(LoginModel model) async {
//     return await post<UserModel>(
//       '/auth/login',
//       data: model.toJson(),
//       requireAuth: false,
//       fromJson: (json) => UserModel.fromJson(json),
//     );
//   }

//   /// 🟦 EXAMPLE 4: REST GET
//   Future<Either<HelperResponse, UserModel>> getUserProfileREST(String userId) async {
//     return await get<UserModel>(
//       '/users/$userId',
//       fromJson: (json) => UserModel.fromJson(json),
//     );
//   }

//   /// 🟦 EXAMPLE 5: REST GET List
//   Future<Either<HelperResponse, List<ProductModel>>> getProducts() async {
//     return await getList<ProductModel>(
//       '/products',
//       fromJson: (json) => ProductModel.fromJson(json),
//     );
//   }

//   /// 🟨 EXAMPLE 6: REST PUT
//   Future<Either<HelperResponse, UserModel>> updateProfile(UserModel model) async {
//     return await put<UserModel>(
//       '/users/${model.id}',
//       data: model.toJson(),
//       fromJson: (json) => UserModel.fromJson(json),
//     );
//   }

//   /// 🟥 EXAMPLE 7: REST DELETE
//   Future<Either<HelperResponse, bool>> deleteUser(String userId) async {
//     return await delete<bool>(
//       '/users/$userId',
//       fromJson: (json) => true, // إذا نجح الحذف نرجع true
//     );
//   }

//   /// 📤 EXAMPLE 8: UPLOAD File
//   Future<Either<HelperResponse, String>> uploadProfileImage(File image) async {
//     return await upload<String>(
//       '/upload/profile',
//       formData: {
//         'file': await MultipartFile.fromFile(image.path),
//         'type': 'profile_image',
//       },
//       fromJson: (json) => json['url'] as String,
//     );
//   }

//   /// 📥 EXAMPLE 9: DOWNLOAD File
//   Future<Either<HelperResponse, String>> downloadDocument(String fileUrl) async {
//     final savePath = '/storage/emulated/0/Download/document.pdf';
//     return await download(
//       fileUrl,
//       savePath,
//       requireAuth: true,
//     );
//   }

//   /// 🟦 EXAMPLE 10: REST PATCH
//   Future<Either<HelperResponse, UserModel>> partialUpdate(UserModel model) async {
//     return await patch<UserModel>(
//       '/users/${model.id}',
//       data: model.toJson(),
//       fromJson: (json) => UserModel.fromJson(json),
//     );
//   }
// }