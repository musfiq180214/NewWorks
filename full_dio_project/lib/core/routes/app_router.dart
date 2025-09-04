import 'package:flutter/material.dart';
import 'package:fulldioproject/core/routes/route_names.dart';
import 'package:fulldioproject/features/github_repo_screen.dart';
import 'package:fulldioproject/features/login/presentation/login_page.dart';
import 'package:fulldioproject/features/public_repo/presentation/public_repo_screen.dart';
import 'package:fulldioproject/features/repo_explorer/repo_explorer_screen.dart';
import 'package:fulldioproject/features/starred_repo/presentation/starred_repo_screen.dart';
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

      case RouteNames.publicRepos: // <-- add this case
        return MaterialPageRoute(builder: (_) => const PublicRepoScreen());

      case RouteNames.starredRepos:
        return MaterialPageRoute(builder: (_) => const StarredRepoScreen());

      case RouteNames.repoExplorer:
        final args = settings.arguments as Map<String, dynamic>;
        final owner = args['owner'] as String;
        final repo = args['repo'] as String;
        final path = args['path'] as String? ?? '';
        return MaterialPageRoute(
          builder: (_) =>
              RepoExplorerScreen(owner: owner, repo: repo, path: path),
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
