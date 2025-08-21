import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.blue,
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3', // Placeholder image
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'johndoe@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Options List
            Expanded(
              child: ListView(
                children: [
                  ProfileOption(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.person,
                    title: 'Account',
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  ProfileOption(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.blue),
      title: Text(
        title,
        style: TextStyle(
            color: isDestructive ? Colors.red : Colors.black,
            fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
