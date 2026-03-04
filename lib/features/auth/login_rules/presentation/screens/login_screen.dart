import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/routes/app_routes_fun.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/flash_helper.dart';
import '../../../../../di/service_locator.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_state.dart';
import '../widgets/login_form.dart';

class LoginRulesScreen extends StatelessWidget {
  const LoginRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginRulesBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login Rules')),
        body: BlocListener<LoginRulesBloc, LoginRulesState>(
          listener: _onStateChanged,
          child: const LoginForm(),
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, LoginRulesState state) {
    if (state.requestState.isDone) {
      FlashHelper.successToast(state.loginData?.customer?.email ?? '');
      pushAndRemoveUntil(NamedRoutes.i.layout);
    } else if (state.requestState.isError) {
      FlashHelper.failToast(state.errorMessage ?? 'حصل غلط');
    }
  }
}
