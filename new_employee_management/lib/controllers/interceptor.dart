import 'dart:async';
// import 'dart:io';

import 'package:dio/dio.dart';
import 'package:employee_management/utils/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as pref;

import '../data/sharefPref/sharedpref.dart';

class LoggingInterceptors extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;
  final SharedPref _sharedPref = SharedPref();
  final Dio dio;

  LoggingInterceptors({required this.dio});

  Future<String> getToken() async {
    var token = await _sharedPref.readString("authToken") ?? "";
    return token;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await getToken().then(
      (value) =>
          options.headers.addIf(value.isNotEmpty, "Authorization", value),
    );
    options.headers.addIf(true, "Request-Source", "app");
    debugPrint("--> ${options.method} ${options.baseUrl}${options.path}");
    debugPrint("Content type: ${options.contentType}");
    debugPrint("QueryParams: ${options.queryParameters}");
    debugPrint("Headers: ${options.headers}");
    debugPrint("Data: ${options.data}");
    handler.next(options); // Updated to use handler
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("<-- STATUS : ${response.statusCode}");
    String responseAsString = response.data.toString();
    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        debugPrint(
          responseAsString.substring(i * maxCharactersPerLine, endingIndex),
        );
      }
    } else {
      debugPrint(response.data.toString());
    }
    debugPrint("<-- END HTTP");
    handler.next(response); // Updated to use handler
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    debugPrint(
      "ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.baseUrl}${error.requestOptions.path}",
    );
    if (error.response?.statusCode == 401) {
      _sharedPref.remove('authToken');
      pref.Get.toNamed(signinpage);
    }
    handler.next(error); // Updated to use handler
  }
}

class DioConnectivityRequestRetrier {
  final Dio dio;

  //final Connectivity connectivity;

  DioConnectivityRequestRetrier({
    required this.dio,
    // required this.connectivity,
  });
}
