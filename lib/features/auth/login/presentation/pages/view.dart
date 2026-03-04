import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../commonWidget/app_field.dart';
import '../../../../../commonWidget/button_animation/LoadingButton.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../../core/utils/flash_helper.dart';
import '../../../../../di/service_locator.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../manager/form_manager.dart';
import '../manager_bloc/controller.dart';
import '../manager_bloc/event.dart';
import '../manager_bloc/state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formManager = LoginFormManager();
  late final LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<LoginBloc>();
  }

  @override
  void dispose() {
    _formManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginStateBloc>(
        bloc: _bloc,
        listener: (context, state) {
          if (state.requestState == RequestState.done) {
            pushAndRemoveUntil(NamedRoutes.i.layout);
          } else if (state.requestState == RequestState.error) {
            FlashHelper.showToast(state.errorMessage ?? "");
          }
        },
        child: Form(
          key: _formManager.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyAssets.icons.iconAppG.image(width: 150.w).pb8,
              AppCustomForm.email(
                hintText: tr(LocaleKeys.auth_email_placeholder),
                controller: _formManager.emailController,
              ).pb3,
              AppCustomForm.password(
                hintText: tr(LocaleKeys.auth_password_placeholder),
                controller: _formManager.passwordController,
              ).pb6,
              BlocBuilder<LoginBloc, LoginStateBloc>(
                bloc: _bloc,
                builder: (context, state) {
                  return LoadingButton(
                    isAnimating: state.requestState.isLoading,
                    title: tr(LocaleKeys.auth_title),
                    onTap: () {
                      if (_formManager.formKey.currentState!.validate()) {
                        _bloc.add(
                          LoginSubmitted(
                            email: _formManager.emailController.text,
                            password: _formManager.passwordController.text,
                          ),
                        );
                      }
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
      ),
    );
  }
}
