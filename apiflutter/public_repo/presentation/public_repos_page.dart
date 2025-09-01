import 'package:apiflutter/public_repo/provider/repo_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apiflutter/core/service/github_service.dart';
import 'package:apiflutter/repo_detail/repo_detail_page.dart';

class PublicReposPage extends ConsumerStatefulWidget {
  const PublicReposPage({super.key});

  @override
  ConsumerState<PublicReposPage> createState() => _PublicReposPageState();
}

class _PublicReposPageState extends ConsumerState<PublicReposPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Schedule provider reset & fetch after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset provider state
      ref.read(repoListProvider.notifier).state = RepoListState(
        repos: [],
        isLoading: false,
        hasMore: true,
        since: 0,
      );

      // Fetch initial repos
      ref.read(repoListProvider.notifier).fetchRepos();
    });

    _scrollController.addListener(() {
      final state = ref.read(repoListProvider);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !state.isLoading &&
          state.hasMore) {
        ref.read(repoListProvider.notifier).fetchRepos();
      }
    });
  }

  void _openRepo(String owner, String repoName) {
    final githubService = GithubService(token: githubToken);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RepoDetailPage(
          owner: owner,
          repoName: repoName,
          githubService: githubService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(repoListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Public GitHub Repos")),
      body: state.error != null
          ? Center(child: Text('Error: ${state.error}'))
          : ListView.builder(
              controller: _scrollController,
              itemCount: state.repos.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.repos.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final repo = state.repos[index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(repo.avatarUrl),
                    ),
                    title: Text("${index + 1}. ${repo.name}"),
                    subtitle: Text(repo.owner),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openRepo(repo.owner, repo.name),
                  ),
                );
              },
            ),
    );
  }
}
