import 'package:employee_management/controllers/employeeController.dart';
import 'package:employee_management/utils/routes.dart';
import 'package:employee_management/views/Employee/employeeItem.dart';
import 'package:employee_management/views/custom_widgets/custom_appbar.dart';
import 'package:employee_management/views/custom_widgets/menubar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final EmployeeController _employeeController = Get.put(EmployeeController());
  final search_controller = TextEditingController();

  @override
  void initState() {
    _employeeController.getEmployeeData();
    search_controller.addListener(searchListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> employeeListKey = GlobalKey();
    return Scaffold(
      key: employeeListKey,
      appBar: CustomAppBar(
        compaq: false,
        drawer: true,
        notification: false,
        scaffoldkey: employeeListKey,
        title: 'Employee List',
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: TextField(
                controller: search_controller,
                keyboardType: TextInputType.name,
                style: const TextStyle(fontSize: 14.0),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.fromLTRB(30.0, 5.0, 5.0, 5.0),
                  hintText: "Search Employee",
                  suffixIcon: const Icon(Icons.search_sharp),
                  hintStyle:
                      const TextStyle(fontSize: 14.0, color: Color(0xFF616161)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFFBBBBBB), width: 1.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: GetBuilder<EmployeeController>(builder: (controller) {
                return controller.employeeListDataAvailable.value
                    ? controller.employeeListData.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.employeeListData.length,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(employeeDetailPage,
                                      arguments: controller.employeeListData
                                          .elementAt(index));
                                },
                                child: EmployeeItem(
                                  item: controller.employeeListData
                                      .elementAt(index),
                                ),
                              );
                            })
                        : const SizedBox(
                            child: Text(
                            "NO EMPLOYEE FOUND",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ))
                    : const Center(
                        heightFactor: 10,
                        child: CupertinoActivityIndicator(
                          radius: 15,
                          color: Colors.black45,
                        ));
              }),
            )
          ],
        ),
      ),
    );
  }

  void searchListener() {
    if (kDebugMode) {
      print('text field: ${search_controller.text}');
    }
    if (search_controller.text.length >= 3) {
      _employeeController.getSearchedEmployeeData(
          searchedText: search_controller.text.toLowerCase());
    } else {
      _employeeController.getEmployeeData();
    }
  }
}
