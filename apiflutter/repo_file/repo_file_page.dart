// ---------- FILE VIEWER ----------
import 'package:apiflutter/core/service/github_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RepoFilePage extends StatefulWidget {
  final String owner;
  final String repoName;
  final String path;
  final GithubService githubService;

  const RepoFilePage({
    required this.owner,
    required this.repoName,
    required this.path,
    required this.githubService,
    super.key,
  });

  @override
  State<RepoFilePage> createState() => _RepoFilePageState();
}

class _RepoFilePageState extends State<RepoFilePage> {
  late Future<String> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = widget.githubService.fetchFileContent(
      widget.owner,
      widget.repoName,
      widget.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.path.split('/').last;
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        actions: [
          FutureBuilder<String>(
            future: _fileFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.copy),
                  tooltip: "Copy entire file",
                  onPressed: () {
                    final text = snapshot.data ?? '';
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Copied to clipboard")),
                    );
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _fileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final content = snapshot.data ?? '';
          if (content.isEmpty) {
            return const Center(child: Text("Empty file"));
          }

          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(12),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SelectableText(
                    content,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
