import 'package:amar_shoday/features/home/landing_page_2.dart';
import 'package:amar_shoday/features/onboarding/language_page.dart';
import 'package:amar_shoday/features/onboarding/splash_page.dart';
import 'package:amar_shoday/features/onboarding/suggest_area_page.dart';
import 'package:amar_shoday/features/search_results/search_results_page.dart';
import 'package:flutter/material.dart';
import 'package:amar_shoday/core/routes/route_names.dart';

import 'package:amar_shoday/features/landing.dart';
// import 'package:amar_shoday/features/no_internet/presentation/no_internet.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RouteNames.language:
        return MaterialPageRoute(builder: (_) => const LanguagePage());
      case RouteNames.suggestArea:
        return MaterialPageRoute(builder: (_) => const SuggestAreaPage());
      case RouteNames.landing2:
        return MaterialPageRoute(builder: (_) => const LandingPage2());
      case RouteNames.landing:
        return MaterialPageRoute(
            builder: (_) => const Landing()); // your original Landing
      case RouteNames.searchResults:
        final args = settings.arguments as Map<String, dynamic>?;
        final query = args?['query'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => SearchResultsPage(searchQuery: query),
        );

      // case RouteNames.noInternet:
      //   return MaterialPageRoute(builder: (_) => NoInternetPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
