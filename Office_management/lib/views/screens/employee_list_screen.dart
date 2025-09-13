// import 'package:flutter/material.dart';
// import 'dart:convert';
// import '../../core/api_client.dart';
// import '../../core/constants.dart';
// import '../../utils/logger.dart';

// class EmployeeListScreen extends StatefulWidget {
//   const EmployeeListScreen({Key? key}) : super(key: key);

//   @override
//   State<EmployeeListScreen> createState() => _EmployeeListScreenState();
// }

// class _EmployeeListScreenState extends State<EmployeeListScreen> {
//   bool loading = false;
//   String? error;
//   List employees = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }

//   Future<void> _fetch() async {
//     setState(() {
//       loading = true;
//       error = null;
//     });

//     try {
//       final api = APIClient();
//       final resp = await api.get(EndPoints.employeeListPath);

//       // Log raw response
//       logger.i('=== Employee List Raw Response ===');
//       logger.d(resp);

//       final data = resp['data'] ?? resp['employees'] ?? resp;

//       // Log parsed data
//       logger.i('=== Parsed Data ===');
//       logger.d(data);

//       if (data is List) {
//         employees = data;
//       } else if (data is Map && data['items'] is List) {
//         employees = data['items'];
//       } else {
//         error = 'Unable to parse employee list';
//       }
//     } catch (e) {
//       logger.e('Error fetching employee list', error: e);
//       error = e.toString();
//     } finally {
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Employees')),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//           ? Center(child: Text('Error: $error'))
//           : ListView.builder(
//               itemCount: employees.length,
//               itemBuilder: (_, i) {
//                 final e = employees[i];
//                 return ListTile(
//                   title: Text(e['name'] ?? 'No name'),
//                   subtitle: Text('ID: ${e['id'] ?? '-'}'),
//                 );
//               },
//             ),
//     );
//   }
// }
