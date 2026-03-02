import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routes/app_routes_fun.dart';
import 'core/utils/app_themes.dart';
import 'core/utils/phoneix.dart';
import 'core/utils/unfucs.dart';
import 'di/service_locator.dart';
import 'features/cart/presentation/controller/controller.dart';
import 'features/wishlist/presentation/controller/controller.dart';

import 'core/routes/go_router_config.dart'; // Import for goRouter configuration

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
            BlocProvider<WishlistCubit>.value(value: sl<WishlistCubit>()),
          ],
          child: MaterialApp.router(
            title: 'Test',
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeDataExtension.lightTheme,
            scrollBehavior: MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
                PointerDeviceKind.stylus,
                PointerDeviceKind.unknown,
              },
            ),
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Scaffold(
                  appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
                );
              };
              return Phoenix(
                child: MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: TextScaler.linear(1.sp.clamp(1.0, 1.5)),
                    accessibleNavigation: mediaQuery.accessibleNavigation,
                    boldText: mediaQuery.boldText,
                    highContrast: mediaQuery.highContrast,
                    padding: mediaQuery.padding,
                    viewInsets: mediaQuery.viewInsets,
                    devicePixelRatio: mediaQuery.devicePixelRatio,
                    alwaysUse24HourFormat: true,
                    platformBrightness: Theme.of(context).brightness,
                    disableAnimations: mediaQuery.disableAnimations,
                    gestureSettings: const DeviceGestureSettings(
                      touchSlop: 10.0,
                    ),
                  ),
                  child: Unfocus(child: child ?? const SizedBox.shrink()),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
