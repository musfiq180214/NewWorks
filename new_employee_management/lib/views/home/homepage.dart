import 'package:employee_management/controllers/homepageController.dart';
import 'package:employee_management/views/Employee/employeeList.dart';
import 'package:employee_management/views/attendance/attendance_page.dart';
import 'package:employee_management/views/custom_widgets/custom_animated_bottom_bar.dart';
import 'package:employee_management/views/dashboard/dashboard.dart';
import 'package:employee_management/views/history/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.put(HomeController(), permanent: true);

  final _inactiveColor = Colors.grey;

  @override
  void initState() {
    homeController.currentIndex.value = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages.elementAt(homeController.currentIndex.value),
        bottomNavigationBar: _buildBottomBar());
  }

  Widget _buildBottomBar() {
    return Obx(() {
      return CustomAnimatedBottomBar(
        containerHeight: 70,
        backgroundColor: Colors.white,
        selectedIndex: homeController.currentIndex.value,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) =>
            setState(() => homeController.currentIndex.value = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: SvgPicture.asset('assets/images/dashboardicon.svg',
                color: Colors.grey[500]),
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.black87),
            ),
            activeColor: Colors.grey,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset(
              'assets/images/atn.svg',
              height: 18,
              color: Colors.grey[500],
            ),
            title: const Text('Attendance',
                style: TextStyle(color: Colors.black87)),
            activeColor: Colors.grey,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset(
              'assets/images/history.svg',
              color: Colors.grey[500],
            ),
            title:
                const Text('History ', style: TextStyle(color: Colors.black87)),
            activeColor: Colors.grey,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: SvgPicture.asset('assets/images/attendance.svg',
                color: Colors.grey[500]),
            title: const Text('Employees',
                style: TextStyle(color: Colors.black87)),
            activeColor: Colors.grey,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
        ],
      );
    });
  }

  List<Widget> pages = [
    const DashboardPage(),
    const AttendancePage(),
    const HistoryPage(),
    const EmployeeListPage(),
  ];

  // Widget getBody() {
  //   List<Widget> pages = [
  //     const DashboardPage(),
  //     const EmployeeListPage(),
  //     const HistoryPage(),
  //     const AttendancePage(),
  //   ];
  //   return Obx(() {
  //     return IndexedStack(
  //       index: homeController.currentIndex.value,
  //       children: pages,
  //     );
  //   });
  // }
}
