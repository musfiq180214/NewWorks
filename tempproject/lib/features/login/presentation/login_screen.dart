import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempproject/core/provider/is_logged_in_provider.dart';
import 'package:tempproject/core/provider/user_profile_provider.dart';
import 'package:tempproject/core/routing/app_router.dart';
import 'package:tempproject/data/user_repository.dart';
import 'package:tempproject/features/login/domain/login_model.dart';
import '../provider/login_provider.dart';
import '../../../core/provider/locale_provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../generated/l10n.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);

    // =========================
    // Updated ref.listen block
    // =========================
    ref.listen<LoginState>(loginProvider, (previous, next) async {
      if (next.status == LoginStatus.success) {
        // Save login state persistently
        await ref.read(isLoggedInProvider.notifier).login(_emailController.text);

        final userRepo = UserRepository();
        final user = userRepo.getUserByEmail(_emailController.text);

        if (user != null)
        {
          ref.read(userProfileProvider.notifier).setUser(user);
        }
        // Replace entire stack to prevent back navigation
        AppRouter.pushReplacementAll(context, AppRouter.apartment);
      }
      if (previous?.status == LoginStatus.loading &&
          next.status == LoginStatus.failure &&
          (next.errorMessage?.isNotEmpty ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
      }
    });

    final theme = Theme.of(context);
    final t = S.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(t.login),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
            tooltip: 'Change language',
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.1, 0.6, 1.0],
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.25),
              theme.colorScheme.primaryContainer.withValues(alpha: 0.30),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 6),
                        Icon(Icons.apartment,
                            size: 56, color: theme.colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(
                          t.login,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Welcome back! Please sign in to continue.",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: t.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            errorText: loginState.emailError,
                          ),
                          onChanged: (_) => ref
                              .read(loginProvider.notifier)
                              .clearEmailError(),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        _PasswordField(
                          controller: _passwordController,
                          label: t.password,
                          errorText: loginState.passwordError,
                          onChanged: (_) => ref
                              .read(loginProvider.notifier)
                              .clearPasswordError(),
                        ),

                        const SizedBox(height: 20),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: (loginState.status ==
                                    LoginStatus.loading)
                                ? null
                                : () {
                                    ref.read(loginProvider.notifier).login(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                  },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: (loginState.status == LoginStatus.loading)
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(t.login),
                          ),
                        ),

                        const SizedBox(height: 8),

                        if (loginState.status == LoginStatus.failure &&
                            (loginState.errorMessage?.isNotEmpty ?? false))
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              loginState.errorMessage!,
                              style: TextStyle(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        const SizedBox(height: 4),

                        TextButton(
                          onPressed: () {
                            AppRouter.pushReplacementAll(context, AppRouter.register);
                            },
                            child: const Text("Don't have an account? Register"),
                            )



                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const _PasswordField({
    required this.controller,
    required this.label,
    this.errorText,
    this.onChanged,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          tooltip: _obscure ? 'Show password' : 'Hide password',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        errorText: widget.errorText,
      ),
      onChanged: widget.onChanged,
      onSubmitted: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
