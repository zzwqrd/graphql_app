import 'package:flutter/foundation.dart';
import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

/// 🔐 RecaptchaService
/// - يولّد reCAPTCHA v3 token فقط
/// - لا يحتوي على Secret Key
/// - التحقق يتم في السيرفر فقط
class RecaptchaService {
  RecaptchaService._internal();

  static final RecaptchaService instance = RecaptchaService._internal();

  /// 🔑 Site Key (من Google reCAPTCHA)
  static const String _siteKey = '6LdkVywsAAAAALkDGIUPBnhAhXM-6VxgBlOF01PN';

  bool _isInitialized = false;

  /// تهيئة reCAPTCHA (مرة واحدة فقط)
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await GRecaptchaV3.ready(_siteKey);
      _isInitialized = true;
      debugPrint('✅ ReCaptcha initialized successfully');
    } catch (e) {
      _isInitialized = false;
      debugPrint('❌ ReCaptcha init error: $e');
    }
  }

  /// 🔐 Token خاص بعملية Login
  Future<String?> getLoginToken() async {
    return _execute(action: 'login');
  }

  /// 🔁 تنفيذ Action
  Future<String?> _execute({required String action}) async {
    try {
      if (!_isInitialized) {
        await init();
      }

      final token = await GRecaptchaV3.execute(action);

      if (token == null) {
        debugPrint('⚠️ Empty ReCaptcha token for action: $action');
        return null;
      }

      debugPrint('🔐 ReCaptcha token generated [$action]');
      return token;
    } catch (e) {
      debugPrint('❌ ReCaptcha execute error [$action]: $e');
      return null;
    }
  }
}

// import 'package:flutter/foundation.dart';
// import 'package:g_recaptcha_v3/g_recaptcha_v3.dart';

// /// 🔐 RecaptchaService
// /// - يولّد reCAPTCHA v3 token فقط
// /// - لا يحتوي على Secret Key
// /// - التحقق يتم في السيرفر فقط
// class RecaptchaService {
//   RecaptchaService._internal();

//   static final RecaptchaService instance = RecaptchaService._internal();

//   /// 🔑 Site Key فقط (مسموح في الكلاينت)
//   static const String _siteKey = 'PUT_YOUR_SITE_KEY_HERE';

//   bool _isInitialized = false;

//   /// يجب استدعاؤها مرة واحدة عند تشغيل التطبيق
//   Future<void> init() async {
//     if (_isInitialized) return;

//     try {
//       await GRecaptchaV3.ready(_siteKey);
//       _isInitialized = true;
//       debugPrint('✅ ReCaptcha initialized');
//     } catch (e) {
//       _isInitialized = false;
//       debugPrint('❌ ReCaptcha init error: $e');
//     }
//   }

//   /// Token خاص بعملية Login
//   Future<String?> getLoginToken() async {
//     return _execute(action: 'login');
//   }

//   /// Token لأي Action
//   Future<String?> _execute({required String action}) async {
//     try {
//       if (!_isInitialized) {
//         await init();
//       }

//       final token = await GRecaptchaV3.execute(action);

//       if (token == null) {
//         debugPrint('⚠️ Empty ReCaptcha token [$action]');
//         return null;
//       }

//       debugPrint('🔐 ReCaptcha token generated [$action]');
//       return token;
//     } catch (e) {
//       debugPrint('❌ ReCaptcha execute error [$action]: $e');
//       return null;
//     }
//   }
// }
