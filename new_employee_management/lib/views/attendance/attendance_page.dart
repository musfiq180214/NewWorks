import 'package:employee_management/controllers/attendanceController.dart';
import 'package:employee_management/views/attendance/attend_item.dart';
import 'package:employee_management/views/custom_widgets/custom_appbar.dart';
import 'package:employee_management/views/custom_widgets/menubar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());

  @override
  void initState() {
    _attendanceController.getAttendanceData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> attendanceKey = GlobalKey();
    return Scaffold(
      key: attendanceKey,
      appBar: CustomAppBar(
        compaq: false,
        drawer: true,
        notification: false,
        scaffoldkey: attendanceKey,
        title: 'Attendance',
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  "Today",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              GetBuilder<AttendanceController>(builder: (controller) {
                return controller.dashboardtDataAvailable.value
                    ? controller.dashboardtData.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.dashboardtData.length,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return AttendanceItem(
                                item:
                                    controller.dashboardtData.elementAt(index),
                                index: index,
                              );
                            })
                        : const Center(
                            child: Text(
                            "NO DATA FOUND",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ))
                    : SizedBox(
                        height: 150,
                        child: const Center(
                            child: CupertinoActivityIndicator(
                          radius: 15,
                          color: Colors.black45,
                        )),
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
