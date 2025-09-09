import 'package:employee_management/controllers/homepageController.dart';
import 'package:employee_management/controllers/loginController.dart';
import 'package:employee_management/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  LoginController loginController = Get.find<LoginController>();
  bool expanded = false;
  @override
  void initState() {
    super.initState();
  }

  void attendanceTileExpandedStatus() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            centerTitle: false,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: Container(
                  color: Colors.black,
                  height: 2.0,
                )),
            leadingWidth: 40,
            leading: InkWell(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back_ios_new,
                    size: 18, color: Colors.white),
              ),
              onTap: () {
                Get.back();
              },
            ),
            title: const SizedBox(),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                dense: false,
                contentPadding: EdgeInsets.zero,
                title: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  height: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 30, top: 20),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/images/misfit_logo.svg',
                            height: 30,
                          )),
                      loginController.firebaseAuth.currentUser!.photoURL != null
                          ? CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(
                                  "${loginController.firebaseAuth.currentUser!.photoURL}"),
                              backgroundColor: Colors.transparent,
                            )
                          : const SizedBox.shrink(),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: loginController
                                    .firebaseAuth.currentUser!.displayName !=
                                null
                            ? Text(
                                "${loginController.firebaseAuth.currentUser!.displayName}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                minLeadingWidth: 2,
              ),
              ListTile(
                dense: true,
                title: const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 16),
                ),
                leading: SvgPicture.asset(
                  "assets/images/dashboardicon.svg",
                  height: 16,
                  color: Colors.black,
                ),
                minLeadingWidth: 0,
                onTap: () async {
                  if (Get.find<HomeController>().currentIndex.value == 0) {
                    Get.back();
                  } else {
                    Get.find<HomeController>().currentIndex.value = 0;
                    Get.find<HomeController>().update();
                    Get.offAllNamed(homepage, arguments: 0);
                    Get.back();
                  }
                },
              ),
              ListTile(
                dense: true,
                title: ExpansionPanelList(
                  expansionCallback: (int item, bool status) {
                    attendanceTileExpandedStatus();
                  },
                  elevation: 0,
                  children: [
                    ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.white,
                        headerBuilder: ((context, isExpanded) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/images/atn.svg",
                                height: 18,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Attendance',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        }),
                        isExpanded: expanded,
                        body: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (Get.find<HomeController>()
                                          .currentIndex
                                          .value ==
                                      1) {
                                    Get.back();
                                  } else {
                                    Get.find<HomeController>()
                                        .currentIndex
                                        .value = 1;
                                    Get.find<HomeController>().update();
                                    Get.offAllNamed(homepage, arguments: 1);
                                    Get.back();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/todayicon.svg",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Today',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (Get.find<HomeController>()
                                          .currentIndex
                                          .value ==
                                      2) {
                                    Get.back();
                                  } else {
                                    Get.find<HomeController>()
                                        .currentIndex
                                        .value = 2;
                                    Get.find<HomeController>().update();
                                    Get.offAllNamed(homepage, arguments: 2);
                                    Get.back();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/history.svg",
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Text(
                                      'History',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                minLeadingWidth: 2,
              ),
              ListTile(
                dense: true,
                title: const Text(
                  'Employees',
                  style: TextStyle(fontSize: 16),
                ),
                leading: SvgPicture.asset(
                  "assets/images/attendance.svg",
                  color: Colors.black,
                ),
                minLeadingWidth: 2,
                onTap: () async {
                  if (Get.find<HomeController>().currentIndex.value == 3) {
                    Get.back();
                  } else {
                    Get.find<HomeController>().currentIndex.value = 3;
                    Get.find<HomeController>().update();
                    Get.offAllNamed(homepage, arguments: 3);
                    Get.back();
                  }
                },
              ),
              ListTile(
                dense: true,
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
                leading: SvgPicture.asset("assets/images/logout.svg"),
                minLeadingWidth: 2,
                onTap: () async {
                  loginController.logout();
                },
              ),
            ],
          ),
        ));
  }
}
