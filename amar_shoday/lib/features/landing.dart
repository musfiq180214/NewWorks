import 'package:amar_shoday/features/language/language_toggle_button.dart';
import 'package:amar_shoday/features/theme/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("landing_title".tr()),
        actions: const [ThemeToggleButton(), LanguageToggleButton()],
      ),
      body: Center(
        child: Text(
          "landing_message".tr(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
