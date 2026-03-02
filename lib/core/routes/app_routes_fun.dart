import 'package:go_router/go_router.dart';

import '../utils/flash_helper.dart';
// We need to keep this key to access context for GoRouter.of() if direct context isn't available in helpers
import 'go_router_config.dart';
export 'go_router_config.dart'; // Export to access navigatorKey

Future<dynamic> push(String named, {Object? arguments}) async {
  return GoRouter.of(
    navigatorKey.currentContext!,
  ).push(named, extra: arguments);
}

Future<dynamic> replacement(String named, {Object? arguments}) async {
  return GoRouter.of(
    navigatorKey.currentContext!,
  ).pushReplacement(named, extra: arguments);
}

Future<dynamic> pushAndRemoveUntil(String child, {Object? arguments}) async {
  GoRouter.of(navigatorKey.currentContext!).go(child, extra: arguments);
}

enum MessageType { success, failed, warning }

void showMessage(String msg, {MessageType messageType = MessageType.failed}) {
  if (msg.isNotEmpty) {
    FlashHelper.showToast(msg, duration: 3, type: MessageTypeTost.success);
  }
}
