import 'package:apiflutter/data/github_repository.dart';

class CheckUserExists {
  final GithubRepository repository;

  CheckUserExists({required this.repository});

  Future<bool> call(String username) async {
    return await repository.checkUserExists(username);
  }
}
