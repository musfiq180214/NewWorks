// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:office_management/Features/attendance/presentation/attendance_screen.dart';
// import 'package:office_management/Features/avg_attendance/screens/avarage_time_screen.dart';
// import 'package:office_management/Features/employees/presentation/employee_list_screen.dart';
// import '../../controllers/auth_controller.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authControllerProvider);
//     final authCtrl = ref.read(authControllerProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dashboard'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await authCtrl.logout();
//               Navigator.of(context).pushReplacementNamed('/');
//             },
//             icon: const Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome ${authState.user?.name ?? 'User'}',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const AttendanceScreen()),
//               ),
//               child: const Text('Attendances'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const EmployeeListScreen()),
//               ),
//               child: const Text('Employees'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const AverageTimeScreen()),
//               ),
//               child: const Text('Average Attendance'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
