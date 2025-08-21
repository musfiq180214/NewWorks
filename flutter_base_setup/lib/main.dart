import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:base_setup/core/routing/app_router.dart';
import 'package:base_setup/core/theme/theme_provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/features/home/provider/home_provider.dart';
import 'core/theme/app_theme.dart';
import 'generated/l10n.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // ensures flutter bindings are ready before i run the app


  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // keeps the native splash screen visible until i removew it (usually after async)

  runApp(const ProviderScope(child: MyApp()));

  // ProviderScope is the root of the app, allowing us to use Riverpod for state management
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // watches the theme mode state provider to get the current theme mode
    // whenever themeMode changes, the app will rebuild with the new theme

    final locale = ref.watch(languageProvider);
    // watches the language provider to get the current locale
    // whenever the locale changes, the app will rebuild with the new locale

    return MaterialApp(
      
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRouter.root,
      themeMode: themeMode,
      // this is where my thememode is set based on the provider state
      onGenerateRoute: AppRouter.generateRoute,
      supportedLocales: S.delegate.supportedLocales, // ✅ Automatic localization
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
    );
  }
}
