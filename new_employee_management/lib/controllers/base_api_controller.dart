import 'package:dio/dio.dart';
import 'package:employee_management/controllers/interceptor.dart';
import 'package:employee_management/data/endpoints/endpoints.dart';
import 'package:get/get.dart';

class BaseApiController extends GetxController with StateMixin<dynamic> {
  

  static const String _contentType = 'Content-Type';

  
      
  Dio? _dio = Dio();

  BaseApiController() {
    BaseOptions dioOptions = BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 8),
      headers: {_contentType: 'application/json'},
    );

    _dio = Dio(dioOptions)
      ..interceptors.add(LoggingInterceptors(
        dio: getDio()!,
      ));
  }

  Dio? getDio() => _dio;

  /*String handleError(DioError error) {
    String errorDescription = "";

    switch (error.type) {
      case DioErrorType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioErrorType.unknown:
        errorDescription =
            "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        errorDescription =
            "Received status code: ${error.response!.statusCode}";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
    }
    return errorDescription;
  }*/
}
