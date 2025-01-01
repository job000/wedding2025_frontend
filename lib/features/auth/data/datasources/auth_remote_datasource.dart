import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String username, String password);
  Future<void> register(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> register(String username, String password) async {
    try {
      await _apiClient.post(
        ApiConstants.register,
        data: {
          'username': username,
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Forespørselen tok for lang tid');
      case DioExceptionType.badResponse:
        return _handleResponseError(e.response?.statusCode);
      case DioExceptionType.connectionError:
        return NetworkException('Ingen internettforbindelse');
      default:
        return UnknownException('En ukjent feil oppstod');
    }
  }

  Exception _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return BadRequestException('Ugyldig forespørsel');
      case 401:
        return UnauthorizedException('Ugyldig brukernavn eller passord');
      default:
        return ServerException('En serverfeil oppstod');
    }
  }
}