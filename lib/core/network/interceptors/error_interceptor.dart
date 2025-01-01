import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';

/// Interceptor for å håndtere feil
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final DioException modifiedError = _createModifiedError(err);
    handler.next(modifiedError);
  }

  DioException _createModifiedError(DioException originalError) {
    String errorMessage;
    
    switch (originalError.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = ApiConstants.timeoutError;
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleResponseError(originalError.response?.statusCode);
        break;
      case DioExceptionType.connectionError:
        errorMessage = ApiConstants.connectionError;
        break;
      default:
        errorMessage = 'En ukjent feil oppstod';
        break;
    }

    return DioException(
      requestOptions: originalError.requestOptions,
      response: originalError.response,
      type: originalError.type,
      error: errorMessage,
      message: errorMessage,
    );
  }

  String _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Ugyldig forespørsel';
      case 401:
        return ApiConstants.unauthorizedError;
      case 403:
        return 'Ingen tilgang';
      case 404:
        return 'Ressursen ble ikke funnet';
      case 500:
      case 501:
      case 502:
      case 503:
        return ApiConstants.serverError;
      default:
        return 'En ukjent feil oppstod';
    }
  }
}