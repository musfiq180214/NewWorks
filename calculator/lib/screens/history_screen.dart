import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryModel>().history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              context.read<HistoryModel>().clearHistory();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(history[index]),
        ),
      ),
    );
  }
}
