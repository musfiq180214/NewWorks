// import 'dart:math';

import 'package:dio/dio.dart';
import 'package:employee_management/controllers/base_api_controller.dart';
import 'package:employee_management/data/endpoints/endpoints.dart';
import 'package:employee_management/data/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeController extends BaseApiController {
  RxList<EmployeeListData> employeeListData = <EmployeeListData>[].obs;
  RxBool employeeListDataAvailable = false.obs;

  Future getEmployeeData() async {
    try {
      var response = await getDio()!
          .get(EndPoints.employeeListPath, queryParameters: {'per_page': 50});
      EmployeeList employeeList = EmployeeList.fromJson(response.data);
      if (employeeList.success) {
        employeeListData.clear();
        employeeListData.addAll(employeeList.data);
        employeeListDataAvailable.value = true;
        update();
        return employeeList;
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data ?? e.message ?? "Unknown error";
      Get.snackbar(
        "Failed to load data",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  Future getSearchedEmployeeData({searchedText}) async {
    print(searchedText);
    try {
      var response = await getDio()!
          .get(EndPoints.employeeListPath, queryParameters: {'per_page': 50});
      EmployeeList employeeList = EmployeeList.fromJson(response.data);
      if (employeeList.success) {
        employeeListData.clear();
        for (var element in employeeList.data) {
          employeeListData.addIf(
              element.name.toLowerCase().contains(searchedText), element);
          print('object:::::' "${employeeListData.length}");
        }
        employeeListDataAvailable.value = true;
        update();
        return employeeList;
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
