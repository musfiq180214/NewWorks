import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.dashboard,
      // initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
