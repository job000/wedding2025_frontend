// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

/// Interceptor for logging av nettverkskall
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final httpMethod = options.method.toUpperCase();
    final url = options.baseUrl + options.path;
    
    print('┌------------------------------------------------------------------------------');
    print('| 🌐 HTTP Request - ${DateTime.now()}');
    print('| $httpMethod $url');
    print('| Headers:');
    options.headers.forEach((key, value) {
      print('| $key: $value');
    });

    if (options.queryParameters.isNotEmpty) {
      print('| Query Parameters:');
      options.queryParameters.forEach((key, value) {
        print('| $key: $value');
      });
    }

    if (options.data != null) {
      print('| Body: ${options.data}');
    }
    
    print('└------------------------------------------------------------------------------');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print('┌------------------------------------------------------------------------------');
    print('| ✅ HTTP Response - ${DateTime.now()}');
    print('| Status Code: ${response.statusCode}');
    print('| Data: ${response.data}');
    print('└------------------------------------------------------------------------------');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    print('┌------------------------------------------------------------------------------');
    print('| ❌ HTTP Error - ${DateTime.now()}');
    print('| ${err.error}');
    print('| Type: ${err.type}');
    print('| Message: ${err.message}');
    if (err.response != null) {
      print('| Status Code: ${err.response?.statusCode}');
      print('| Data: ${err.response?.data}');
    }
    print('└------------------------------------------------------------------------------');
    handler.next(err);
  }
}