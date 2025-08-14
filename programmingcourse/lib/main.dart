import 'package:flutter/material.dart';
import 'views/base_page.dart';

void main() {
  runApp(
    MyApp(),
    
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dear Programmer Learning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BasePage(),
    );
  }
}
