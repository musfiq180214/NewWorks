import 'package:flutter/material.dart';
import 'package:fulldioproject/features/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(child: SingleChildScrollView(child: LoginForm())),
    );
  }
}
