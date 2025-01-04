import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/gallery_media_model.dart';

class GalleryProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  final AuthProvider _authProvider;
  
  List<GalleryMediaModel> _mediaList = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;
  
  GalleryProvider({
    ApiClient? apiClient,
    required AuthProvider authProvider,
  }) : _apiClient = apiClient ?? ApiClient(),
       _authProvider = authProvider;

  List<GalleryMediaModel> get mediaList => _mediaList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  Future<String?> _getAuthHeader() async {
    if (!_authProvider.isAuthenticated) {
      _setError('Du må være innlogget for å bruke galleriet');
      return null;
    }
    
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null ? '${ApiConstants.bearer} $token' : null;
    } else {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      return token != null ? '${ApiConstants.bearer} $token' : null;
    }
  }

 Future<void> fetchGalleryMedia({bool forceRefresh = false}) async {
  if (_isLoading) return;
  
  try {
    _setLoading(true);
    _error = null;

    final authHeader = await _getAuthHeader();
    if (authHeader == null) return;

    final headers = {
      ApiConstants.contentType: ApiConstants.applicationJson,
      ApiConstants.authorization: authHeader,
      'Pragma': 'no-cache',
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Expires': '0',
    };

    final response = await _apiClient.get(
      ApiConstants.getGallery,
      options: Options(headers: headers),
    );
    
    if (response.data is List) {
      _mediaList = (response.data as List)
          .map((item) => GalleryMediaModel.fromJson(item))
          .toList();
      _mediaList.sort((a, b) => b.uploadTime.compareTo(a.uploadTime));
      _isInitialized = true;
    } else {
      throw 'Invalid response format';
    }
  } catch (e) {
    _error = e is DioException ? _getDioErrorMessage(e) : e.toString();
  } finally {
    _setLoading(false);
    notifyListeners();
  }
}

String _getDioErrorMessage(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return ApiConstants.timeoutError;
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 401:
          return ApiConstants.unauthorizedError;
        case 500:
          return ApiConstants.serverError;
        default:
          return e.message ?? ApiConstants.unexpectedError;
      }
    case DioExceptionType.connectionError:
      return ApiConstants.connectionError;
    default:
      return e.message ?? ApiConstants.serverError;
  }
}


Future<void> uploadMedia({
  required dynamic file,
  required String filename,
  required String title,
  String? description,
  String? mediaType,
  String? visibility,
  List<String>? tags,
}) async {
  if (_isLoading) return;
  
  try {
    _setLoading(true);
    _error = null;

    final authHeader = await _getAuthHeader();
    if (authHeader == null) return;

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file is Uint8List ? file : await file.readAsBytes(),
        filename: filename,
      ),
      'title': title,
      'media_type': mediaType ?? 'image',
      'description': description,
      'visibility': visibility ?? 'public',
      'tags': tags ?? ['bryllup'],
    });

    await _apiClient.post(
      ApiConstants.uploadMedia,
      data: formData,
      options: Options(
        headers: {
          ApiConstants.contentType: ApiConstants.multipartFormData,
          ApiConstants.authorization: authHeader,
          'Pragma': 'no-cache',
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Expires': '0',
        },
      ),
    );

    await fetchGalleryMedia(forceRefresh: true);
  } catch (e) {
    _error = e is DioException ? _getDioErrorMessage(e) : e.toString();
    rethrow;
  } finally {
    _setLoading(false);
    notifyListeners();
  }
}
  
  Future<void> likeMedia(int mediaId) async {
    if (_isLoading) return;
    
    try {
      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      await _apiClient.post(
        ApiConstants.likeMedia(mediaId),
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
            ApiConstants.cacheControl: ApiConstants.noCache,
          },
        ),
      );
      
      await fetchGalleryMedia(forceRefresh: true);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> addComment(int mediaId, String comment) async {
    if (_isLoading) return;
    
    try {
      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      await _apiClient.post(
        ApiConstants.addComment(mediaId),
        data: {'comment': comment},
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
            ApiConstants.cacheControl: ApiConstants.noCache,
          },
        ),
      );
      
      await fetchGalleryMedia(forceRefresh: true);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> deleteMedia(int mediaId) async {
    if (_isLoading) return;
    
    try {
      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      await _apiClient.delete(
        ApiConstants.deleteMedia(mediaId),
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
            ApiConstants.cacheControl: ApiConstants.noCache,
          },
        ),
      );
      
      await fetchGalleryMedia(forceRefresh: true);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _error = null;
    notifyListeners();
  }

  void _setError(String errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  void _handleError(DioException e) {
    String errorMessage;
    
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = ApiConstants.timeoutError;
        break;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 401:
            errorMessage = ApiConstants.unauthorizedError;
            break;
          case 500:
            errorMessage = ApiConstants.serverError;
            break;
          default:
            errorMessage = e.message ?? ApiConstants.unexpectedError;
        }
        break;
      case DioExceptionType.connectionError:
        errorMessage = ApiConstants.connectionError;
        break;
      default:
        errorMessage = e.message ?? ApiConstants.serverError;
    }
    
    _setError(errorMessage);
  }

  @override
  void dispose() {
    _mediaList = [];
    _isInitialized = false;
    super.dispose();
  }
}