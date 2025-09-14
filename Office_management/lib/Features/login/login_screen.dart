import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:office_management/Features/dashboard/dashboard_screen.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

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
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (authState.error != null)
              Text(authState.error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: authState.loading
                  ? null
                  : () async {
                      await authCtrl.login(
                        _emailCtrl.text.trim(),
                        _passCtrl.text.trim(),
                      );

                      // Always guard before using State.context
                      if (!mounted) return;

                      final newState = ref.read(authControllerProvider);
                      if (newState.user != null) {
                        Navigator.of(this.context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const DashboardScreen(),
                          ),
                        );
                      }
                    },
              child: authState.loading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
