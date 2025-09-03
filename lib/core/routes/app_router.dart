import 'package:flutter/material.dart';
import 'package:fulldioproject/core/routes/route_names.dart';
import 'package:fulldioproject/features/github_repo_screen.dart';
import 'package:fulldioproject/features/login/presentation/login_page.dart';
import 'package:fulldioproject/features/user_Info/user_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case RouteNames.githubRepos:
        final username = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GithubRepoScreen(username: username),
        );

      case RouteNames.githubUser:
        final username = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => GithubUserScreen(username: username),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
