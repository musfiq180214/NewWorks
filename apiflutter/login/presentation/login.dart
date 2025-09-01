import 'package:apiflutter/core/service/github_service.dart';
import 'package:apiflutter/domain/usecase/check_user_exists.dart';
import 'package:apiflutter/login/provider/login_provider.dart';
import 'package:apiflutter/login/widgets/login_form.dart';
import 'package:apiflutter/repo_list/repo_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/github_repository.dart';

class LoginPage extends StatelessWidget {
  final GithubService githubService;

  LoginPage({required this.githubService, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(
        checkUserExistsUseCase: CheckUserExists(
          repository: GithubRepository(githubService: githubService),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("GitHub Viewer")),
        body: Center(
          child: LoginForm(
            onLoginSuccess: (username) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => RepoListPage(
                    username: username,
                    githubService: githubService,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
