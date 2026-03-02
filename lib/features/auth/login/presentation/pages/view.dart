import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonWidget/app_field.dart';
import '../../../../../commonWidget/button_animation/LoadingButton.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../../di/service_locator.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../manager/controller.dart';
import '../manager/state.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = sl<LoginCubit>();
    return Scaffold(
      body: Form(
        key: bloc.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyAssets.icons.iconAppG.image(width: 150.w).pb8,

            // "welcome back".h3.center.pb3,
            AppCustomForm.email(
              hintText: tr(LocaleKeys.auth_email_placeholder),
              controller: TextEditingController(text: bloc.loginModel.email),
            ).pb3,

            AppCustomForm.password(
              hintText: tr(LocaleKeys.auth_password_placeholder),
              controller: TextEditingController(text: bloc.loginModel.password),
            ).pb6,

            BlocBuilder<LoginCubit, LoginState>(
              bloc: bloc,
              builder: (context, state) {
                return LoadingButton(
                  isAnimating: state.requestState.isLoading,
                  title: tr(LocaleKeys.auth_title),
                  onTap: () {
                    bloc.login();
                  },
                );
              },
            ).pb6,
            "الدخول كا زائر".h5.center.inkWell(
              onTap: () {
                pushAndRemoveUntil(NamedRoutes.i.layout);
              },
            ),
          ],
        ).center.pb8.px4,
      ),
    );
  }
}
