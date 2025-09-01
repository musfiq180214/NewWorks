// ---------- FOLDER PAGE ----------

import 'package:apiflutter/core/service/github_service.dart';
import 'package:apiflutter/repo_file/repo_file_page.dart';
import 'package:flutter/material.dart';

class RepoFolderPage extends StatefulWidget {
  final String owner;
  final String repoName;
  final GithubService githubService;
  final String path;

  const RepoFolderPage({
    required this.owner,
    required this.repoName,
    required this.githubService,
    required this.path,
    super.key,
  });

  @override
  State<RepoFolderPage> createState() => _RepoFolderPageState();
}

class _RepoFolderPageState extends State<RepoFolderPage> {
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
      widget.path,
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

    const int maxPreviewSize = 200 * 1024; // 200 KB
    if (size > maxPreviewSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This file is likely binary or too large to preview."),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    try {
      await widget.githubService.fetchFileContent(
        widget.owner,
        widget.repoName,
        path,
      );
      Navigator.of(context).pop();
      _openFile(path);
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This file cannot be displayed as text.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.path.split('/').last)),
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
              final isText = _isTextFileByName(fileName);

              return Card(
                child: ListTile(
                  leading: Icon(
                    isDir
                        ? Icons.folder
                        : isText
                        ? Icons.insert_drive_file
                        : Icons.block,
                    color: isDir
                        ? Colors.amber
                        : isText
                        ? Colors.grey
                        : Colors.red,
                  ),
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
