import 'package:apiflutter/core/service/github_service.dart';
import 'package:apiflutter/login/presentation/login.dart';
// import 'package:apiflutter/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------- MAIN APP ----------
void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  final GithubService githubService = GithubService(token: githubToken);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Viewer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        cardTheme: CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: LoginPage(githubService: githubService),
    );
  }
}
