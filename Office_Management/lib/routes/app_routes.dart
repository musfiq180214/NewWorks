import 'package:flutter/material.dart';
import '../views/screens/splash_screen.dart';
import '../views/screens/login_screen.dart';
import '../views/screens/dashboard_screen.dart';
import '../views/screens/attendance_screen.dart';
import '../views/screens/employee_list_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const attendance = '/attendance';
  static const employees = '/employees';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    attendance: (_) => const AttendanceScreen(),
    employees: (_) => const EmployeeListScreen(),
  };
}
