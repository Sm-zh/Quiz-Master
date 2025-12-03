import '../data_sources/auth_data_source.dart';
import '../models/user.dart';

class TokenStorage {
  String? _token;
  Future<void> saveToken(String token) async => _token = token;
  Future<String?> getToken() async => _token;
}

class AuthRepository {
  final AuthDataSource authDataSource;
  final TokenStorage tokenStorage;

  AuthRepository(this.authDataSource, this.tokenStorage);

  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final user = await authDataSource.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    if (user.token != null) {
      await tokenStorage.saveToken(user.token!);
    }
    return user;
  }

  Future<User> login({required String email, required String password}) async {
    final user = await authDataSource.login(email: email, password: password);
    if (user.token != null) {
      await tokenStorage.saveToken(user.token!);
    }
    return user;
  }

  Future<String?> getAuthToken() => tokenStorage.getToken();
}
