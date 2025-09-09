import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:employee_management/controllers/base_api_controller.dart';
import 'package:employee_management/data/endpoints/endpoints.dart';
import 'package:employee_management/data/models/login_response.dart';
import 'package:employee_management/data/sharefPref/sharedpref.dart';
import 'package:employee_management/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends BaseApiController {
  var isSignedIn = false.obs;
  var loader = false.obs;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final SharedPref _sharedPref = SharedPref();

  RxString token = ''.obs;

  @override
  void onInit() {
    getToken();
    super.onInit();
  }

  Future<void> getToken() async {
    token.value = await _sharedPref.readString("authToken") ?? "";
    if (kDebugMode) print("Splash token: $token");
  }

  void handleAuthStateChanged(bool isLoggedIn) {
    if (isLoggedIn) {
      if (firebaseAuth.currentUser != null && token.value.isEmpty) {
        login(
          firebaseAuth.currentUser!.providerData.first.email.toString(),
          firebaseAuth.currentUser!.providerData.first.uid.toString(),
        ).then((_) => Get.offAllNamed(homepage, arguments: 0));
      } else if (firebaseAuth.currentUser != null && token.value.isNotEmpty) {
        Get.offAllNamed(homepage, arguments: 0);
      }
    } else {
      Get.offAllNamed(signinpage);
    }
  }

  /// New Google sign-in method using GoogleSignIn.instance and authenticate()
  Future<User?> loginWithGoogle() async {
    try {
      // Use the singleton instance
      final googleSignIn = GoogleSignIn.instance;

      // Trigger interactive sign-in
      final GoogleSignInAccount account = await googleSignIn.authenticate();

      if (!account.email.contains('misfit.tech')) {
        Get.snackbar(
          "Login Error",
          "Please login with your official mail address",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
        );
        await googleSignIn.disconnect();
        return null;
      }

      // Get authentication tokens
      final googleAuth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken, // new API returns idToken only
        idToken: googleAuth.idToken,
      );

      await firebaseAuth.signInWithCredential(credential);

      if (firebaseAuth.currentUser != null) {
        await login(
          firebaseAuth.currentUser!.providerData.first.email.toString(),
          firebaseAuth.currentUser!.providerData.first.uid.toString(),
        );
        Get.offAllNamed(homepage, arguments: 0);
      }

      return firebaseAuth.currentUser;
    } catch (e) {
      if (kDebugMode) print("Google sign-in error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _sharedPref.remove('authToken');
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.disconnect();
      await firebaseAuth.signOut();
    } catch (e) {
      if (kDebugMode) print("Logout error: $e");
    }
    Get.offAllNamed(signinpage);
  }

  Future<dynamic> login(String email, String googleId) async {
    try {
      final response = await getDio()!.post(
        EndPoints.loginPath,
        data: {'email': email, 'google_id': googleId},
      );

      final responseJson = json.decode(response.toString());
      if (kDebugMode) print('Response status: ${responseJson['status']}');

      if (response.statusCode == 201 && responseJson['status'] == 200) {
        final loginResponse = LoginResponse.fromJson(responseJson);
        await _sharedPref.saveString("authToken", loginResponse.data.token);
        await _sharedPref.saveString('email', loginResponse.data.email);
        await _sharedPref.saveString('userName', loginResponse.data.name);
        return loginResponse;
      } else {
        return false;
      }
    } on DioException catch (e) {
      final responseJson =
          e.response != null ? json.decode(e.response.toString()) : {};
      if (kDebugMode) {
        print('Error status: ${responseJson['status'] ?? 'unknown'}');
        print(e.response?.data ?? e.message);
      }
      return null;
    }
  }
}
