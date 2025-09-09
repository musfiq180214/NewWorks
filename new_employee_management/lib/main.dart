import 'package:employee_management/utils/routes.dart';
import 'package:employee_management/views/Employee/employeeList.dart';
import 'package:employee_management/views/Employee/employee_detail.dart';
import 'package:employee_management/views/attendance/attendance_page.dart';
import 'package:employee_management/views/dashboard/dashboard.dart';
import 'package:employee_management/views/history/history.dart';
import 'package:employee_management/views/home/homepage.dart';
import 'package:employee_management/views/signin/sign_in.dart';
import 'package:employee_management/views/splashscreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

      // options: DefaultFirebaseOptions.currentPlatform,
      );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      // ignore: prefer_const_literals_to_create_immutables
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // ignore: prefer_const_literals_to_create_immutables
      supportedLocales: [
        const Locale('en'),
      ],
      getPages: [
        GetPage(name: homepage, page: () => HomePage()),
        GetPage(name: signinpage, page: () => const SignIn()),
        GetPage(name: dashboardpage, page: () => const DashboardPage()),
        GetPage(name: employeeListepage, page: () => const EmployeeListPage()),
        GetPage(name: attendancePage, page: () => const AttendancePage()),
        GetPage(name: historyPage, page: () => const HistoryPage()),
        GetPage(
            name: employeeDetailPage, page: () => const EmployeeDetailPage()),
      ],
    );
  }
}
