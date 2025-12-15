import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/auth_repository.dart';
import 'package:quiz_master/data/models/user.dart';
import 'package:quiz_master/presentation/screens/student_home_screen.dart';
import 'package:quiz_master/presentation/screens/teacher_home_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  final AuthRepository authRepository;

  const HomeScreen({
    super.key,
    required this.user,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    if (user.role == 'teacher') {
      return TeacherHomeScreen(user: user, authRepository: authRepository);
    }

    if (user.role == 'student') {
      return StudentHomeScreen(user: user, authRepository: authRepository);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text('Unknown role: ${user.role}')),
    );
  }
}
