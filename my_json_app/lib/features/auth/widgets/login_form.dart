import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../../home/presentation/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  Future<void> _handleLogin(BuildContext context, AuthProvider authProvider) async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validation
    if (email.isEmpty) {
      setState(() => emailError = "Email cannot be empty");
      return;
    }
    if (password.isEmpty) {
      setState(() => passwordError = "Password cannot be empty");
      return;
    }

    // Try login
    final errorMessage = await authProvider.login(email, password);

    if (errorMessage == null) {
      // Success
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      // Show the error message
      if (errorMessage.contains("Email")) {
        setState(() => emailError = errorMessage);
      } else {
        setState(() => passwordError = errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: emailError,
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: passwordError,
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        authProvider.isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => _handleLogin(context, authProvider),
                child: const Text("Login"),
              ),
      ],
    );
  }
}
