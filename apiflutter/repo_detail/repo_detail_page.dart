import 'dart:typed_data';

import 'package:apiflutter/core/service/github_service.dart';
import 'package:apiflutter/repo_file/repo_file_page.dart';
import 'package:apiflutter/repo_folder/repo_folder_page.dart';
import 'package:flutter/material.dart';

class RepoDetailPage extends StatefulWidget {
  final String owner;
  final String repoName;
  final GithubService githubService;

  const RepoDetailPage({
    required this.owner,
    required this.repoName,
    required this.githubService,
    super.key,
  });

  @override
  State<RepoDetailPage> createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage> {
  late Future<List<dynamic>> _contentsFuture;

  final Set<String> _textExtensions = {
    '.dart',
    '.js',
    '.mjs',
    '.cjs',
    '.ts',
    '.tsx',
    '.jsx',
    '.java',
    '.kt',
    '.kts',
    '.scala',
    '.go',
    '.rs',
    '.py',
    '.rb',
    '.php',
    '.cs',
    '.cpp',
    '.cxx',
    '.cc',
    '.c',
    '.h',
    '.hpp',
    '.m',
    '.mm',
    '.swift',
    '.vb',
    '.r',
    '.jl',
    '.hs',
    '.clj',
    '.cljs',
    '.edn',
    '.ex',
    '.exs',
    '.erl',
    '.fs',
    '.fsx',
    '.groovy',
    '.gradle',
    '.lua',
    '.pl',
    '.pm',
    '.ps1',
    '.psm1',
    '.html',
    '.htm',
    '.xhtml',
    '.css',
    '.scss',
    '.less',
    '.vue',
    '.svelte',
    '.json',
    '.yaml',
    '.yml',
    '.toml',
    '.ini',
    '.cfg',
    '.conf',
    '.env',
    '.xml',
    '.csv',
    '.tsv',
    '.md',
    '.markdown',
    '.rst',
    '.txt',
    '.log',
    '.sh',
    '.bash',
    '.zsh',
    '.bat',
    '.cmd',
    '.make',
    '.mk',
    '.gradle',
    '.gradle.kts',
    '.sql',
    '.dockerfile',
    '.editorconfig',
    '.gitignore',
    '.gitattributes',
    '.dockerignore',
    '.pem',
    '.pub',
    '.crt',
    '.csr',
  };

  final Set<String> _specialTextNames = {
    'makefile',
    'dockerfile',
    'readme',
    'license',
    'gemfile',
    'rakefile',
    'podfile',
    'procfile',
    'vagrantfile',
    'pipfile',
    'gradle',
    'build',
    'workspace',
    'cmakelists.txt',
    'package.json',
    'composer.lock',
    'package-lock.json',
  };

  bool _isTextFileByName(String fileName) {
    final lower = fileName.toLowerCase();
    if (_specialTextNames.contains(lower)) return true;
    if (lower.startsWith('readme')) return true;
    if (lower.startsWith('license')) return true;
    final dot = lower.lastIndexOf('.');
    if (dot == -1) return false;
    final ext = lower.substring(dot);
    return _textExtensions.contains(ext);
  }

  @override
  void initState() {
    super.initState();
    _contentsFuture = widget.githubService.fetchRepoContents(
      widget.owner,
      widget.repoName,
    );
  }

  void _openFolder(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepoFolderPage(
          owner: widget.owner,
          repoName: widget.repoName,
          githubService: widget.githubService,
          path: path,
        ),
      ),
    );
  }

  void _openFile(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepoFilePage(
          owner: widget.owner,
          repoName: widget.repoName,
          path: path,
          githubService: widget.githubService,
        ),
      ),
    );
  }

  /// Returns true if the bytes are likely text
  bool _isTextBytes(Uint8List bytes) {
    const int sampleSize = 512;
    final len = bytes.length < sampleSize ? bytes.length : sampleSize;
    for (int i = 0; i < len; i++) {
      final b = bytes[i];
      // Allow common printable ASCII + newline/tab
      if (b == 9 || b == 10 || b == 13) continue;
      if (b < 32 || b > 126) return false;
    }
    return true;
  }

  Future<void> _handleTap(dynamic item) async {
    final type = item['type'];
    final path = item['path'] as String;
    final name = item['name'] as String;

    if (type == 'dir') {
      _openFolder(path);
      return;
    }

    final isTextByName = _isTextFileByName(name);
    if (isTextByName) {
      _openFile(path);
      return;
    }

    // Fetch file size
    final sizeDynamic = item['size'];
    int size = 0;
    try {
      if (sizeDynamic is int)
        size = sizeDynamic;
      else if (sizeDynamic is String)
        size = int.tryParse(sizeDynamic) ?? 0;
    } catch (_) {
      size = 0;
    }

    const int maxPreviewSize = 500 * 1024; // 500 KB for safety
    if (size > maxPreviewSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This file is too large to preview safely.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final bytes = await widget.githubService.fetchFileBytes(
        widget.owner,
        widget.repoName,
        path,
      );

      Navigator.of(context).pop(); // close loader

      if (_isTextBytes(bytes)) {
        _openFile(path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This file cannot be displayed as text."),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching file: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.repoName)),
      body: FutureBuilder<List<dynamic>>(
        future: _contentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final contents = snapshot.data ?? [];
          if (contents.isEmpty)
            return const Center(child: Text("Empty folder"));

          return ListView.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final item = contents[index];
              final isDir = item['type'] == 'dir';
              final fileName = item['name'] as String;

              return Card(
                child: ListTile(
                  title: Text(fileName),
                  onTap: () => _handleTap(item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
