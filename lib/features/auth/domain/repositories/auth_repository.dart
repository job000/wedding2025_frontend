abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> register(String username, String password);
}