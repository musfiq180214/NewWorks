import 'package:flutter/material.dart';
import 'package:base_setup/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

extension L10nExtension on BuildContext {
  S get t => S.of(this);
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

String getLocalizedText({
  required BuildContext context,
  String? en,
  String? bn,
}) {
  final locale = Localizations.localeOf(context);
  return (locale.languageCode == 'bn' ? bn : en) ?? bn ?? en ?? '';
}

void openUrl(String url) async {
  final uri = Uri.tryParse(url)!;
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  } else {
    throw 'Could not open the map.';
  }
}
