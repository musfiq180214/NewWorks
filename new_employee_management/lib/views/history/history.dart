import 'package:employee_management/controllers/historyController.dart';
import 'package:employee_management/utils/timeFormatter.dart';
import 'package:employee_management/views/custom_widgets/custom_appbar.dart';
import 'package:employee_management/views/custom_widgets/menubar.dart';
import 'package:employee_management/views/history/historyItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController _historyController = Get.put(HistoryController());
  final datePickerField = TextEditingController();
  var firstDay = '';
  var lastDay = '';
  var month = '';
  var year = '';
  DateTime? _selected;
  var initialDate = '';
  bool monthSelected = false;
  String selectedDate = '';

  Future<void> _onPressed({
    required BuildContext context,
  }) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime.now(),
      locale: const Locale("en"),
    );

    if (selected != null) {
      setState(() {
        monthSelected = true;
        _selected = selected;
        year = DateFormat().add_y().format(_selected!);
        month = DateFormat().add_M().format(_selected!);
        DateTime firstDayOfMonth =
            DateTime(int.parse(year), int.parse(month), 1);
        DateTime lastDayOfMonth =
            DateTime(int.parse(year), int.parse(month) + 1, 0);

        selectedDate = DateFormat('MMMM, y').format(_selected!);
        if (kDebugMode) {
          print('formatted month::$selectedDate');
        }

        firstDay =
            "${firstDayOfMonth.year}/${firstDayOfMonth.month}/${firstDayOfMonth.day}";
        lastDay =
            "${lastDayOfMonth.year}/${lastDayOfMonth.month}/${lastDayOfMonth.day}";

        datePickerField.text = selectedDate;
        _historyController.getAverageTime(firstday: firstDay, lastday: lastDay);
        _historyController.averageDataAvailable.value = false;
        _historyController.monthWiseDataAvailable.value = false;
        _historyController
            .getMonthWiseData(startDay: firstDay, endDay: lastDay)
            .then((value) => _historyController.update());
      });
    }
  }

  @override
  void initState() {
    getCurrentMonth();
    _historyController.getAverageTime(firstday: firstDay, lastday: lastDay);
    _historyController.getMonthWiseData(startDay: firstDay, endDay: lastDay);
    initialDate = DateFormat('MMMM, y').format(DateTime.now());

    super.initState();
  }

  void getCurrentMonth() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      firstDay =
          "${firstDayOfMonth.year}/${firstDayOfMonth.month}/${firstDayOfMonth.day}";
      lastDay =
          "${lastDayOfMonth.year}/${lastDayOfMonth.month}/${lastDayOfMonth.day}";

      if (kDebugMode) {
        print("first day::::$firstDay");
      }
      if (kDebugMode) {
        print("last day::::$lastDay");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> historyKey = GlobalKey();
    return Scaffold(
      key: historyKey,
      appBar: CustomAppBar(
        compaq: false,
        drawer: true,
        notification: false,
        scaffoldkey: historyKey,
        title: 'History',
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 15, 10, 0),
              child: Text(
                monthSelected
                    ? "Summary of " "$selectedDate"
                    : "Summary of " "$initialDate",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            GetBuilder<HistoryController>(builder: (controller) {
              return controller.averageDataAvailable.value
                  ? controller.averageData.value.data!.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                color: const Color(0xFFE5F3FF),
                                elevation: 5,
                                shadowColor: const Color(0xFFB8B8FF),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFCACAFF),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * .29,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Average\nIN Time',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                                                    TimeFormatter().returnDate(
                                                        controller
                                                            .averageData
                                                            .value
                                                            .data!
                                                            .first
                                                            .avgInTime!))
                                                ? const Color(0xFFB00020)
                                                : Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                color: const Color(0xFFFFF6E5),
                                elevation: 5,
                                shadowColor: const Color(0xFFFFE2AC),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFFFDFA5),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * .29,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Average\nOUT Time',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                              Card(
                                color: const Color(0xFFE5FFE5),
                                elevation: 5,
                                shadowColor: const Color(0xFFB8B8FF),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF83FF83),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  alignment: Alignment.center,
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * .29,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Average\nDuration',
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          TimeFormatter().durationFormatter(
                                              controller.averageData.value.data!
                                                  .first.avgDuration!),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: TimeFormatter().avgColor(
                                                      controller
                                                          .averageData
                                                          .value
                                                          .data!
                                                          .first
                                                          .avgDuration!)
                                                  ? const Color(0xFFB00020)
                                                  : Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink()
                  : SizedBox(
                      height: 120,
                      child: const Center(
                          child: CupertinoActivityIndicator(
                        radius: 15,
                        color: Colors.black45,
                      )),
                    );
            }),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "History",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 190,
                    child: TextField(
                      textAlign: TextAlign.left,
                      obscureText: false,
                      controller: datePickerField,
                      keyboardType: TextInputType.datetime,
                      style: const TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                            color: Color(0xFF616161)),
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                          color: Colors.black54,
                        ),
                        hintText: initialDate,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: Color(0xFF616161), width: 2.0),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _onPressed(context: context);
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: GetBuilder<HistoryController>(builder: (controller) {
                return controller.monthWiseDataAvailable.value
                    ? controller.monthWiseData.isNotEmpty
                        ? ListView.builder(
                            itemCount: controller.monthWiseData.length,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              return HistoryItem(
                                item: controller.monthWiseData.elementAt(index),
                              );
                            })
                        : const Center(
                            heightFactor: 2,
                            child: Text(
                              'NO DATA AVAILABLE',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ))
                    : SizedBox(
                        height: 300,
                        child: const Center(
                            child: CupertinoActivityIndicator(
                          radius: 15,
                          color: Colors.black45,
                        )),
                      );
              }),
            )
          ],
        ),
      ),
    );
  }
}
