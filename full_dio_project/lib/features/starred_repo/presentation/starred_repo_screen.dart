import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/routes/route_names.dart';
import 'package:fulldioproject/features/starred_repo/provider/starred_provider.dart';

class StarredRepoScreen extends ConsumerWidget {
  const StarredRepoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final starredRepos = ref.watch(starredRepoNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("⭐ Starred Repositories")),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(starredRepoNotifierProvider.notifier)
              .fetchStarredRepos();
        },
        child: starredRepos.isEmpty
            ? const Center(child: Text("No starred repositories yet"))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: starredRepos.length,
                itemBuilder: (context, index) {
                  final repo = starredRepos[index];
                  final repoName = repo['name'] ?? 'Unknown';
                  final owner = repo['owner']?['login'] ?? '';

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.book, color: Colors.teal),
                      title: Text(
                        repoName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(owner),
                      trailing: IconButton(
                        icon: const Icon(Icons.star, color: Colors.amber),
                        onPressed: () {
                          ref
                              .read(starredRepoNotifierProvider.notifier)
                              .toggleStar(owner, repoName, true);
                        },
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.repoExplorer,
                          arguments: {
                            'owner': owner,
                            'repo': repoName,
                            'path': '',
                          },
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
