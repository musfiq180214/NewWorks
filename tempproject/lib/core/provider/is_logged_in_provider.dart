// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // Keeps track if user is logged in globally
// final isLoggedInProvider = StateProvider<bool>((ref) => false);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to manage persistent login
final isLoggedInProvider =
    StateNotifierProvider<IsLoggedInNotifier, bool>((ref) {
  return IsLoggedInNotifier();
});

class IsLoggedInNotifier extends StateNotifier<bool> {
  static const _key = 'is_logged_in';

  IsLoggedInNotifier() : super(false) {
    _loadFromPrefs();
  }

  // Load login state from SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  // Set login state and persist
  Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, email);
    state = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    state = false;
  }

  Future<String?> getLoggedInEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }
}
