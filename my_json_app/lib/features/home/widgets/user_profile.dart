import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/home_provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    if (homeProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = homeProvider.currentUser;
    if (user == null) {
      return const Center(child: Text("No user data"));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 40, child: Text(user.name[0])),
          const SizedBox(height: 16),
          Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(user.email, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
