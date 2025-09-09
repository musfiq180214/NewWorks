import 'package:dio/dio.dart';
import 'package:employee_management/controllers/base_api_controller.dart';
import 'package:employee_management/data/endpoints/endpoints.dart';
import 'package:employee_management/data/models/attendanceTime.dart';
import 'package:employee_management/data/models/average_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends BaseApiController {
  RxList<AttendanceTimeData> attendanceData = <AttendanceTimeData>[].obs;
  RxBool attendancetimeDataAvailable = false.obs;
  //RxList<AverageTimeData> averageData = <AverageTimeData>[].obs;
  Rx<AverageTime> averageData = AverageTime().obs;
  RxBool averageDataAvailable = false.obs;

  Future getAttendanceTime() async {
    try {
      var response = await getDio()!.get(EndPoints.attendencesPath);
      AttendanceTime avgtime = AttendanceTime.fromJson(response.data);
      if (avgtime.success) {
        attendanceData.addAll(avgtime.data);
        attendancetimeDataAvailable.value = true;
        update();
        return avgtime;
      }
    } on DioException catch (e) {
      Get.snackbar("Failed to load data", e.response!.data,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10));
    }
  }

  Future getAverageTime({firstday, lastday}) async {
    try {
      var response = await getDio()!.get(EndPoints.avgAttendecPath,
          queryParameters: {'start_date': firstday, 'end_date': lastday});
      AverageTime avgtime = AverageTime.fromJson(response.data);
      if (avgtime.success!) {
        averageData.value = avgtime;
        averageDataAvailable.value = true;
        update();
        return avgtime;
      }
    } on DioException catch (e) {
      Get.snackbar("Failed to load data", e.response!.data,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10));
    }
  }
}
