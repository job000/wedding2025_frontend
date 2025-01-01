import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// API-klient for å håndtere nettverkskall
class ApiClient {
  late final Dio _dio;
  
  /// Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectionTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        responseType: ResponseType.json,
        headers: {
          ApiConstants.contentType: ApiConstants.applicationJson,
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      if (kDebugMode) LoggingInterceptor(),
    ]);
  }

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Error handling
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return TimeoutException(ApiConstants.timeoutError);
        case DioExceptionType.badResponse:
          return _handleResponseError(error.response?.statusCode);
        case DioExceptionType.connectionError:
          return NetworkException(ApiConstants.connectionError);
        default:
          return UnknownException('En ukjent feil oppstod');
      }
    }
    return UnknownException('En ukjent feil oppstod');
  }

  /// Handle response error based on status code
  Exception _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return BadRequestException('Ugyldig forespørsel');
      case 401:
        return UnauthorizedException(ApiConstants.unauthorizedError);
      case 403:
        return ForbiddenException('Ingen tilgang');
      case 404:
        return NotFoundException('Ressursen ble ikke funnet');
      case 500:
      case 501:
      case 502:
      case 503:
        return ServerException(ApiConstants.serverError);
      default:
        return UnknownException('En ukjent feil oppstod');
    }
  }
}

/// Custom exceptions
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}