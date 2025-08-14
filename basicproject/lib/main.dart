import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyData {
  final String message;
  MyData(this.message);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Provider Scope Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Provider Scope Demo')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                WideScopeWidget(),
                SizedBox(height: 40),
                NarrowScopeWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Wide Scope Provider: wraps big part of tree
class WideScopeWidget extends StatelessWidget {
  const WideScopeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Provider<MyData>(
      create: (_) => MyData("Wide scope data"),
      child: const Center(child: ChildWidgetWide()),
    );
  }
}

class ChildWidgetWide extends StatelessWidget {
  const ChildWidgetWide({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MyData>(context);
    return Text('Wide scope message: ${data.message}');
  }
}

// Narrow Scope Provider: wraps only a small part
class NarrowScopeWidget extends StatelessWidget {
  const NarrowScopeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Provider<MyData>(
        create: (_) => MyData("Narrow scope data"),
        child: const ChildWidgetNarrow(),
      ),
    );
  }
}

class ChildWidgetNarrow extends StatelessWidget {
  const ChildWidgetNarrow({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<MyData>(context);
    return Text('Narrow scope message: ${data.message}');
  }
}
