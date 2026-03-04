import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../commonWidget/app_btn.dart';
import '../../../../../commonWidget/app_field.dart';
import '../../../../../core/utils/extensions_app/extensions_init.dart';
import '../../../../../gen/locale_keys.g.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../manager/form_manager.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _manager = LoginFormManager();

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginRulesBloc>().state;
    final isLoading = state.requestState.isLoading;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      child: Form(
        key: _manager.formKey,
        child: Column(
          children: [
            AppCustomForm.email(
              controller: _manager.emailController,
              hintText: tr(LocaleKeys.auth_email_placeholder),
            ).pb4,
            AppCustomForm.password(
              controller: _manager.passwordController,
              hintText: tr(LocaleKeys.auth_password_placeholder),
            ).pb6,
            EnhancedButton(
              label: 'Login',
              isLoading: isLoading,
              onPressed: () => _onSubmit(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    context.read<LoginRulesBloc>().add(
      LoginRulesSubmitted(
        email: _manager.emailController.text,
        password: _manager.passwordController.text,
      ),
    );
  }
}
