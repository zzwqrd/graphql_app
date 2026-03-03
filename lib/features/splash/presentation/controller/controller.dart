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

      final bool isLoggedIn = preferences.getString("auth_token") != null;
      final nextRoute = isLoggedIn ? NamedRoutes.i.layout : NamedRoutes.i.login;

      emit(SplashState.navigationReady(nextRoute: nextRoute));
    } catch (e) {
      emit(SplashState.error(e.toString()));
    }
  }
}
