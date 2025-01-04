// gallery_provider.dart

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
      debugPrint('Token gallery: $token');
      return token != null ? '${ApiConstants.bearer} $token' : null;
    } else {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      return token != null ? '${ApiConstants.bearer} $token' : null;
    }
  }

  Future<void> fetchGalleryMedia() async {
    if (_isLoading) return; // Prevent parallel API calls
    
    try {
      _setLoading(true);

      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      final response = await _apiClient.get(
        ApiConstants.getGallery,
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
          },
        ),
      );
      
      if (response.data is List) {
        _mediaList = (response.data as List)
            .map((item) => GalleryMediaModel.fromJson(item))
            .toList();
        _mediaList.sort((a, b) => b.uploadTime.compareTo(a.uploadTime));
      } else {
        throw ApiConstants.invalidResponseFormat;
      }

      _isInitialized = true;
      _setLoading(false);
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> uploadMedia({
    required dynamic file,
    required String filename,
    required String uploadedBy,
  }) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);

      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      FormData formData;
      
      if (kIsWeb) {
        final bytes = file is Uint8List 
            ? file 
            : await file.readAsBytes();
            
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            bytes,
            filename: filename,
          ),
          'title': 'Bilde fra bryllupet',
          'media_type': 'image',
          'description': 'Lastet opp av $uploadedBy',
          'uploaded_by': uploadedBy,
          'tags': ['bryllup'],
          'visibility': 'public',
        });
      } else {
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(
            file is Uint8List ? file : await file.readAsBytes(),
            filename: filename,
          ),
          'title': 'Bilde fra bryllupet',
          'media_type': 'image',
          'description': 'Lastet opp av $uploadedBy',
          'uploaded_by': uploadedBy,
          'tags': ['bryllup'],
          'visibility': 'public',
        });
      }

      await _apiClient.post(
        ApiConstants.uploadMedia,
        data: formData,
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.multipartFormData,
            ApiConstants.authorization: authHeader,
          },
        ),
      );

      await fetchGalleryMedia();
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      _setError(e.toString());
      rethrow;
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
          },
        ),
      );
      
      await fetchGalleryMedia();
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
          },
        ),
      );
      
      await fetchGalleryMedia();
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
          },
        ),
      );
      
      await fetchGalleryMedia();
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

