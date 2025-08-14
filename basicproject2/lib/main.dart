import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); 
  }
}

void main() {
  runApp(
    
    ChangeNotifierProvider(
      create: (_) => Counter(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider + ChangeNotifier Demo',
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    print('CounterScreen rebuilt'); 
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Example')),
      body: Center(
        child: Consumer<Counter>(
          builder: (context, counter, child) {
            return Text(
              'Count: ${counter.count}',
              style: const TextStyle(fontSize: 40),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Increment button pressed');
          Provider.of<Counter>(context, listen: false).increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
