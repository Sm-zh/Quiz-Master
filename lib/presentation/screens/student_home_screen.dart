import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/auth_repository.dart';
import 'package:quiz_master/data/data_repository/quiz_repository.dart';
import 'package:quiz_master/data/data_sources/base_data_source.dart';
import 'package:quiz_master/data/data_sources/quiz_data_sources.dart';
import 'package:quiz_master/data/models/attempt.dart';
import 'package:quiz_master/data/models/quiz.dart';
import 'package:quiz_master/data/models/user.dart';
import 'package:quiz_master/presentation/screens/quiz_play_screen.dart';
import '../widgets/app_drawer.dart';

class StudentHomeScreen extends StatefulWidget {
  final User user;
  final AuthRepository authRepository;

  const StudentHomeScreen({
    super.key,
    required this.user,
    required this.authRepository,
  });

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late final QuizRepository _quizRepository;
  final _codeController = TextEditingController();

  bool _loading = false;
  bool _joining = false;
  List<Attempt> _attempts = [];
  String? _errorMessage; // To show errors in UI

  @override
  void initState() {
    super.initState();
    _quizRepository = QuizRepository(
      widget.user.token!,
      QuizDataSource(HttpClient(), token: widget.user.token!),
    );
    _loadAttempts();
  }

  Future<void> _loadAttempts() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final attempts = await _quizRepository.getStudentAttempts();
      setState(() => _attempts = attempts);
    } catch (e) {
      // ✅ FIX: Show the error instead of hiding it
      setState(() => _errorMessage = e.toString());
      debugPrint('Error loading attempts: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _joinQuiz() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a quiz code')));
      return;
    }

    setState(() => _joining = true);
    try {
      final Quiz quiz = await _quizRepository.joinQuizByCode(code);

      if (!mounted) return;

      final refresh = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              QuizPlayScreen(quiz: quiz, quizRepository: _quizRepository),
        ),
      );

      if (refresh == true) {
        _codeController.clear();
        _loadAttempts();
      }
    } catch (e) {
      if (!mounted) return;
      String msg = 'Failed to join: $e';
      if (e.toString().contains('403')) {
        msg = 'Quiz is closed by the teacher.';
      } else if (e.toString().contains('404')) {
        msg = 'Quiz code not found.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard'), centerTitle: true),
      drawer: AppDrawer(
        userName: widget.user.name,
        email: widget.user.email,
        authRepository: widget.authRepository,
      ),
      body: RefreshIndicator(
        onRefresh: _loadAttempts,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Join Quiz Card
              Card(
                color: const Color(0xff2c2c2c),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Join a Quiz',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _codeController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'ENTER CODE',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: _joining ? null : _joinQuiz,
                          child: _joining
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'START QUIZ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Attempts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Error Message Display
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Error loading history: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Attempts List
              _loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _attempts.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('No attempts yet.'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _attempts.length,
                      itemBuilder: (context, i) {
                        final a = _attempts[i];
                        final bool isPass = a.score >= (a.maxScore / 2);
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isPass
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              child: Icon(
                                isPass ? Icons.check : Icons.close,
                                color: isPass ? Colors.green : Colors.red,
                              ),
                            ),
                            title: Text(
                              'Quiz ID: ${a.quizId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(isPass ? 'Passed' : 'Failed'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xff2c2c2c),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${a.score} / ${a.maxScore}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
