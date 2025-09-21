// import 'dart:async';
// import 'package:amar_shoday/core/routes/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
// import 'package:easy_localization/easy_localization.dart';

// class NoInternetPage extends StatefulWidget {
//   @override
//   State<NoInternetPage> createState() => _NoInternetPageState();
// }

// class _NoInternetPageState extends State<NoInternetPage> {
//   late StreamSubscription<InternetStatus> _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _subscription = InternetConnection().onStatusChange.listen((status) {
//       if (status == InternetStatus.connected) {
//         Navigator.pushReplacementNamed(context, RouteNames.landing);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.wifi_off, size: 80, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               "no_internet_title".tr(), // 🔑 localized
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text("no_internet_waiting".tr()), // 🔑 localized
//           ],
//         ),
//       ),
//     );
//   }
// }
