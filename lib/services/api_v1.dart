import 'dart:io';


import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shopos/src/config/const.dart';

import '../config/const.dart';


class ApiV1Service {
  static final Dio _dio = Dio(
    BaseOptions(
      contentType: 'application/json',
      baseUrl: Const.apiUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 50000),
    ),
  );
  const ApiV1Service();


  ///
  static Future<Response> postRequest(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    return await _dio.post(url, data: formData ?? data);
  }

  ///
  static Future<Response> getRequest(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(url, queryParameters: queryParameters);
  }

  ///
  static Future<Response> putRequest(
    String url, {
    Map<String, dynamic>? data,
    FormData? formData,
  }) async {
    return await _dio.put(url, data: formData ?? data);
  }

  ///
  static Future<Response> deleteRequest(String url,
      {Map<String, dynamic>? data}) async {
    return await _dio.delete(url);
  }
}
