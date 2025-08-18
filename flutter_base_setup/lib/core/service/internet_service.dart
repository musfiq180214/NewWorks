import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/core/navigation/app_navigator.dart';
import 'package:base_setup/core/utils/logger.dart';

/// INTERNET CONNECTIVITY HANDLER
final internetStatusProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Cached latest connectivity status for sync access (e.g., in Dio)
final connectivityStatusProvider = StateProvider<ConnectivityResult>((ref) {
  return ConnectivityResult.wifi;
});

class InternetHandler {
  final BuildContext context;
  final WidgetRef ref;

  InternetHandler({required this.context, required this.ref});

  void init() {
    ref.listen<AsyncValue<List<ConnectivityResult>>>(internetStatusProvider, (
      previous,
      next,
    ) {
      next.whenData((statuses) {
        // Determine if the device has internet and what type of connection it has
        final hasInternet = statuses.any((status) {
          // Log the status for debugging
          AppLogger.i("Connectivity Status Changed: ${status.name}");

          return status != ConnectivityResult.none &&
              status != ConnectivityResult.other;
        });

        // Determine the type of connection
        ConnectivityResult connectionType = ConnectivityResult.none;

        // Check for specific types of connections
        if (statuses.contains(ConnectivityResult.wifi)) {
          connectionType = ConnectivityResult.wifi;
          AppLogger.i("Connected via Wi-Fi");
        } else if (statuses.contains(ConnectivityResult.mobile)) {
          connectionType = ConnectivityResult.mobile;
          AppLogger.i("Connected via Mobile Data");
        }

        // Update the connectivity status globally (StateProvider)
        ref.read(connectivityStatusProvider.notifier).state = connectionType;

        // Handle "No Internet" page navigation
        if (!hasInternet) {
          AppLogger.w("No internet connection detected.");
          Navigator.of(context).pushNamed(RouteNames.noInternet);
        } else {
          // Handle returning from "No Internet" page if connection is restored
          if (ModalRoute.of(context)?.settings.name == RouteNames.noInternet) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        }
      });
    });
  }
}
