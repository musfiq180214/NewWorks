import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoginState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Login Example',
      home: const AuthWrapper(),
    );
  }
}

// Step 2: AuthWrapper switches between Login and Home based on login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (context, loginState, _) {
        if (loginState.isLoggedIn) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

// Step 1: LoginState ChangeNotifier
class LoginState extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  // Fixed credentials
  final String correctEmail = 'musfiq677@gmail.com';
  final String correctPassword = '1210900445';

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void login(String email, String password) {
    if (email == correctEmail && password == correctPassword) {
      _isLoggedIn = true;
      _errorMessage = null;
    } else {
      _errorMessage = 'Invalid email or password';
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }
}





// Step 3: Login Screen UI
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Call login on provider
    Provider.of<LoginState>(context, listen: false).login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Consumer<LoginState>(
          builder: (context, loginState, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (loginState.errorMessage != null) ...[
                  Text(
                    loginState.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                ],
                ElevatedButton(
                  onPressed: () => _submitLogin(context),
                  child: const Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Step 4: Home Screen UI
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<LoginState>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome! You are logged in.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
