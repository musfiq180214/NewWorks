import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/core/navigation/app_navigator.dart';
import 'package:base_setup/core/service/internet_service.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityStatusProvider);

    // according to provider logic, 
    // this widget continously listens to the connectivity status
    // and rebuilds the widget when connectivity changes.
    // so, we can use this to show the no internet screen
    // and also to automatically pop back when internet returns.

    // Automatically pop back when internet returns
    if (connectivity != ConnectivityResult.none) { // if internet is available
      Future.microtask(() { // use microtask to ensure this runs after the current synchronpous code finishes
        if (Navigator.canPop(AppNavigator.navigatorKey.currentContext!)) { // check and ensure we have a previous screen and don't get back to a blank screen
          Navigator.pop(AppNavigator
              .navigatorKey.currentContext!); // return to previous screen
        } else {
          /*  Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.splash, (route) => false); */
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: Lottie.asset(
                    'assets/json/no_internet.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Please check your connection and try again.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: connectivity == ConnectivityResult.none
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Still no internet connection'),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 4,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
