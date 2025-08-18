import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/core/theme/colors.dart';
import 'package:base_setup/core/utils/sizes.dart';
import 'package:base_setup/features/home/provider/home_provider.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: AppSpacing.paddingS,
      margin: AppSpacing.marginHorizontalS,
      decoration: BoxDecoration(
        color: grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ref.watch(languageProvider).languageCode,
          items: [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
          ],
          onChanged: (String? newLang) {
            if (newLang != null) {
              ref.read(languageProvider.notifier).changeLocale(newLang);
            }
          },
        ),
      ),
    );
  }
}
