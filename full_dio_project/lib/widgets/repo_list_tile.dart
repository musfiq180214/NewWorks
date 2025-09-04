import 'package:flutter/material.dart';

class RepoListTile extends StatelessWidget {
  final String name;
  final String url;
  final VoidCallback? onTap; // <-- add this

  const RepoListTile({
    super.key,
    required this.name,
    required this.url,
    this.onTap, // <-- add this
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(url),
      onTap: onTap, // <-- attach the tap callback
    );
  }
}
