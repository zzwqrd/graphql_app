import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes_fun.dart';
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
  late final SplashCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = sl<SplashCubit>();
    _cubit.start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      bloc: _cubit,
      listenWhen: (previous, current) =>
          current.status == SplashStatus.navigationReady,
      listener: (context, state) {
        if (state.status == SplashStatus.navigationReady) {
          // pushAndRemoveUntil(state.nextRoute!);
        }
      },
      child: SizedBox.expand(
        child: MyAssets.icons.splash.image(fit: BoxFit.cover),
      ),
    );
  }
}
