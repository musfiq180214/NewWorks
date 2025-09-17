import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.login,
      // initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.generateRoute, // <-- this is required
      debugShowCheckedModeBanner: false,
    );
  }
}

// demo app to just test if url works

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:logger/logger.dart';

// // Custom output to force logs to terminal
// class ConsoleOutput extends LogOutput {
//   @override
//   void output(OutputEvent event) {
//     for (var line in event.lines) {
//       print(line);
//     }
//   }
// }

// // Initialize logger
// final logger = Logger(
//   printer: PrettyPrinter(
//     methodCount: 0,
//     errorMethodCount: 5,
//     lineLength: 80,
//     colors: true,
//     printEmojis: true,
//   ),
//   level: Level.trace,
//   output: ConsoleOutput(),
// );

// void main() {
//   logger.i("App starting..."); // Should appear in terminal immediately

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: ApiTestPage());
//   }
// }

// class ApiTestPage extends StatefulWidget {
//   const ApiTestPage({super.key});

//   @override
//   State<ApiTestPage> createState() => _ApiTestPageState();
// }

// class _ApiTestPageState extends State<ApiTestPage> {
//   String _response = 'Fetching...';

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final url = Uri.parse('https://fakestoreapi.com/products');

//     // final url = Uri.parse("http://internal-api.misfit.tech/emp/api/v1/list");

//     // final url = Uri.parse("http://internal-api.misfit.tech/emp/api/v1/average");

//     try {
//       final response = await http.get(url);
//       logger.i('Status code: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         try {
//           final data = json.decode(response.body);
//           logger.i(
//             'Response JSON:\n${const JsonEncoder.withIndent('  ').convert(data)}',
//           );
//           setState(() {
//             _response = const JsonEncoder.withIndent('  ').convert(data);
//           });
//         } catch (jsonError, stackTrace) {
//           logger.e(
//             'Failed to parse JSON',
//             error: jsonError,
//             stackTrace: stackTrace,
//           );
//           logger.e('Raw response: ${response.body}');
//           setState(() {
//             _response = 'Invalid JSON:\n${response.body}';
//           });
//         }
//       } else {
//         // Non-200 status -> log as error
//         logger.e(
//           'Request failed with status: ${response.statusCode}',
//           error: 'Response body: ${response.body}',
//         );
//         setState(() {
//           _response =
//               'Request failed with status: ${response.statusCode}\n${response.body}';
//         });
//       }
//     } catch (e, stackTrace) {
//       logger.e('Network error', error: e, stackTrace: stackTrace);
//       setState(() {
//         _response = 'Network error: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('API Test')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Text(_response),
//       ),
//     );
//   }
// }
