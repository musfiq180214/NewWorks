// ---------- REPO LIST PAGE ----------
import 'package:apiflutter/core/service/github_service.dart';
import 'package:apiflutter/login/presentation/login.dart';
// import 'package:apiflutter/login_page.dart';
import 'package:apiflutter/main.dart';
import 'package:apiflutter/public_repo/presentation/public_repos_page.dart';
import 'package:apiflutter/repo_detail/repo_detail_page.dart';
import 'package:flutter/material.dart';

class RepoListPage extends StatefulWidget {
  final String username;
  final GithubService githubService;

  RepoListPage({required this.username, required this.githubService});

  @override
  _RepoListPageState createState() => _RepoListPageState();
}

class _RepoListPageState extends State<RepoListPage> {
  List<dynamic> _repos = [];
  int _page = 1;
  bool _loading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchRepos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loading &&
          _hasMore) {
        _fetchRepos();
      }
    });
  }

  Future<void> _fetchRepos() async {
    setState(() => _loading = true);
    try {
      final repos = await widget.githubService.fetchRepos(
        widget.username,
        perPage: 20,
        page: _page,
      );
      if (repos.isEmpty) _hasMore = false;
      _repos.addAll(repos);
      _page++;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(githubService: widget.githubService),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}'s Repos"),
        actions: [
          IconButton(
            icon: Icon(Icons.public),
            tooltip: "Explore Public Repositories",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PublicReposPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      ),

      body: ListView.builder(
        controller: _scrollController,
        itemCount: _repos.length + 1,
        itemBuilder: (context, index) {
          if (index == _repos.length) {
            return _loading
                ? Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : SizedBox.shrink();
          }
          final repo = _repos[index];
          return Card(
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.blue),
              title: Text(
                repo['name'],
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(repo['description'] ?? 'No description'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RepoDetailPage(
                      owner: widget.username,
                      repoName: repo['name'],
                      githubService: widget.githubService,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
