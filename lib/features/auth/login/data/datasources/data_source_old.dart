/*
  هذا الملف يمثل النسخة "القديمة" من الـ DataSource قبل تطبيق معايير الـ Clean Architecture.
  تم الاحتفاظ به هنا لغرض التعلم والمقارنة.
  
  ⚠️ المشاكل المعمارية في هذا الكود:
  1. كسر مبدأ المسؤولة الوحيدة (Single Responsibility):
     الـ DataSource هنا لا يكتفي بجلب البيانات من الإنترنت فقط، بل يقوم بحفظها في الـ Preferences
     ويقوم بتحديث الـ Dio Headers. هذه المهام مكانها الـ Repository أو الـ AuthManager.
     
  2. التبعية الخفية (Hidden Dependencies):
     استخدام `DioServices.instance` و `preferences` مباشرة يجعل الكود مستحيل عمل Mock له في التست.
     
  3. المنطق المتداخل (Mixed Logic):
     دالة `completeLogin` تقوم بعمليتين (Login ثم GetData)؛ هذا المنطق مكانه الـ Repository 
     الذي ينسق بين دوال الـ DataSource البسيطة.
     
  4. وجود كود معلق (Commented Code): 
     يصعب قراءة الملف ويقلل من نظافته.
*/

/*
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

class LoginDataSourceImplOld with ApiClient {
  final GraphQLQueries queries = GraphQLQueries();
  final RecaptchaService _recaptchaService = RecaptchaService.instance;

  Future<Either<HelperResponse, LoginResponse>> login(LoginModel loginModel) async {
    // ... الكود القديم الذي كان يحفظ الداتا مباشرة في الـ DataSource ...
  }
}
*/
