import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sellapartment/features/login/domain/login_model.dart';
import '../provider/login_provider.dart';
import '../../../core/provider/locale_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../generated/l10n.dart';
import '../../apartment/presentation/apartment_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next.status == LoginStatus.success) {
        // Navigate to ApartmentScreen after successful login
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const ApartmentScreen()));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: S.of(context).email,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: S.of(context).password,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (loginState.status == LoginStatus.loading)
              const CircularProgressIndicator(),
            if (loginState.status == LoginStatus.failure)
              Text(
                loginState.errorMessage ?? "",
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginState.status == LoginStatus.loading
                  ? null
                  : () {
                      ref
                          .read(loginProvider.notifier)
                          .login(_emailController.text, _passwordController.text);
                    },
              child: Text(S.of(context).login),
            ),
          ],
        ),
      ),
    );
  }
}
