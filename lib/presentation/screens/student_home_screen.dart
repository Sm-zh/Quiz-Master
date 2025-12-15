import 'package:flutter/material.dart';

import '../../data/data_repository/quiz_repository.dart';
import '../../data/data_sources/base_data_source.dart';
import '../../data/data_sources/quiz_data_sources.dart';
import '../../data/models/attempt.dart';
import '../../data/models/quiz.dart';
import 'quiz_play_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final String token;

  const StudentHomeScreen({super.key, required this.token});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late final QuizRepository _quizRepository;
  final TextEditingController _codeController = TextEditingController();

  bool _isLoadingAttempts = false;
  bool _isJoining = false;
  List<Attempt>? _attempts;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _quizRepository = QuizRepository(
      widget.token,
      QuizDataSource(HttpClient(), token: widget.token),
    );
    _loadAttempts();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadAttempts() async {
    setState(() {
      _isLoadingAttempts = true;
      _errorMessage = null;
    });

    try {
      final attempts = await _quizRepository.getStudentAttempts();
      setState(() {
        _attempts = attempts;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load attempts: $e';
      });
    } finally {
      setState(() {
        _isLoadingAttempts = false;
      });
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

    setState(() {
      _isJoining = true;
    });

    try {
      final Quiz quiz = await _quizRepository.joinQuizByCode(code);

      final refresh = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => QuizPlayScreen(
            token: widget.token,
            quiz: quiz,
            quizRepository: _quizRepository,
          ),
        ),
      );

      if (refresh == true) {
        _loadAttempts();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to join quiz: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuizMaster',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Welcome, Student 👋',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join a quiz using the code from your teacher and view your previous results.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            _buildJoinQuizCard(),
            const SizedBox(height: 24),
            _buildAttemptsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinQuizCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Join a Quiz',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: 'Enter quiz code',
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isJoining ? null : _joinQuiz,
              child: _isJoining
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Join Quiz',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Results',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_isLoadingAttempts)
          const Center(child: CircularProgressIndicator())
        else if (_errorMessage != null)
          Text(_errorMessage!, style: const TextStyle(color: Colors.red))
        else if (_attempts == null || _attempts!.isEmpty)
          const Text(
            'No quiz attempts yet. Join a quiz to see your results here.',
            style: TextStyle(color: Colors.black54),
          )
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _attempts!.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final attempt = _attempts![index];

              // عدّل النص تحت حسب الحقول اللي عندك في Attempt
              final scoreText = '${attempt.score}/${attempt.maxScore}';

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    // لو عندك quizTitle في Attempt استخدمه هنا
                    'Attempt on quiz: ${attempt.quizId}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('Score: $scoreText'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          ),
      ],
    );
  }
}
