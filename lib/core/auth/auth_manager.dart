import 'package:flutter/foundation.dart';
import '../../app_initialize.dart';

/// 🔐 Central Authentication Manager
///
/// Singleton class for managing authentication state across the app.
/// Uses SharedPreferences for persistent storage.
class AuthManager {
  AuthManager._();
  static final AuthManager instance = AuthManager._();

  /// Check if user is authenticated
  static bool get isAuthenticated =>
      preferences.getString('auth_token') != null &&
      preferences.getString('auth_token')!.isNotEmpty;

  /// Check if user is guest
  static bool get isGuest => !isAuthenticated;

  /// Get auth token
  static String? get token => preferences.getString('auth_token');

  /// Get user email
  static String? get userEmail => preferences.getString('user_email');

  /// Get user name
  static String? get userName => preferences.getString('user_name');

  /// Get customer ID
  static String? get customerId => preferences.getString('customer_id');

  /// Logout and clear all auth data
  static Future<void> logout() async {
    await preferences.remove('auth_token');
    await preferences.remove('user_email');
    await preferences.remove('user_name');
    await preferences.remove('customer_id');
    debugPrint('🚪 User logged out');
  }

  /// Save auth data after login
  static Future<void> saveAuthData({
    required String token,
    String? email,
    String? name,
    String? customerId,
  }) async {
    await preferences.setString('auth_token', token);
    if (email != null) await preferences.setString('user_email', email);
    if (name != null) await preferences.setString('user_name', name);
    if (customerId != null) {
      await preferences.setString('customer_id', customerId);
    }
    debugPrint('✅ Auth data saved');
  }
}
