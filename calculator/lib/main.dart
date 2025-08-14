import 'package:calculator/models/history_model.dart';
import 'package:flutter/material.dart';
import 'screens/calculator_screen.dart';
import 'screens/history_screen.dart';
import 'widgets/toggle_button.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HistoryModel(),
      child: CalculatorApp(),
      ),
    );
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator with History',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showCalculator = true;

  void toggleView() {
    setState(() {
      showCalculator = !showCalculator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showCalculator ? 'Calculator' : 'History'),
        centerTitle: true,
        actions: [
          ToggleButton(
            isCalculatorShown: showCalculator,
            onPressed: toggleView,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: showCalculator
            ? const CalculatorScreen(key: ValueKey('calculator'))
            : const HistoryScreen(key: ValueKey('history')),
      ),
    );
  }
}
