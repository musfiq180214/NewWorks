import 'package:base_setup/core/utils/logger.dart';
import 'package:base_setup/features/errorScreens/no_internet.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  RouteNames._();
  static const String landing = '/landing';
  static const String noInternet = '/noInternet';
}

abstract class AppNavigator {
  
  AppNavigator._();

  static final navigatorKey = GlobalKey<NavigatorState>();
  // allows to navigate anywhere in the app without passing BuildContext
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    AppLogger.i("Current Route==>> ${settings.name}");
    switch (settings.name) {
      /*   case RouteNames.landing:
        return MaterialPageRoute(builder: (_) => LandingScreen()); */
      case RouteNames.noInternet:
        return MaterialPageRoute(builder: (_) => NoInternetScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
