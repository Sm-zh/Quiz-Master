import '../data_sources/auth_data_source.dart';
import '../models/user.dart';

class TokenStorage {
  String? _token;

  Future<void> saveToken(String token) async {
    _token = token;
  }

  Future<String?> getToken() async {
    return _token;
  }

  Future<void> clearToken() async {
    _token = null;
  }
}

class AuthRepository {
  final AuthDataSource _authDataSource;
  final TokenStorage _tokenStorage;

  AuthRepository(this._authDataSource, this._tokenStorage);

  Future<User> login(String email, String password) async {
    final user = await _authDataSource.login(email: email, password: password);

    // ✅ Fix: user.token is String? so ensure it's not null
    final token = user.token;
    if (token == null || token.isEmpty) {
      throw Exception(
        'Login succeeded but token is missing from API response.',
      );
    }

    await _tokenStorage.saveToken(token);
    return user;
  }

  Future<User> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final user = await _authDataSource.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    // ✅ Fix: user.token is String? so ensure it's not null
    final token = user.token;
    if (token == null || token.isEmpty) {
      throw Exception(
        'Registration succeeded but token is missing from API response.',
      );
    }

    await _tokenStorage.saveToken(token);
    return user;
  }

  Future<void> signOut() async {
    await _tokenStorage.clearToken();
  }
}
