import 'package:dartz/dartz.dart';
import '../../../../../core/services/dio_services.dart';

import '../../../../../app_initialize.dart' show preferences;
import '../../../../../core/services/api_client.dart';
import '../../../../../core/services/helper_respons.dart';
import '../../../../../core/services/recaptcha_service.dart';
import '../../../../../core/services/shared_pref_helper.dart';
import '../../../../../core/utils/enums.dart';
import '../models/graphql_queries.dart';
import '../models/login_model.dart';

class LoginDataSourceImpl with ApiClient {
  final GraphQLQueries queries = GraphQLQueries();
  final RecaptchaService _recaptchaService = RecaptchaService.instance;
  Future<Either<HelperResponse, LoginResponse>> login(
    LoginModel loginModel,
  ) async {
    try {
      // ⚠️ TEMPORARY WORKAROUND: Skip ReCaptcha entirely
      // The g_recaptcha_v3 package only works on Web, not on mobile
      // Backend should disable ReCaptcha requirement or use mobile-compatible solution

      final variables = {
        'email': loginModel.email,
        'password': loginModel.password,
      };

      // 🚀 Execute GraphQL Mutation without ReCaptcha
      final result = await graphQLMutation(
        queries.loginMutation,
        variables: variables,
        requireAuth: false,
        dataKey: 'generateCustomerToken',
        fromJson: (json) => LoginResponse.fromJson(json),
      );

      // ✅ Save token on success
      return await result.fold((error) => Left(error), (loginResponse) async {
        await preferences.setString('auth_token', loginResponse.token);

        // 🗑️ Clear Guest Cart ID to ensure we fetch user's cart
        await preferences.remove('cartId');

        // 🔄 Update Dio Headers immediately
        DioServices.instance.updateAuthToken(loginResponse.token);

        return Right(loginResponse);
      });
    } catch (e) {
      return Left(
        HelperResponse(
          message: e.toString(),
          state: ResponseState.badRequest,
          success: false,
        ),
      );
    }
  }

  // Future<Either<HelperResponse, LoginResponse>> login(
  //   LoginModel loginModel,
  // ) async {
  //   // 🔐 الحصول على ReCaptcha Token
  //   final recaptchaToken = await _recaptchaService.getLoginToken();
  //   print('🔐 ReCaptcha Token: $recaptchaToken');

  //   // إرسال الـ token عبر custom header
  //   final headers = {'X-ReCaptcha': recaptchaToken};
  //   final variables = {
  //     'email': loginModel.email,
  //     'password': loginModel.password,
  //   };

  //   final result = await graphQLMutation(
  //     queries.loginMutation,
  //     variables: variables,
  //     headers: headers,
  //     requireAuth: false,

  //     fromJson: (json) {
  //       return LoginResponse.fromJson(json);
  //     },
  //     dataKey: 'generateCustomerToken',
  //   );

  //   return result.fold((error) => Left(error), (loginResponse) async {
  //     await preferences.setString('auth_token', loginResponse.token);

  //     return Right(loginResponse);
  //   });
  // }

  Future<Either<HelperResponse, Customer>> getCustomerData({
    String? token,
  }) async {
    final result = await graphQLQuery<Customer>(
      queries.customerQuery,
      headers: {'Authorization': 'Bearer $token'},
      requireAuth: true,

      fromJson: (json) {
        return Customer.fromJson(json);
      },
      dataKey: 'customer',
    );

    return result.fold((error) => Left(error), (customer) => Right(customer));
  }

  Future<Either<HelperResponse, LoginData>> completeLogin(
    LoginModel loginModel,
  ) async {
    final loginResult = await login(loginModel);

    return loginResult.fold((error) => Left(error), (loginResponse) async {
      final customerResult = await getCustomerData(token: loginResponse.token);
      return customerResult.fold((error) => Left(error), (customer) async {
        await setCustomer(customer);
        return Right(
          LoginData(
            loginResponse: loginResponse,
            token: preferences.getString('auth_token'),
            customer: customer,
          ),
        );
      });
    });
  }

  Future<void> setCustomer(Customer customer) async {
    SharedPrefHelper().setCustomer(customer);
  }
}
