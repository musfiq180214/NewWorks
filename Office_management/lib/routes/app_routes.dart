// import '../views/screens/attendance_screen.dart';
// import '../views/screens/employee_list_screen.dart';

import 'package:flutter/material.dart';
import 'package:office_management/Features/attendance/presentation/attendance_screen.dart';
import 'package:office_management/Features/dashboard/dashboard_screen.dart';
import 'package:office_management/Features/employees/presentation/employee_detail_screen.dart';
import 'package:office_management/Features/employees/presentation/employee_list_screen.dart';
import 'package:office_management/Features/login/login_screen.dart';
import 'package:office_management/Features/splash/splash_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const attendance = '/attendance';
  static const employees = '/employees';
  static const employeeDetail = '/employeeDetail';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    attendance: (_) => const AttendanceScreen(),
    employees: (_) => const EmployeeListScreen(),
  };

  // onGenerateRoute for passing arguments
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case employeeDetail:
        final employee = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => EmployeeDetailPage(employeeDetail: employee),
        );
      default:
        return null; // Let Flutter handle unknown routes
    }
  }
}
