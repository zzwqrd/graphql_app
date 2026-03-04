import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:graphql_app/core/routes/go_router_config.dart';

extension LanguageExtensions on BuildContext {
  /// Checks if the current locale is Arabic
  bool get isArabic => locale.languageCode == 'ar';

  /// Returns a value based on the current language
  T translated<T>({required T ar, required T en}) {
    return isArabic ? ar : en;
  }
}

/// Global helper to check if the current locale is Arabic (useful in Models)
bool get isAr => navigatorKey.currentContext?.locale.languageCode == 'ar';

/// Global helper to get a translated value (useful in Models)
T trValue<T>({required T ar, required T en}) => isAr ? ar : en;
