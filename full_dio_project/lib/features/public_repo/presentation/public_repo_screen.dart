import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/routes/route_names.dart';
import 'package:fulldioproject/features/public_repo/provider/public_repo_provider.dart';
import 'package:fulldioproject/features/search/SearchRepoNotifier.dart';
import 'package:fulldioproject/features/starred_repo/provider/starred_provider.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart';

class PublicRepoScreen extends ConsumerStatefulWidget {
  const PublicRepoScreen({super.key});

  @override
  ConsumerState<PublicRepoScreen> createState() => _PublicRepoScreenState();
}

class _PublicRepoScreenState extends ConsumerState<PublicRepoScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Infinite scroll
    _scrollController.addListener(() {
      final isSearching = _searchController.text.isNotEmpty;
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        if (isSearching) {
          ref.read(searchRepoNotifierProvider.notifier).fetchMore();
        } else {
          ref.read(publicRepoNotifierProvider.notifier).fetchMoreRepos();
        }
      }
    });

    // Initial load
    Future.microtask(() {
      ref.read(publicRepoNotifierProvider.notifier).fetchMoreRepos();
      ref.read(starredRepoNotifierProvider.notifier).fetchStarredRepos();
    });

    // Search listener
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        ref.read(searchRepoNotifierProvider.notifier).clear();
      } else {
        ref.read(searchRepoNotifierProvider.notifier).search(query);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final publicState = ref.watch(publicRepoNotifierProvider);
    final searchState = ref.watch(searchRepoNotifierProvider);
    final starredRepos = ref.watch(starredRepoNotifierProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    final isSearching = _searchController.text.isNotEmpty;
    final repos = isSearching ? searchState.repos : publicState.repos;
    final isLoading = isSearching
        ? searchState.isLoading
        : publicState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🌍 Public GitHub Repos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.starredRepos);
            },
          ),
          const ThemeToggleButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Repos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (isSearching) {
            await ref
                .read(searchRepoNotifierProvider.notifier)
                .search(_searchController.text.trim());
          } else {
            await ref.read(publicRepoNotifierProvider.notifier).refresh();
          }
          await ref
              .read(starredRepoNotifierProvider.notifier)
              .fetchStarredRepos();
        },
        child: repos.isEmpty
            ? Center(
                child: Text(
                  isSearching
                      ? "No repositories match your search 😕"
                      : "Loading repositories...",
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: repos.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < repos.length) {
                    final repo = repos[index];
                    final repoName = repo['name'] ?? 'Unknown';
                    final owner = repo['owner']?['login'] ?? '';
                    final isStarred = starredRepos.any(
                      (r) => r['id'] == repo['id'],
                    );

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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(owner),
                        trailing: IconButton(
                          icon: Icon(
                            isStarred ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            ref
                                .read(starredRepoNotifierProvider.notifier)
                                .toggleStar(owner, repoName, isStarred);
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
