import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fulldioproject/core/api_client.dart';
import 'package:fulldioproject/core/constants/github_constants.dart';
import 'package:fulldioproject/core/logger/app_logger.dart';
import 'package:fulldioproject/features/theme/theme_toggle_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  String? _authenticatedUsername;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(githubToken, AppLogger.getLogger("ApiClient"));
    _fetchAuthenticatedUser();
  }

  Future<void> _fetchAuthenticatedUser() async {
    try {
      final authUser = await _apiClient.getAuthenticatedUser();
      setState(() {
        _authenticatedUsername = authUser['login'];
      });
    } catch (e) {
      _logger.e("Failed to fetch authenticated user: $e");
    }
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

  Widget _infoRow(IconData icon, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Flexible(
            child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMyProfile =
        _authenticatedUsername != null &&
        widget.username.toLowerCase() == _authenticatedUsername!.toLowerCase();
    final appBarTitle = isMyProfile
        ? "My Profile"
        : "${widget.username}'s Profile";

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: const [ThemeToggleButton()],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
              child: Text(
                _error,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchUserInfo,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        _userInfo?['avatar_url'] ?? "",
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      _userInfo?['name'] ?? widget.username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_userInfo?['bio'] != null) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _userInfo!['bio'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Stats",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          _infoRow(
                            FontAwesomeIcons.userFriends,
                            "Followers",
                            _userInfo?['followers']?.toString(),
                          ),
                          _infoRow(
                            FontAwesomeIcons.userPlus,
                            "Following",
                            _userInfo?['following']?.toString(),
                          ),
                          _infoRow(
                            FontAwesomeIcons.bookOpen,
                            "Public Repos",
                            _userInfo?['public_repos']?.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          _infoRow(
                            FontAwesomeIcons.briefcase,
                            "Company",
                            _userInfo?['company'],
                          ),
                          _infoRow(
                            FontAwesomeIcons.locationDot,
                            "Location",
                            _userInfo?['location'],
                          ),
                          _infoRow(
                            FontAwesomeIcons.link,
                            "Blog",
                            _userInfo?['blog'],
                          ),
                          _infoRow(
                            FontAwesomeIcons.envelope,
                            "Email",
                            _userInfo?['email'],
                          ),
                          _infoRow(
                            FontAwesomeIcons.twitter,
                            "Twitter",
                            _userInfo?['twitter_username'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
