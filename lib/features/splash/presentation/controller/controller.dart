import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../core/auth/auth_manager.dart';
import '../../../../core/routes/routes.dart';
import 'state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState.initial());

  Future<void> start() async {
    emit(const SplashState.loading());

    try {
      await Future.delayed(const Duration(seconds: 3));

      final bool isLoggedIn = AuthManager.isAuthenticated;
      final nextRoute = isLoggedIn ? NamedRoutes.i.layout : NamedRoutes.i.login;

      emit(SplashState.navigationReady(nextRoute: nextRoute));
    } catch (e) {
      emit(SplashState.error(e.toString()));
    }
  }
}
