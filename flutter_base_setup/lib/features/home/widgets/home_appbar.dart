import 'package:flutter/material.dart';
import 'package:base_setup/features/home/widgets/language_switch.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.black),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text("7",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
        SizedBox(width: 8),
        LanguageSwitcher(),
      ],
      bottom: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Salam",
                    style: TextStyle(color: Colors.green, fontSize: 14)),
                Text("Jahangir Alam",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Row(
              children: [
                Icon(Icons.phone, color: Colors.white, size: 18),
                SizedBox(width: 4),
                Text("SOS", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}
