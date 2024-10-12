import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather/app/shared/constant/app_value.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:weather/app/shared/utils/utils.dart';

class DioManager {
  Dio? _dioInstance;

  Dio? get dio {
    _dioInstance ??= initDio();
    return _dioInstance;
  }

  Dio initDio() {
    final Dio dio = Dio(BaseOptions(
      baseUrl: AppValues.baseUrl,
      headers: <String, dynamic>{},

    ));

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        request: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
        maxWidth: 120,
      ));
    }
    return dio;
  }

  void update() => _dioInstance = initDio();

  Future<Response> get(String url,
      {Map<String, dynamic>? header, Map<String, dynamic>? json}) async {
    print('Making GET request to $url with parameters $json');
    return await dio!
        .get(url, queryParameters: json, options: Options(headers: header))
        .then((response) {
      print('Response received: ${response.data}');
      return response;
    }).catchError((error) {
      print('Error occurred: $error');
      errorToast(
          code: error.response?.statusCode?.toString() ?? "error",
          msg: error.response?.data?.toString() ?? "error ");
    });
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? header, dynamic data}) async {
    try {
      final response = await dio!.post(url, data: data, options: Options(headers: header));
      return response;
    } catch (error) {
      handleDioError(error);
      rethrow;
    }
  }

  Future<Response> put(String url,
      {Map<String, dynamic>? header, dynamic data}) async {
    try {
      final response = await dio!.put(url, data: data, options: Options(headers: header));
      return response;
    } catch (error) {
      handleDioError(error);
      rethrow;
    }
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? header, dynamic data}) async {
    try {
      final response = await dio!.delete(url, data: data, options: Options(headers: header));
      return response;
    } catch (error) {
      handleDioError(error);
      rethrow;
    }
  }

  void handleDioError(dynamic error) {
    if (error is DioError) {
      final statusCode = error.response?.statusCode ?? 'Unknown';
      final message = error.response?.data?.toString() ?? error.message;
      errorToast(code: statusCode.toString(), msg: message);
    } else {
      errorToast(code: 'Unknown', msg: error.toString());
    }
  }
}
