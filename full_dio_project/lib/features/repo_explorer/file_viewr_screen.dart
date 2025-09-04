import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart';
import 'package:fulldioproject/features/theme/theme_provider.dart'; // Theme provider

class FileViewerScreen extends ConsumerWidget {
  final String fileName;
  final String content;

  const FileViewerScreen({
    super.key,
    required this.fileName,
    required this.content,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("File content copied to clipboard!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme mode from Riverpod
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;

    // Colors adapt to theme
    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey[800] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: const [
          ThemeToggleButton(), // Theme toggle button
        ],
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: SelectableText(
                  content,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    height: 1.4,
                    color: textColor, // Text color changes with theme
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _copyToClipboard(context),
        tooltip: "Copy content",
        child: const Icon(Icons.copy),
      ),
    );
  }
}
