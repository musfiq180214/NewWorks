import 'package:flutter/material.dart';

// Define app colors and gradients
const Color kPrimaryColor = Color(0xFF2196F3);
const Color kSecondaryColor = Color(0xFF64B5F6);

final LinearGradient kAppGradient = LinearGradient(
  colors: [kPrimaryColor, kSecondaryColor],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
