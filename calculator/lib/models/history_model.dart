import 'package:flutter/foundation.dart';

class HistoryModel extends ChangeNotifier {
  final List<String> _history = [];

  List<String> get history => List.unmodifiable(_history);

  void addEntry(String entry) {
    _history.add(entry);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
