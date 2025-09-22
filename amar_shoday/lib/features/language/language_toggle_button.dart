// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';

// class LanguageToggleButton extends StatelessWidget {
//   const LanguageToggleButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isEnglish = context.locale.languageCode == 'en';

//     return IconButton(
//       icon: Icon(isEnglish ? Icons.language : Icons.translate),
//       onPressed: () {
//         final newLocale = isEnglish ? const Locale('bn') : const Locale('en');
//         context.setLocale(newLocale);

//         // Force rebuild widgets using .tr()
//         (context as Element).markNeedsBuild();
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale == const Locale('en', 'US');

    return IconButton(
      icon: Icon(isEnglish ? Icons.language : Icons.translate),
      onPressed: () {
        final newLocale =
            isEnglish ? const Locale('bn', 'BD') : const Locale('en', 'US');
        context.setLocale(newLocale);
      },
    );
  }
}
