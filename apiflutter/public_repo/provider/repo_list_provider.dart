import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Model for Repo
class Repo {
  final int id;
  final String name;
  final String owner;
  final String avatarUrl;

  Repo({
    required this.id,
    required this.name,
    required this.owner,
    required this.avatarUrl,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      id: json['id'] as int,
      name: json['name'] ?? 'Unknown',
      owner: json['owner']?['login'] ?? 'Unknown',
      avatarUrl:
          json['owner']?['avatar_url'] ??
          'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
    );
  }
}

// State class for Repos
class RepoListState {
  final List<Repo> repos;
  final bool isLoading;
  final bool hasMore;
  final int since;
  final String? error;

  RepoListState({
    required this.repos,
    required this.isLoading,
    required this.hasMore,
    required this.since,
    this.error,
  });

  RepoListState copyWith({
    List<Repo>? repos,
    bool? isLoading,
    bool? hasMore,
    int? since,
    String? error,
  }) {
    return RepoListState(
      repos: repos ?? this.repos,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      since: since ?? this.since,
      error: error,
    );
  }
}

// StateNotifier
class RepoListNotifier extends StateNotifier<RepoListState> {
  RepoListNotifier()
    : super(
        RepoListState(repos: [], isLoading: false, hasMore: true, since: 0),
      );

  final int _perPage = 20;

  Future<void> fetchRepos() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final url = Uri.parse(
        'https://api.github.com/repositories?per_page=$_perPage&since=${state.since}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isEmpty) {
          state = state.copyWith(hasMore: false, isLoading: false);
        } else {
          final fetchedRepos = data.map((e) => Repo.fromJson(e)).toList();
          state = state.copyWith(
            repos: [...state.repos, ...fetchedRepos],
            since: fetchedRepos.last.id,
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch repos',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Riverpod provider
final repoListProvider = StateNotifierProvider<RepoListNotifier, RepoListState>(
  (ref) => RepoListNotifier(),
);
