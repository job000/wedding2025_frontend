import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _secureStorage;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  User? _currentUser;

  AuthProvider({
    AuthRepository? authRepository,
  })  : _authRepository = authRepository ?? AuthRepositoryImpl(),
        _secureStorage = const FlutterSecureStorage();

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;




Future<bool> login(String username, String password) async {
  try {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Hent JWT-token direkte fra backend
    final token = await _authRepository.login(username, password);
    print('Raw JWT token from backend: $token');

    if (token.isEmpty) {
      throw Exception('Mottatt JWT-token er tomt.');
    }

    // Lagre token
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } else {
      await _secureStorage.write(key: 'auth_token', value: token);
    }

    // Oppdater autentiseringsstatus
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    print('Login error: $e');
    _error = 'Login feilet: ${e.toString()}';
    _isLoading = false;
    _isAuthenticated = false;
    notifyListeners();
    return false;
  }
}





  Future<void> logout() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } else {
      await _secureStorage.delete(key: 'auth_token');
    }
    _isAuthenticated = false;
    _currentUser = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    String? token;
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('auth_token');
    } else {
      token = await _secureStorage.read(key: 'auth_token');
    }
    _isAuthenticated = token != null;
    notifyListeners();
  }



  Future<bool> register(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authRepository.register(username, password);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

}