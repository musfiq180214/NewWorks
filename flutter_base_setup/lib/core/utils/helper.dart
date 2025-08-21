import 'package:flutter/material.dart';
import 'package:base_setup/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
// lets me open external URLs, dial numbers, send emails, etc.

extension L10nExtension on BuildContext {
  S get t => S.of(this);
}
// Extensions let me add new methods/properties to existing classes (without modifying them)
// BuildContex is a class that provides information about the location of a widget in the widget tree.
// We wanted to add a new property t to BuildContext that returns the current instance of S.


bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  // RegExp -> Dart's class for working with regular expressions (rules for matching text patterns)

  //                           word characters, hyphens, dots, @, domain name, and top-level domain(length 2 - 4)

  // ^ -> start of the string
  // [\w-\.]+ -> one or more word characters, hyphens, or dots
  // @ -> must have an @ symbol
  // ([\w-]+\.)+ -> one or more groups of word characters or hyphens followed by a dot


  return emailRegex.hasMatch(email);
}

String getLocalizedText({ required BuildContext context, String? en, String? bn,}) 
{
  // localizations.localeOf() takes the current BuildContext returns the current locale (language & region ) for the given BuildContext.)
  // It finds the nearest Localizations widget, which holds the current locale (language and region))
  final locale = Localizations.localeOf(context);
  return (locale.languageCode == 'bn' ? bn : en) ?? bn ?? en ?? '';

  // If the locale is Bengali, return the Bengali text, otherwise return the English text.
  // If both are null, return an empty string.
  // The ?? operator returns the first non-null value.
  // If both en and bn are null, it returns an empty string.
  // This is useful for providing localized text in different languages.
}

void openUrl(String url) async {
  final uri = Uri.tryParse(url)!;  // tries to convert the string into a Uri object
  if (await canLaunchUrl(uri)) {   // if the device can open the given URL
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);     // opens the URL, the URL will be opened inside app using an in-app browser view
  } else {
    throw 'Could not open the map.';
  }
}
