import 'package:flutter/material.dart';
import 'package:base_setup/features/landing/presentation/landing_screen.dart';

class AppRouter {
  static const String root = '/';
  static const String home = '/home';

  static const String itemList = '/item';
  static const String itemDetails = '/item-details';

  // Instead of hardcoding route strings everywhere, i define them in one place (less type-prone)

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {  // The route string to navigate to
      case root:
        return MaterialPageRoute(builder: (_) => LandingScreen());

      // When my app starts('/' route),which means root, the LandingScreen widget is shown

      // if i try to route to a page that hasn't been defined.

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}



// This is the main router for my app
// here i define all the routes and their corresponding widgets.
// as we define all the routes in one place,
// we can easily route from any page to other calling them by route
// rather than hardcoding the widget names everywhere,
// which is less prone to typos and makes it easier to manage navigation.

// we can just route to the route name like this:
// to go to the home page, we can use:
// Navigator.pushNamed(context, AppRouter.home);
// to replace current page with home page, we can use:
// Navigator.pushReplacementNamed(context, AppRouter.home);
// to go back to the previous page, we can use:
// Navigator.pop(context);
// to go back to the root page, we can use:
// Navigator.pushNamedAndRemoveUntil(context, AppRouter.root, (route) => false);
// After a successful login, we can route to the home page like this (so that we can't get back to the login page):
// Navigator.pushReplacementNamed(context, AppRouter.home);

