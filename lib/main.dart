import 'package:flutter/material.dart';
import '../data/data_repository/auth_repository.dart';
import '../presentation/screens/login_screen.dart';
import 'data/data_sources/auth_data_source.dart';
import 'data/data_sources/base_data_source.dart';

void main() {
  final httpClient = HttpClient();
  final tokenStorage = TokenStorage();
  final authDataSource = AuthDataSource(httpClient);
  final authRepository = AuthRepository(authDataSource, tokenStorage);
  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuizMaster',
      initialRoute: '/',
      routes: {'/': (_) => LoginScreen(authRepository: authRepository)},
    );
  }
}
