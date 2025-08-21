import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:base_setup/core/navigation/app_navigator.dart';
import 'package:base_setup/core/utils/logger.dart';

// ConnectivityResult is an enum from connectivity_plus representing:

// wifi, mobile, ethernet, none, other


/// INTERNET CONNECTIVITY HANDLER
final internetStatusProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

// Connectivity().onConnectivityChanged is a stream pipe.

// the app reacts in real-time to changes in network state.

// Connectivity() is a class from the connectivity_plus package that provides access to the device's network connectivity status.

// onConnectivityChanged is a getter of Connectivity class that returs a stream: Stream<List<ConnectivityResult>>

// enum ConnectivityResult {
//   wifi,       // Connected via Wi-Fi
//   mobile,     // Connected via mobile/cellular data
//   ethernet,   // Connected via ethernet (rare on mobile)
//   none,       // No internet connection
//   other       // Other types of connection
// }

// internetStatusProvider = [wifi, wifi, wifi, none, none, mobile, ethernet, ethernet, none,...]




// StreamProvider<List<ConnectivityResult>> 
// it returns a stream of values that can be listened to
// provides a stream of internet connectivity statuses that can change over time.
// each emission is a list of ConnectivityResult.
// (ref) { ... } - a callback function that defines how the provider generates its values.
// ref is a reference that allows providers to:
// watch other providers,
// read or write state,
// Listen to lifecycle events.
// Connectivity() creates an instance of the connectivity_plus plugin.
// .onConnectivityChanged is a stream provided by the plugin:
// it emits a new ConnectivityResult every time the connectivity status changes.
// This makes it easier to handle loading and error states in the UI.


/// Cached latest connectivity status for sync access (e.g., in Dio)

// final connectivityStatusProvider1 = StateProvider<ConnectivityResult>;

// We could use this provider to store the latest connectivity status

// But we give it a default initial value of ConnectivityResult.wifi
// assuming the app starts with a wifi connection.

final connectivityStatusProvider = StateProvider<ConnectivityResult>((ref) {
  return ConnectivityResult.wifi;
});

// StateProvider is a Riverpod provider that can hold int, String, List or **mutable/changable state. 
// connectivityResult is the type of the data it stores.
/// ConnectivityResult is a flutter enum that represents the type of internet connection
// Here, it stores one ConnectivityResult value (wifi, mobile, none, etc.) at a time, which can be updated.
// (ref) { ... } -> Read other providers, manage lifecycle of this provider, etc.
// The initial value is set to ConnectivityResult.wifi, assuming the app starts with a wifi connection.
// later, this value can be updated based on the actual connectivity status.
// without an initial value, the provider would be in an uninitialized state.

// ConnectivityStatusProvider = [ConnectivityResult.wifi, ConnectivityResult.mobile, ConnectivityResult.none, ...]

class InternetHandler {
  final BuildContext context; // navigate between screens
  final WidgetRef ref; // access Riverpod providers
  // using this provider, we can notify the app about internet connectivity changes.

  InternetHandler({required this.context, required this.ref}); // constructor

  // internetStatusProvider = [wifi, wifi, wifi, none, none, mobile, ethernet, ethernet, none,...]

  void init() {
    ref.listen<AsyncValue<List<ConnectivityResult>>>(internetStatusProvider, (
      previous,
      next,
    )       // whenever new connectivity status is emmited, callback runs.
           // AsyncValue -> wrapper used by Riverpod to represent asynchronous data.

           // It could be in loading, error, or data state

           // AsyncLoading -> waiting for the first connectivity update

          // 
          // AsyncData -> the data is successfully fetched.
          // AsyncError -> an error occurrred while fetching the data.

          // at each timestamp, previous and next are the previous and current values of the provider.

          // AsyncValue.loading()
          // AsyncValue.data([wifi])
          // AsncValue.data([mobile])
          // AsyncValue.error(e)

          // At t=0:
          // previous = AsyncValue.loading()
          // next = AsyncValue.data([wifi])

          // At t=1:
          // previous = AsyncValue.data([wifi])
          // next = AsyncValue.data([wifi])

          // At t=2:
          // previous = AsyncValue.data([wifi])
          // next = AsyncValue.data([none])

          // At t=3:
          // previous = AsyncValue.data([none])
          // next = AsyncValue.data([mobile])

    {
      next.whenData((statuses) {
        // Determine if the device has internet and what type of connection it has

        // statuses is a list of ConnectivityResult, which can be empty if no connection is available.

        // statuses = [ ConnectivityResult.wifi, ConnectivityResult.none, ConnectivityResult.mobile ....];

        // .any is a Dart List method that checks if any element in the list satisfies a condition
        // In this case, it checks if any status is not ConnectivityResult.none or ConnectivityResult.other.
        // This means the device has an active internet connection.
        // If any status is not none or other, it means the device has internet.
        
        // ConnectivityResult.none means no internet connection

        // ConnectivityResult.other means unknown ((e.g., VPN, etc.) or unsupported connection 

        // If all statuses are none or other, it means the device has no internet ; so returns false.
        // If any status is wifi or mobile, it means the device has internet; so returns true.  
        // This is useful for determining if the device has internet or not.

        final hasInternet = statuses.any((status) {
          // Log the status for debugging
          AppLogger.i("Connectivity Status Changed: ${status.name}");

          return status != ConnectivityResult.none &&
              status != ConnectivityResult.other;
        });

        // The  process of determining the type of connection: wifi/mobile/none


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
