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
    return User.fromJson(response);
  }

  // POST /auth/login
  Future<User> login({required String email, required String password}) async {
    final response = await client.post(
      '$BASE_URL/auth/login',
      body: {'email': email, 'password': password},
    );
    return User.fromJson({
      'id': response['user']['id'],
      'name': response['user']['id'],
      'email': response['user']['email'],
      'role': response['user']['role'],
      'token': response['token'],
    });
  }
}
