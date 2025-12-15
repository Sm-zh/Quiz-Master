import '../models/user.dart';
import 'base_data_source.dart';

class AuthDataSource {
  final HttpClient client;

  AuthDataSource(this.client);

  // POST /auth/register
  Future<User> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await client.post(
      '$BASE_URL/auth/register',
      body: {'name': name, 'email': email, 'password': password, 'role': role},
    );

    final userJson = response['user'] ?? response;

    return User.fromJson({
      'id': userJson['id'] ?? userJson['_id'],
      'name': userJson['name'],
      'email': userJson['email'],
      'role': userJson['role'],
      'token': response['token'],
    });
  }

  // POST /auth/login
  Future<User> login({required String email, required String password}) async {
    final response = await client.post(
      '$BASE_URL/auth/login',
      body: {'email': email, 'password': password},
    );

    final userJson = response['user'] ?? response;

    return User.fromJson({
      'id': userJson['id'] ?? userJson['_id'],
      'name': userJson['name'],
      'email': userJson['email'],
      'role': userJson['role'],
      'token': response['token'],
    });
  }
}
