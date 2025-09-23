import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageNotifierProvider =
    StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en', 'US'));

  void toggleLanguage() {
    if (state.languageCode == 'en') {
      state = const Locale('bn', 'BD');
    } else {
      state = const Locale('en', 'US');
    }
  }
}
