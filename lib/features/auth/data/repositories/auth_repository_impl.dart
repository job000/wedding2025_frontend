import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl();

  @override
  Future<String> login(String username, String password) async {
    final response = await _remoteDataSource.login(username, password);
    return response.accessToken;
  }

  @override
  Future<void> register(String username, String password) async {
    await _remoteDataSource.register(username, password);
  }
}