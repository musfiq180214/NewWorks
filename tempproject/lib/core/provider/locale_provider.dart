import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// StateNotifier to manage current app locale
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')); // default English

  void toggleLocale() {
    if (state.languageCode == 'en') {
      state = const Locale('bn'); // switch to Bengali
    } else {
      state = const Locale('en'); // switch back to English
    }
  }
}

// Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
