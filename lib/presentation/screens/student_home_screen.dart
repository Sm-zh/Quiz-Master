import 'package:flutter/material.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QuizMaster',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: Drawer(),
      body: Container(
        height: double.infinity,
        color: Colors.grey[400],
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [Text('My Quizzes', style: TextStyle(fontSize: 24))],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 64),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff2c2c2c),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Join a Quiz',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
