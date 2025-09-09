import 'package:dio/dio.dart';
import 'package:employee_management/controllers/base_api_controller.dart';
import 'package:employee_management/data/endpoints/endpoints.dart';
import 'package:employee_management/data/models/attendance_model.dart';
import 'package:employee_management/data/models/average_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceController extends BaseApiController {
  RxList<AttendanceModelData> dashboardtData = <AttendanceModelData>[].obs;
  RxBool dashboardtDataAvailable = false.obs;
  Rx<AverageTime> averageData = AverageTime().obs;
  RxBool averageDataAvailable = false.obs;

  Future getAttendanceData() async {
    try {
      var response = await getDio()!.get(EndPoints.dashboarPath);
      AttendanceModel dashboard = AttendanceModel.fromJson(response.data);
      if (dashboard.success) {
        dashboardtData.clear();
        dashboardtData.addAll(dashboard.data);
        dashboardtDataAvailable.value = true;
        update();
        return dashboard;
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
