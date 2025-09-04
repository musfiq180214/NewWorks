import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- for theme toggle
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart'; // <-- import toggle

class GithubUserScreen extends ConsumerStatefulWidget {
  final String username;
  const GithubUserScreen({super.key, required this.username});

  @override
  ConsumerState<GithubUserScreen> createState() => _GithubUserScreenState();
}

class _GithubUserScreenState extends ConsumerState<GithubUserScreen> {
  late final ApiClient _apiClient;
  final _logger = AppLogger.getLogger("GithubUserScreen");

  bool _isLoading = true;
  Map<String, dynamic>? _userInfo;
  String _error = "";
  bool _hasFetchedUser = false;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(githubToken, AppLogger.getLogger("ApiClient"));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetchedUser) {
      fetchUserInfo();
      _hasFetchedUser = true;
    }
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      _isLoading = true;
      _error = "";
    });

    try {
      final user = await _apiClient.getUserInfo(widget.username);

      setState(() {
        _userInfo = user;
        _isLoading = false;
      });

      _logger.i("✅ Fetched user info for ${widget.username}");
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

      _logger.e("🔥 Error fetching user info: $friendlyMessage", e, st);

      setState(() {
        _isLoading = false;
        _error = friendlyMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}'s Profile"),
        actions: const [
          ThemeToggleButton(), // <-- added theme toggle here
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
              child: Text(
                _error,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchUserInfo,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      _userInfo?['avatar_url'] ?? "",
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userInfo?['name'] ?? widget.username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_userInfo?['bio'] != null) ...[
                    const SizedBox(height: 8),
                    Text(_userInfo!['bio']),
                  ],
                  const SizedBox(height: 16),
                  Text("Followers: ${_userInfo?['followers']}"),
                  Text("Following: ${_userInfo?['following']}"),
                  Text("Public Repos: ${_userInfo?['public_repos']}"),
                ],
              ),
            ),
    );
  }
}
