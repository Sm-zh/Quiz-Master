import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/auth_repository.dart';
import 'package:quiz_master/data/data_repository/quiz_repository.dart';
import 'package:quiz_master/data/data_sources/base_data_source.dart';
import 'package:quiz_master/data/data_sources/quiz_data_sources.dart';
import 'package:quiz_master/data/models/quiz.dart';
import 'package:quiz_master/data/models/user.dart';
import 'package:quiz_master/presentation/screens/create_quiz_screen.dart';
import 'package:quiz_master/presentation/widgets/teacher_quiz_widget.dart';
import '../widgets/app_drawer.dart';

class TeacherHomeScreen extends StatefulWidget {
  final User user;
  final AuthRepository authRepository;

  const TeacherHomeScreen({
    super.key,
    required this.user,
    required this.authRepository,
  });

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  late final QuizRepository _quizRepository;
  bool _loading = false;
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    // Initialize repository with the user's token
    _quizRepository = QuizRepository(
      widget.user.token!,
      QuizDataSource(HttpClient(), token: widget.user.token!),
    );
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    setState(() => _loading = true);
    try {
      final quizzes = await _quizRepository.getTeacherQuizzes();
      setState(() => _quizzes = quizzes);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load quizzes: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard'), centerTitle: true),
      // ✅ FIX: Added the Side Menu (Drawer)
      drawer: AppDrawer(
        userName: widget.user.name,
        email: widget.user.email,
        authRepository: widget.authRepository,
      ),
      // ✅ FIX: Added Floating Action Button to Create Quiz
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateQuizScreen(token: widget.user.token!),
            ),
          );
          _loadQuizzes(); // Refresh list after returning
        },
        label: const Text('Create Quiz'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xff2c2c2c),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _quizzes.isEmpty
          ? const Center(
              child: Text(
                'No quizzes created yet.\nTap + to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadQuizzes,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _quizzes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  return TeacherQuizWidget(
                    token: widget.user.token!,
                    quiz: _quizzes[i],
                  );
                },
              ),
            ),
    );
  }
}
