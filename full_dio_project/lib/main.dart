import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:fulldioproject/core/routes/app_router.dart';
import 'core/logger/app_logger.dart';
import 'features/login/provider/login_provider.dart';
import 'features/theme/theme_provider.dart'; // <-- new

void main() {
  AppLogger.init(isProduction: false);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return provider.ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeMode, // <-- controlled by Riverpod
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}
