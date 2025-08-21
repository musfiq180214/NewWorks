import 'package:base_setup/core/theme/theme_provider.dart';
import 'package:base_setup/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/features/home/widgets/language_switch.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  // WidgetRef ref is passed to access providers

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // Watching the theme mode provider to get the current theme mode

    final themeMode = ref.watch(themeModeProvider);

    // we used watch because if the theme changes later
    // (even if after the AppBar is built once)
    // the AppBar will rebuild with the new theme
    // if the themeMode changes



    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Theme toggle button
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
            color: Colors.black,
          ),
          onPressed: () {
            ref.read(themeModeProvider.notifier).state =
                themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
          },
        ),
        // Notifications
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
                child: Text(
                  "7",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 8),
        LanguageSwitcher(),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(width: 16),
              CircleAvatar(
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).greeting,
                    style: TextStyle(color: Colors.green, fontSize: 14),
                  ),
                  Text(
                    S.of(context).userName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacer(),
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
              SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
