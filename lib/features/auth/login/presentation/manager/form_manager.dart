import 'package:flutter/material.dart';

class LoginFormManager {
  final emailController = TextEditingController(text: 'ahmed@alicom.com');
  final passwordController = TextEditingController(text: 'Password123!');
  final formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
