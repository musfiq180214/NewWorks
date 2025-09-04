import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifierProvider that holds ThemeMode
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  return ThemeNotifier();
});

// StateNotifier class to toggle theme
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }
}
