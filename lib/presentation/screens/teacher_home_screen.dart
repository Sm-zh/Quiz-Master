import 'package:flutter/material.dart';
import '../../data/data_sources/base_data_source.dart';
import '../../data/data_sources/quiz_data_sources.dart';
import '../../data/models/quiz.dart';
import 'create_quiz_screen.dart';
import '../../data/data_repository/quiz_repository.dart';
import '../widgets/teacher_quiz_widget.dart';

class TeacherHomeScreen extends StatefulWidget {
  final String token;
  const TeacherHomeScreen({super.key, required this.token});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  List<Quiz>? _quizzes;
  String? _errorMessage;
  late final QuizRepository _quizRepository = QuizRepository(
    widget.token,
    QuizDataSource(HttpClient(), token: widget.token),
  );

  @override
  void initState() {
    super.initState();
    _getQuizzes();
  }

  Future<void> _getQuizzes() async {
    setState(() {
      _quizzes = null;
      _errorMessage = null;
    });

    try {
      final loadedQuizzes = await _quizRepository.getTeacherQuizzes();

      setState(() {
        _quizzes = loadedQuizzes;
      });
    } catch (e) {
      setState(() {
        if (e.toString().contains('Status: 200')) {
          _quizzes = [];
        } else {
          _errorMessage = 'Failed to load quizzes: ${e.toString()}';
        }
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
    }
  }

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
            spacing: 16,
            children: [
              Text('My Quizzes', style: TextStyle(fontSize: 24)),
              if (_errorMessage != null)
                Text(
                  'Error: $_errorMessage',
                  style: TextStyle(color: Colors.red),
                )
              else if (_quizzes == null)
                Center(child: CircularProgressIndicator())
              else if (_quizzes!.isEmpty)
                Center(child: Text('No quizzes found. Create a new one!'))
              else
                for (var quiz in _quizzes!)
                  TeacherQuizWidget(token: widget.token, quiz: quiz),
            ],
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
              onPressed: () => _createQuiz(),
              child: Text(
                'Creat a Quiz',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            CreateQuizScreen(token: widget.token),
      ),
    );
  }
}
