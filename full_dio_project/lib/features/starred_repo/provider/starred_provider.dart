import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/providers/api_client_provider.dart';

final starredRepoNotifierProvider =
    StateNotifierProvider<StarredRepoNotifier, List<dynamic>>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return StarredRepoNotifier(apiClient);
    });

class StarredRepoNotifier extends StateNotifier<List<dynamic>> {
  final ApiClient apiClient;

  StarredRepoNotifier(this.apiClient) : super([]);

  Future<void> fetchStarredRepos() async {
    try {
      final repos = await apiClient.getStarredRepos();
      state = repos;
    } catch (e) {
      // TODO: handle error properly (show Snackbar/Toast)
      state = [];
    }
  }

  Future<void> toggleStar(String owner, String repo, bool isStarred) async {
    try {
      if (isStarred) {
        await apiClient.unstarRepo(owner: owner, repo: repo);
      } else {
        await apiClient.starRepo(owner: owner, repo: repo);
      }
      await fetchStarredRepos(); // refresh list
    } catch (e) {
      // TODO: handle error properly
    }
  }
}
