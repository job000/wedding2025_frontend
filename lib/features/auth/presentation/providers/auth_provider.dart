import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  User? _currentUser;  // Legg til dette

  AuthProvider({
    AuthRepository? authRepository,
    FlutterSecureStorage? storage,
  })  : _authRepository = authRepository ?? AuthRepositoryImpl(),
        _storage = storage ?? const FlutterSecureStorage();

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
   User? get currentUser => _currentUser;  

  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final token = await _authRepository.login(username, password);
      await _storage.write(key: 'auth_token', value: token);

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return false;
    }
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

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'auth_token');
    _isAuthenticated = token != null;
    notifyListeners();
  }
}