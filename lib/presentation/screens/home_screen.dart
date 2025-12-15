import 'package:flutter/material.dart';
import 'student_home_screen.dart';
import 'teacher_home_screen.dart';

class HomeScreen extends StatefulWidget {
  final String role;
  final String token;

  const HomeScreen({super.key, required this.role, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.role == 'teacher') {
      return TeacherHomeScreen(token: widget.token);
    } else if (widget.role == 'student') {
      return StudentHomeScreen(token: widget.token);
    } else {
      return const Scaffold(body: Center(child: Text('Unauthorized Access')));
    }
  }
}
