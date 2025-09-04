import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- for theme
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';
import 'package:fulldioproject/features/repo_explorer/file_viewr_screen.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart'; // <-- import toggle

class RepoExplorerScreen extends ConsumerStatefulWidget {
  final String owner;
  final String repo;
  final String path;

  const RepoExplorerScreen({
    super.key,
    required this.owner,
    required this.repo,
    this.path = '',
  });

  @override
  ConsumerState<RepoExplorerScreen> createState() => _RepoExplorerScreenState();
}

class _RepoExplorerScreenState extends ConsumerState<RepoExplorerScreen> {
  late ApiClient _apiClient;
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(githubToken, AppLogger.getLogger("ApiClient"));
    _fetchContents();
  }

  Future<void> _fetchContents() async {
    setState(() => _loading = true);
    try {
      final data = await _apiClient.getRepoContents(
        owner: widget.owner,
        repo: widget.repo,
        path: widget.path,
      );
      setState(() {
        _items = data;
        _loading = false;
      });
    } catch (e) {
      AppLogger.getLogger("RepoExplorer").e("Error: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _openFile(String path, String name) async {
    try {
      final contentData = await _apiClient.getFileContent(
        owner: widget.owner,
        repo: widget.repo,
        path: path,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FileViewerScreen(fileName: name, content: contentData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error opening file: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.repo}${widget.path.isNotEmpty ? '/${widget.path}' : ''}",
        ),
        actions: const [
          ThemeToggleButton(), // <-- added toggle button
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final type = item['type']; // "file" or "dir"
                final name = item['name'];
                final path = item['path'];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  shadowColor: Colors.green.withOpacity(0.5),
                  child: ListTile(
                    leading: Icon(
                      type == 'dir' ? Icons.folder : Icons.insert_drive_file,
                      color: type == 'dir' ? Colors.green : Colors.teal,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        color: type == 'dir'
                            ? Colors.green[800]
                            : Colors.teal[800],
                        fontWeight: type == 'dir'
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      if (type == 'dir') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RepoExplorerScreen(
                              owner: widget.owner,
                              repo: widget.repo,
                              path: path,
                            ),
                          ),
                        );
                      } else if (type == 'file') {
                        _openFile(path, name); // <-- pass path
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
