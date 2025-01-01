import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constants/api_constants.dart';

/// Interceptor for å håndtere autentisering
class AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip authentication for login and register
    if (options.path == ApiConstants.login || 
        options.path == ApiConstants.register) {
      return handler.next(options);
    }

    try {
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        options.headers[ApiConstants.authorization] = 
            '${ApiConstants.bearer} $token';
      }
    } catch (e) {
      print('Error reading token: $e');
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 errors (unauthorized)
    if (err.response?.statusCode == 401) {
      try {
        await _storage.delete(key: 'auth_token');
        // TODO: Implement navigation to login screen or token refresh
      } catch (e) {
        print('Error deleting token: $e');
      }
    }
    return handler.next(err);
  }
}