// lib/features/rsvp/presentation/providers/rsvp_provider.dart

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/rsvp.dart';

class RsvpProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  final AuthProvider _authProvider;
  final _storage = const FlutterSecureStorage();
  
  List<RSVP> _rsvps = [];
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  RsvpProvider({
    ApiClient? apiClient,
    required AuthProvider authProvider,
  })  : _apiClient = apiClient ?? ApiClient(),
        _authProvider = authProvider;

  List<RSVP> get rsvps => _rsvps;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isInitialized => _isInitialized;

  Future<String?> _getAuthHeader() async {
    if (!_authProvider.isAuthenticated) {
      _setError('Du må være innlogget for å administrere RSVPer');
      return null;
    }
    
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token != null ? '${ApiConstants.bearer} $token' : null;
    } else {
      final token = await _storage.read(key: 'auth_token');
      return token != null ? '${ApiConstants.bearer} $token' : null;
    }
  }

  Future<void> fetchRsvps() async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);

      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      final response = await _apiClient.get(
        ApiConstants.getRsvps,
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
          },
        ),
      );
      
      if (response.data is List) {
        _rsvps = (response.data as List)
            .map((item) => RSVP.fromJson(item))
            .toList();
        // Sort by creation date if available
        // _rsvps.sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);
      } else {
        throw ApiConstants.invalidResponseFormat;
      }

      _isInitialized = true;
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createRsvp({
    required String name,
    required String email,
    required bool attending,
    String? allergies,
  }) async {
    try {
      _setLoading(true);

      final response = await _apiClient.post(
        ApiConstants.createRsvp,
        data: {
          'name': name,
          'email': email,
          'attending': attending,
          'allergies': allergies,
        },
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
          },
        ),
      );

      if (response.statusCode == 201) {
        await fetchRsvps();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateRsvp(
    int id, {
    bool? attending,
    String? allergies,
  }) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);

      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      await _apiClient.put(
        ApiConstants.updateRsvp(id),
        data: {
          if (attending != null) 'attending': attending,
          if (allergies != null) 'allergies': allergies,
        },
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
          },
        ),
      );
      
      await fetchRsvps();
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteRsvp(int id) async {
    if (_isLoading) return;
    
    try {
      _setLoading(true);

      final authHeader = await _getAuthHeader();
      if (authHeader == null) return;

      await _apiClient.delete(
        ApiConstants.deleteRsvp(id),
        options: Options(
          headers: {
            ApiConstants.contentType: ApiConstants.applicationJson,
            ApiConstants.authorization: authHeader,
          },
        ),
      );
      
      _rsvps.removeWhere((rsvp) => rsvp.id == id);
      notifyListeners();
    } on DioException catch (e) {
      _handleError(e);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
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
    _rsvps = [];
    _isInitialized = false;
    super.dispose();
  }
}