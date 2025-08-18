import 'package:flutter/material.dart';
import 'package:base_setup/features/landing/presentation/landing_screen.dart';

class AppRouter {
  static const String root = '/';
  static const String home = '/home';

  static const String itemList = '/item';
  static const String itemDetails = '/item-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(builder: (_) => LandingScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
