import 'dart:developer';

import 'package:base_setup/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/features/home/presentation/home_screen.dart';
import 'package:base_setup/features/landing/providers/landing_provider.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  final List<Widget> _screens = [
    HomeScreen(),
    ProfileScreen(),
  ];
  // we have imported HomeScreen as 1st screen and gave a Container as 2nd screen
  // simple list of screens so that we can 
  // assign this Landing Screen's Scaffold's body 


  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    var index = ref.watch(bottomNavIndexProvider);
    // this widget is now a listener to te bottomNavIndexProvider
    return Scaffold(
      body: _screens[index],
      // this is where we assign the body of the Scaffold
      // we are selecting the screen from the _screens list
      // based on the current index
      // the index is being watched from the bottomNavIndexProvider
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).state = index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
