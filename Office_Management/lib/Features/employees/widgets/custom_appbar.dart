import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool compaq;
  final bool drawer;
  final bool notification;
  final GlobalKey<ScaffoldState>? scaffoldkey;
  final String title;

  const CustomAppBar({
    Key? key,
    this.compaq = false,
    this.drawer = false,
    this.notification = false,
    this.scaffoldkey,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: drawer
          ? IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                scaffoldkey?.currentState?.openDrawer();
              },
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: compaq ? 16 : 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      actions: [
        if (notification)
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // add notification logic here
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
