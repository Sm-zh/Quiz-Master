import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/quiz_repository.dart';
import 'package:quiz_master/data/data_sources/quiz_data_sources.dart';
import 'package:quiz_master/data/models/quiz.dart';
import 'package:quiz_master/presentation/screens/quiz_details.dart';
import '../../data/data_sources/base_data_source.dart';

class TeacherQuizWidget extends StatefulWidget {
  final String token;
  final Quiz quiz;
  const TeacherQuizWidget({super.key, required this.token, required this.quiz});

  @override
  State<TeacherQuizWidget> createState() => _TeacherQuizWidgetState();
}

class _TeacherQuizWidgetState extends State<TeacherQuizWidget> {
  bool _isLoading = false;
  late bool _isOpen;
  late QuizRepository _repo;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.quiz.isOpen;
    _repo = QuizRepository(
      widget.token,
      QuizDataSource(HttpClient(), token: widget.token),
    );
  }

  Future<void> _toggleStatus(bool value) async {
    // 1. Optimistic Update
    setState(() {
      _isLoading = true;
      _isOpen = value;
    });

    try {
      // 2. Call Server
      final updatedQuiz = await _repo.toggleQuizStatus(widget.quiz.id, value);

      if (mounted) {
        setState(() {
          _isLoading = false;
          // 3. Confirm with Server Data
          _isOpen = updatedQuiz.isOpen;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isOpen
                  ? "Quiz is now OPEN (Code: ${widget.quiz.joinCode})"
                  : "Quiz is now CLOSED",
            ),
            backgroundColor: _isOpen ? Colors.green : Colors.grey,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // 4. Revert on Failure
        setState(() {
          _isOpen = !value;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update status: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => QuizDetails(
          token: widget.token,
          quiz: widget.quiz,
          quizRepository: _repo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: _isOpen ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _isOpen ? Icons.play_arrow : Icons.lock,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quiz.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Code: ${widget.quiz.joinCode ?? "Generating..."}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      _isOpen ? "OPEN" : "CLOSED",
                      style: TextStyle(
                        color: _isOpen ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Switch(
                            value: _isOpen,
                            onChanged: _toggleStatus,
                            activeColor: Colors.green,
                          ),
                  ],
                ),
                TextButton(
                  onPressed: () => _showDetails(context),
                  child: const Text('Statistics'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
