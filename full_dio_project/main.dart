import 'package:flutter/material.dart';
import 'package:fulldioproject/core/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'core/logger/app_logger.dart';
import 'features/login/provider/login_provider.dart';

void main() {
  AppLogger.init(isProduction: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      ),
    );
  }
}

/*
loginProvider.login() requests for valid login with the endoint : (/users/$username/repos) //validation
GithubRepoScreen.fetchRepos() to actually fetch and display the repos with the same endpoint //data fetching

that's why we see 2 request and response in log 
*/
