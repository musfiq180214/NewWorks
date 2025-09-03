import 'package:flutter/material.dart';

class RepoListTile extends StatelessWidget {
  final String name;
  final String url;

  const RepoListTile({super.key, required this.name, required this.url});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      title: Text(name),
      subtitle: Text(url),
    );
  }
}
