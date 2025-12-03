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
    return widget.role == 'teacher'
        ? TeacherHomeScreen(token: widget.token)
        : widget.role == 'student'
        ? StudentHomeScreen()
        : Center(child: Text('Unauthorized Access'));
  }
}
