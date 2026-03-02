import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:croppy/croppy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/get_platform.dart';
import 'core/services/bloc_observer.dart';
import 'core/services/recaptcha_service.dart';
import 'core/utils/loger.dart';
import 'di/service_locator.dart';

/// Global logger instance
final logger = LoggerDebug(headColor: LogColors.green);
late SharedPreferences preferences;

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    ServicesLocator().initGitIt();
    // Set up global error handling
    _setupErrorHandling();

    // Initialize core services
    await _initCoreServices();

    // Initialize UI configurations
    await _initUIServices();
  }

  static void _setupErrorHandling() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError(details.exception, details.stack, 'Flutter Error');
    };

    // Catch asynchronous errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError(error, stack, 'Async Error');
      return true;
    };

    // Global Bloc observer
    Bloc.observer = AppBlocObserver();
  }

  static Future<void> _initCoreServices() async {
    _logStartupMessage();

    HttpOverrides.global = MyHttpOverrides();
    preferences = await SharedPreferences.getInstance();

    await _initPlatform();

    // 🔐 Initialize ReCaptcha
    await RecaptchaService.instance.init();
  }

  static Future<void> _initUIServices() async {
    await ScreenUtil.ensureScreenSize();
    await _preLaunchConfigurations();
  }

  static Future<void> _initPlatform() async {
    pt = PlatformInfo.getCurrentPlatformType();
    if (pt.isNotWeb) {
      croppyForceUseCassowaryDartImpl = true;
    }
  }

  static Future<void> _preLaunchConfigurations() async {
    await Future.wait([
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]),
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky),
      Future.microtask(() {
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
        );
      }),
    ]);
  }

  static void handleUncaughtError(Object error, StackTrace stackTrace) {
    _logError(error, stackTrace, 'Uncaught Error');
  }

  static void _logError(Object error, StackTrace? stackTrace, String context) {
    logger.red('❌ $context: $error');
    if (stackTrace != null) {
      logger.yellow('📜 Stack trace:\n$stackTrace');
    }
    // Here you could add reporting to Crashlytics or Sentry
  }

  static void _logStartupMessage() {
    logger.green('Application initialization started...');
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
