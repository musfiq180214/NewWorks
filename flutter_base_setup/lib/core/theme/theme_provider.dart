import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

// It is a riverpod provider that holds a priece of state: ThemeMode (light, dark, or system).

