import 'package:employee_management/controllers/dashboardController.dart';
import 'package:employee_management/utils/timeFormatter.dart';
import 'package:employee_management/views/custom_widgets/custom_appbar.dart';
import 'package:employee_management/views/custom_widgets/menubar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController _dashboardController =
      Get.put(DashboardController());
  var firstDay = '';
  var lastDay = '';

  @override
  void initState() {
    getCurrentMonth();
    _dashboardController.getAverageTime(firstday: firstDay, lastday: lastDay);

    super.initState();
  }

  void getCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      firstDay =
          "${firstDayOfMonth.year}-${firstDayOfMonth.month}-${firstDayOfMonth.day}";
      lastDay =
          "${lastDayOfMonth.year}-${lastDayOfMonth.month}-${lastDayOfMonth.day}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> dashboardKey = GlobalKey();
    return Scaffold(
      key: dashboardKey,
      appBar: CustomAppBar(
        compaq: false,
        drawer: true,
        notification: false,
        scaffoldkey: dashboardKey,
        title: 'Dashboard',
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: GetBuilder<DashboardController>(builder: (controller) {
          return controller.averageDataAvailable.value
              ? controller.averageData.value.data!.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 0),
                          child: Card(
                            color: const Color(0xFFE5FFE5),
                            elevation: 1,
                            shadowColor: const Color(0xFFB8B8FF),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFF83FF83), width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              alignment: Alignment.center,
                              height: ((MediaQuery.of(context).size.width / 2) -
                                      20) *
                                  0.77,
                              width: (MediaQuery.of(context).size.width) - 30,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/images/avgtime.svg'),
                                  const Text(
                                    'Average Duration',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                      TimeFormatter().durationFormatter(
                                        controller.averageData.value.data!.first
                                            .avgDuration!,
                                      ),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: TimeFormatter().avgColor(
                                                  controller.averageData.value
                                                      .data!.first.avgDuration!)
                                              ? const Color(0xFFB00020)
                                              : Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                color: const Color(0xFFE5F3FF),
                                elevation: 0,
                                shadowColor: const Color(0xFFB8B8FF),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 0, 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFCACAFF),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height:
                                      ((MediaQuery.of(context).size.width / 2) -
                                              20) *
                                          0.77,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          20,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/intime.svg'),
                                      const Text('Average IN Time',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                          TimeFormatter().returnDate(controller
                                              .averageData
                                              .value
                                              .data!
                                              .first
                                              .avgInTime!),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: TimeFormatter().inTimeColor(
                                                      TimeFormatter()
                                                          .returnDate(controller
                                                              .averageData
                                                              .value
                                                              .data!
                                                              .first
                                                              .avgInTime!))
                                                  ? const Color(0xFFB00020)
                                                  : Colors.black))
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: const Color(0xFFFFF6E5),
                                elevation: 1,
                                shadowColor: const Color(0xFFFFE2AC),
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 0, 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFFFDFA5),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height:
                                      ((MediaQuery.of(context).size.width / 2) -
                                              20) *
                                          0.77,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          20,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/images/outtime.svg'),
                                      const Text('Average OUT Time',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                          TimeFormatter().returnDate(controller
                                              .averageData
                                              .value
                                              .data!
                                              .first
                                              .avgOutTime!),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: TimeFormatter().outTimeColor(
                                                      TimeFormatter()
                                                          .returnDate(controller
                                                              .averageData
                                                              .value
                                                              .data!
                                                              .first
                                                              .avgOutTime!))
                                                  ? const Color(0xFFB00020)
                                                  : Colors.black))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                      "NO DATA FOUND",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ))
              : SizedBox(
                  height: 200,
                  child: const Center(
                      child: CupertinoActivityIndicator(
                    radius: 15,
                    color: Colors.black45,
                  )),
                );
        }),
      ),
    );
  }
}
