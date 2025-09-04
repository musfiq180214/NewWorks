import 'package:flutter/material.dart';
import 'package:fulldioproject/features/login/provider/login_provider.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  String? _usernameError;

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
            decoration: InputDecoration(
              labelText: 'GitHub Username',
              errorText: _usernameError, // <-- Show local validation error
            ),
          ),
          const SizedBox(height: 24),
          loginProvider.isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    final username = usernameController.text.trim();

                    if (username.isEmpty) {
                      setState(() {
                        _usernameError = "Must enter a username";
                      });
                      return;
                    } else {
                      setState(() {
                        _usernameError = null;
                      });
                    }

                    await loginProvider.login(username);
                    if (loginProvider.isAuthenticated) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/github',
                        arguments: username,
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
