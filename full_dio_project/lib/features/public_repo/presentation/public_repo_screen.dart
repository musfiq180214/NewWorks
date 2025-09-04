import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/routes/route_names.dart';
import 'package:fulldioproject/features/public_repo/provider/public_repo_provider.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart';

class PublicRepoScreen extends ConsumerStatefulWidget {
  const PublicRepoScreen({super.key});

  @override
  ConsumerState<PublicRepoScreen> createState() => _PublicRepoScreenState();
}

class _PublicRepoScreenState extends ConsumerState<PublicRepoScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final provider = ref.read(publicRepoNotifierProvider.notifier);

      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !ref.read(publicRepoNotifierProvider).isLoading &&
          !ref.read(publicRepoNotifierProvider).hasReachedEnd) {
        provider.fetchMoreRepos();
      }
    });

    // Initial load
    Future.microtask(() {
      ref.read(publicRepoNotifierProvider.notifier).fetchMoreRepos();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(publicRepoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌍 Public GitHub Repos"),
        actions: const [
          ThemeToggleButton(), // <-- added theme toggle here
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(publicRepoNotifierProvider.notifier).refresh();
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(12),
          itemCount: state.repos.length + (state.isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < state.repos.length) {
              final repo = state.repos[index];
              final repoName = repo['name'] ?? 'Unknown';
              final owner = repo['owner']?['login'] ?? '';

              return Card(
                elevation: 3,
                shadowColor: Colors.green.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.teal),
                  title: Text(
                    repoName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.repoExplorer,
                      arguments: {'owner': owner, 'repo': repoName, 'path': ''},
                    );
                  },
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
