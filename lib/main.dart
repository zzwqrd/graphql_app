import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'app_initialize.dart';

void main() async {
  await AppInitializer.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/lang',
      startLocale: const Locale('ar'),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}
