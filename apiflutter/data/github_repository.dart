import 'package:apiflutter/core/service/github_service.dart';

class GithubRepository {
  final GithubService githubService;

  GithubRepository({required this.githubService});

  Future<bool> checkUserExists(String username) async {
    return await githubService.checkUserExists(username);
  }
}
