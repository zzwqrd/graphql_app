import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../app_initialize.dart';
import '../../../../core/routes/routes.dart';
import 'state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> start() async {
    emit(const SplashState.loading());

    try {
      await Future.delayed(const Duration(seconds: 3));

      final nextRoute = await _determineNextRoute();

      emit(SplashState.ready(nextRoute: nextRoute));
    } catch (e) {
      emit(SplashState.error(e.toString()));
    }
  }

  Future<String> _determineNextRoute() async {
    if (preferences.getString("auth_token") != null) {
      return NamedRoutes.i.layout;
    } else {
      return NamedRoutes.i.login;
    }
  }
}
