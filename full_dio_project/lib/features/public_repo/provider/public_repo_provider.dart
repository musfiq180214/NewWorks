import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';

class PublicRepoState {
  final List<dynamic> repos;
  final bool isLoading;
  final bool hasReachedEnd;
  final int since;

  PublicRepoState({
    this.repos = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.since = 0,
  });

  PublicRepoState copyWith({
    List<dynamic>? repos,
    bool? isLoading,
    bool? hasReachedEnd,
    int? since,
  }) {
    return PublicRepoState(
      repos: repos ?? this.repos,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      since: since ?? this.since,
    );
  }
}

class PublicRepoNotifier extends StateNotifier<PublicRepoState> {
  final ApiClient _apiClient;

  PublicRepoNotifier(this._apiClient) : super(PublicRepoState());

  Future<void> fetchMoreRepos() async {
    if (state.isLoading || state.hasReachedEnd) return;

    state = state.copyWith(isLoading: true);

    try {
      final repos = await _apiClient.getPublicRepos(
        since: state.since,
        perPage: 20,
      );

      if (repos.isEmpty) {
        state = state.copyWith(isLoading: false, hasReachedEnd: true);
      } else {
        final newSince = repos.last['id'] as int;
        state = state.copyWith(
          repos: [...state.repos, ...repos],
          isLoading: false,
          since: newSince,
        );
      }
    } catch (e) {
      AppLogger.getLogger("PublicRepoNotifier").e("Error fetching repos: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = PublicRepoState();
    await fetchMoreRepos();
  }
}

final publicRepoNotifierProvider =
    StateNotifierProvider<PublicRepoNotifier, PublicRepoState>((ref) {
      return PublicRepoNotifier(
        ApiClient(githubToken, AppLogger.getLogger("ApiClient")),
      );
    });
