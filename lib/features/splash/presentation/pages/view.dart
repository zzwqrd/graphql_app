import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/routes/app_routes_fun.dart';
import '../../../../core/utils/extensions_app/color/color_extensions.dart';
import '../../../../core/utils/extensions_app/extensions_init.dart'
    show AlignmentExtensions;
import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final cubit = sl<SplashCubit>();
  @override
  void initState() {
    super.initState();
    cubit.start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      bloc: cubit,
      listenWhen: (previous, current) => current.status == SplashStatus.ready,
      listener: (context, state) {
        if (state.status == SplashStatus.ready) {
          log("splash ready -> ${state.nextRoute}");
          final next = state.nextRoute ?? NamedRoutes.i.login;
          replacement(next);
        }
      },
      child: Scaffold(
        backgroundColor: context.primaryColor,
        body: MyAssets.icons.iconAppG.image().center,
      ),
    );
  }
}
