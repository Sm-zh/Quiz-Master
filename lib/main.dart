import 'package:flutter/material.dart';

import 'data/data_repository/auth_repository.dart';
import 'data/data_sources/auth_data_source.dart';
import 'data/data_sources/base_data_source.dart';
import 'presentation/screens/login_screen.dart';

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
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff2c2c2c)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2c2c2c),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: LoginScreen(authRepository: authRepository),
    );
  }
}
