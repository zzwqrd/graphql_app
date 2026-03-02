import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/auth/auth_manager.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/flash_helper.dart';
import '../../data/models/login_model.dart';
import '../../domain/usecases/login_usecase.dart';
import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  final LoginUsecase _loginUseCase = LoginUseCaseImpl();
  final formKey = GlobalKey<FormState>();

  LoginModel loginModel = LoginModel(
    email: "ahmed@alicom.com".trim(),
    password: "Password123!".trim(),
  );
  LoginData loginData = LoginData();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState?.save();

    emit(state.copyWith(requestState: RequestState.loading));

    final result = await _loginUseCase.call(loginModel);

    result.fold(
      (l) {
        FlashHelper.showToast(l.message);
        emit(state.copyWith(requestState: RequestState.error));
      },
      (r) async {
        loginData = r;

        // 🔐 Save auth data using AuthManager
        await AuthManager.saveAuthData(
          token: r.token!,
          email: loginModel.email,
          name: r.customer?.firstname,
          customerId: r.customer?.id?.toString(),
        );

        await push(NamedRoutes.i.layout);
        FlashHelper.showToast(
          'تم تسجيل الدخول بنجاح',
          type: MessageTypeTost.success,
        );
        emit(state.copyWith(requestState: RequestState.done));
      },
    );
  }
}
