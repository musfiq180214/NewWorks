import 'package:flutter/material.dart';
import 'package:fulldioproject/features/login/provider/login_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();

  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'GitHub Username'),
          ),
          const SizedBox(height: 24),
          loginProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    await loginProvider.login(usernameController.text.trim());
                    if (loginProvider.isAuthenticated) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/github',
                        arguments: usernameController.text.trim(),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
          if (loginProvider.error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                loginProvider.error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
