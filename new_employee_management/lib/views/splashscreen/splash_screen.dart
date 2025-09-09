import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:employee_management/controllers/loginController.dart';
import 'package:employee_management/data/sharefPref/sharedpref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LoginController _loginController = Get.put(LoginController());
  final SharedPref _sharedPref = SharedPref();
  String token = '';

  Future<void> getToken() async {
    final auth = await _sharedPref.readString("authToken") ?? "";
    setState(() {
      token = auth;
      if (kDebugMode) print("Splash token: $token");
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();

    Timer(const Duration(seconds: 2), () async {
      // Use the singleton instance of GoogleSignIn
      final googleSignIn = GoogleSignIn.instance;

      // Listen for auth state changes
      ever(
        _loginController.isSignedIn,
        _loginController.handleAuthStateChanged,
      );

      // Update signed-in state
      _loginController.isSignedIn.value =
          _loginController.firebaseAuth.currentUser != null && token.isNotEmpty;

      // Listen to Firebase auth changes
      _loginController.firebaseAuth.authStateChanges().listen((user) {
        _loginController.isSignedIn.value = user != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SvgPicture.asset(
            "assets/images/splash_screen.svg",
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
