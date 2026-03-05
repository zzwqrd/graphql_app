import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes_fun.dart';
import '../../../../di/service_locator.dart';
import '../../../../gen/assets.gen.dart';
import '../controller/controller.dart';
import '../controller/state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SplashCubit>()..start(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (_, current) => current.status.isNavigationReady,
        listener: (context, state) {
          pushAndRemoveUntil(state.nextRoute!);
        },
        child: SizedBox.expand(
          child: MyAssets.icons.splash.image(fit: BoxFit.cover),
        ),
      ),
    );
  }
}
