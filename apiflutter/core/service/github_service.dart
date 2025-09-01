// ---------- CONFIG ----------
import 'dart:convert';
import 'dart:typed_data';

import 'package:apiflutter/public_repo/model/repo_model.dart';
import 'package:apiflutter/public_repo/provider/repo_list_provider.dart';
import 'package:http/http.dart' as http;

// ---------- GITHUB SERVICE ----------
class GithubService {
  final String token;

  GithubService({required this.token});

  Map<String, String> get _headers => {
    'Authorization': 'token $token',
    'Accept': 'application/vnd.github.v3+json',
  };

  Future<bool> checkUserExists(String username) async {
    final res = await http.get(
      Uri.parse("https://api.github.com/users/$username"),
      headers: _headers,
    );
    if (res.statusCode == 200) return true;
    if (res.statusCode == 404) return false;
    if (res.statusCode == 403) throw Exception("API rate limit exceeded");
    throw Exception("Error: ${res.statusCode}");
  }

  Future<List<dynamic>> fetchRepos(
    String username, {
    int perPage = 20,
    int page = 1,
  }) async {
    final res = await http.get(
      Uri.parse(
        "https://api.github.com/users/$username/repos?per_page=$perPage&page=$page",
      ),
      headers: _headers,
    );
    if (res.statusCode == 200) return json.decode(res.body);
    if (res.statusCode == 403) throw Exception("API rate limit exceeded");
    throw Exception("Failed to fetch repos");
  }

  Future<Map<String, dynamic>> fetchRepoDetails(
    String owner,
    String repoName,
  ) async {
    final res = await http.get(
      Uri.parse("https://api.github.com/repos/$owner/$repoName"),
      headers: _headers,
    );
    if (res.statusCode == 200) return json.decode(res.body);
    if (res.statusCode == 403) throw Exception("API rate limit exceeded");
    throw Exception("Failed to fetch repo details");
  }

  Future<List<dynamic>> fetchRepoContents(
    String owner,
    String repoName, [
    String? path,
  ]) async {
    final url = path == null
        ? "https://api.github.com/repos/$owner/$repoName/contents"
        : "https://api.github.com/repos/$owner/$repoName/contents/$path";

    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else if (response.statusCode == 403) {
      throw Exception("GitHub API rate limit exceeded");
    } else {
      throw Exception(
        "Failed to fetch repo contents. Status code: ${response.statusCode}",
      );
    }
  }

  Future<String> fetchFileContent(
    String owner,
    String repoName,
    String path,
  ) async {
    final url = "https://api.github.com/repos/$owner/$repoName/contents/$path";
    final res = await http.get(Uri.parse(url), headers: _headers);

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      if (decoded is Map<String, dynamic>) {
        final content = decoded['content'];
        final encoding = decoded['encoding'];
        if (content == null) throw Exception("No content field returned");
        if (encoding == 'base64') {
          final cleaned = (content as String).replaceAll('\n', '');
          try {
            final bytes = base64.decode(cleaned);
            return utf8.decode(bytes);
          } catch (e) {
            throw Exception("This file cannot be displayed as text.");
          }
        } else {
          return content.toString();
        }
      } else {
        throw Exception("Unexpected response format");
      }
    } else if (res.statusCode == 403) {
      throw Exception("GitHub API rate limit exceeded");
    } else if (res.statusCode == 404) {
      throw Exception("File not found");
    } else {
      throw Exception("Failed to fetch file content");
    }
  }

  /// New method to fetch raw bytes
  Future<Uint8List> fetchFileBytes(
    String owner,
    String repoName,
    String path,
  ) async {
    final url = Uri.parse(
      'https://api.github.com/repos/$owner/$repoName/contents/$path',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'token $token',
        'Accept':
            'application/vnd.github.v3+json', // default GitHub API JSON response
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final contentBase64 = json['content'] as String;
      final cleanBase64 = contentBase64.replaceAll('\n', '');
      return base64.decode(cleanBase64);
    } else {
      throw Exception('Failed to fetch file bytes');
    }
  }

  Future<List<Repo>> fetchPublicRepos({int perPage = 20, int since = 0}) async {
    final url = Uri.parse(
      'https://api.github.com/repositories?per_page=$perPage&since=$since',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Repo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }
}
