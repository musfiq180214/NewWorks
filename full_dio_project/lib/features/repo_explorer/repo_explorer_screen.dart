import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';
import 'package:fulldioproject/features/repo_explorer/file_viewr_screen.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart';
import 'package:fulldioproject/features/user_Info/user_screen.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dirColor = isDark ? Colors.green[300] : Colors.green[800];
    final fileColor = isDark ? Colors.teal[200] : Colors.teal[800];
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.repo}${widget.path.isNotEmpty ? '/${widget.path}' : ''}",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Owner Page",
            onPressed: () async {
              try {
                final authUser = await _apiClient.getAuthenticatedUser();

                // Navigate to GithubUserScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GithubUserScreen(username: widget.owner),
                  ),
                );
              } catch (e) {
                // fallback if authenticated user not fetched
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GithubUserScreen(username: widget.owner),
                  ),
                );
              }
            },
          ),

          const ThemeToggleButton(),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final type = item['type'];
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
                      color: type == 'dir' ? dirColor : fileColor,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        color: textColor,
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
                        _openFile(path, name);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
