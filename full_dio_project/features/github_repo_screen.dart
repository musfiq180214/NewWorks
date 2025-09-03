import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';
import 'package:fulldioproject/core/routes/route_names.dart';
import 'package:fulldioproject/features/no_internet/presentation/no_internet.dart';
import 'package:fulldioproject/widgets/repo_list_tile.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class GithubRepoScreen extends StatefulWidget {
  final String username;
  const GithubRepoScreen({super.key, required this.username});

  @override
  State<GithubRepoScreen> createState() => _GithubRepoScreenState();
}

class _GithubRepoScreenState extends State<GithubRepoScreen> {
  late final ApiClient _apiClient;
  final _logger = AppLogger.getLogger("GithubRepoScreen");

  bool _isLoading = true;
  List<dynamic> _repos = [];
  String _error = "";
  bool _hasFetchedRepos = false; // Prevent duplicate requests

  late StreamSubscription<InternetStatus> _internetSubscription;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(githubToken, AppLogger.getLogger("ApiClient"));

    // Listen to internet changes
    _internetSubscription = InternetConnection().onStatusChange.listen((
      status,
    ) {
      if (status == InternetStatus.disconnected) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => NoInternetPage(username: widget.username),
            ),
          );
        }
      } else if (status == InternetStatus.connected) {
        if (mounted && _repos.isEmpty) {
          fetchRepos();
        }
      }
    });
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetchedRepos) {
      fetchRepos();
      _hasFetchedRepos = true;
    }
  }

  Future<void> fetchRepos() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      final repos = await _apiClient.getUserRepos(widget.username);

      if (mounted) {
        setState(() {
          _repos = repos;
          _isLoading = false;
        });
      }

      _logger.i("✅ Fetched ${repos.length} repos for ${widget.username}");
    } catch (e, st) {
      String friendlyMessage = "Unexpected error: $e";

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          friendlyMessage = "No Internet";
        } else if (e.response != null) {
          switch (e.response?.statusCode) {
            case 404:
              friendlyMessage = "User not found.";
              break;
            case 403:
              friendlyMessage = "API rate limit exceeded.";
              break;
            default:
              final errorData = e.response?.data;
              final message = errorData is Map
                  ? errorData['message']
                  : e.message;
              friendlyMessage = "Error ${e.response?.statusCode}: $message";
          }
        }
      }

      _logger.e("🔥 Error fetching repos: $friendlyMessage", e, st);

      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = friendlyMessage;
        });
      }
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false, // remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}'s Repos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "View Profile",
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/githubUser',
                arguments: widget.username,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchRepos,
              child: ListView.builder(
                itemCount: _repos.length,
                itemBuilder: (context, index) {
                  final repo = _repos[index];
                  return RepoListTile(
                    name: repo['name'],
                    url: repo['html_url'],
                  );
                },
              ),
            ),
    );
  }
}
