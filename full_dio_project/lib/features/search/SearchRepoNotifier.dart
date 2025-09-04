import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';

class SearchRepoState {
  final List<dynamic> repos;
  final bool isLoading;
  final bool hasReachedEnd;
  final int page;
  final String query;

  SearchRepoState({
    this.repos = const [],
    this.isLoading = false,
    this.hasReachedEnd = false,
    this.page = 1,
    this.query = '',
  });

  SearchRepoState copyWith({
    List<dynamic>? repos,
    bool? isLoading,
    bool? hasReachedEnd,
    int? page,
    String? query,
  }) {
    return SearchRepoState(
      repos: repos ?? this.repos,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      page: page ?? this.page,
      query: query ?? this.query,
    );
  }
}

class SearchRepoNotifier extends StateNotifier<SearchRepoState> {
  final ApiClient _apiClient;

  SearchRepoNotifier(this._apiClient) : super(SearchRepoState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = SearchRepoState();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      query: query,
      page: 1,
      hasReachedEnd: false,
    );

    try {
      final repos = await _apiClient.searchRepos(query, page: 1, perPage: 20);
      state = state.copyWith(
        repos: repos,
        isLoading: false,
        hasReachedEnd: repos.length < 20,
        page: 2,
      );
    } catch (e) {
      AppLogger.getLogger("SearchRepoNotifier").e("Search error: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || state.hasReachedEnd || state.query.isEmpty) return;

    state = state.copyWith(isLoading: true);

    try {
      final repos = await _apiClient.searchRepos(
        state.query,
        page: state.page,
        perPage: 20,
      );
      state = state.copyWith(
        repos: [...state.repos, ...repos],
        isLoading: false,
        hasReachedEnd: repos.isEmpty,
        page: state.page + 1,
      );
    } catch (e) {
      AppLogger.getLogger("SearchRepoNotifier").e("Fetch more error: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  void clear() {
    state = SearchRepoState();
  }
}

final searchRepoNotifierProvider =
    StateNotifierProvider<SearchRepoNotifier, SearchRepoState>((ref) {
      return SearchRepoNotifier(
        ApiClient(githubToken, AppLogger.getLogger("ApiClient")),
      );
    });
