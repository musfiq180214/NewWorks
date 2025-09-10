import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import 'dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final authCtrl = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            if (authState.error != null)
              Text(authState.error!, style: TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: authState.loading
                  ? null
                  : () async {
                      await authCtrl.login(
                        _emailCtrl.text.trim(),
                        _passCtrl.text.trim(),
                      );
                      final newState = ref.read(authControllerProvider);
                      if (newState.user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => DashboardScreen()),
                        );
                      }
                    },
              child: authState.loading
                  ? CircularProgressIndicator()
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
