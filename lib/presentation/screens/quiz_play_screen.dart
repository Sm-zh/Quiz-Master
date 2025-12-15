import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/quiz_repository.dart';
import 'package:quiz_master/data/models/answer.dart';
import 'package:quiz_master/data/models/question.dart';
import 'package:quiz_master/data/models/quiz.dart';

class QuizPlayScreen extends StatefulWidget {
  final Quiz quiz;
  final QuizRepository quizRepository;

  const QuizPlayScreen({
    super.key,
    required this.quiz,
    required this.quizRepository,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  final Map<String, int> _selected = {};
  bool _submitting = false;

  List<Question> get _questions => widget.quiz.questions ?? [];

  Future<void> _submit() async {
    if (_questions.isEmpty) return;

    // 1. Validation: Check if all questions are answered
    final unanswered = _questions.where((q) => !_selected.containsKey(q.id));
    if (unanswered.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      // 2. Prepare Data
      final answers = _questions
          .map(
            (q) =>
                Answer(questionId: q.id, chosenOptionIndex: _selected[q.id]!),
          )
          .toList();

      // 3. Send to Server
      final attempt = await widget.quizRepository.submitAnswers(
        widget.quiz.id,
        answers,
      );

      if (!mounted) return;

      // 4. Show Success Dialog with Score
      await showDialog(
        context: context,
        barrierDismissible: false, // User must tap OK
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 50),
              SizedBox(height: 10),
              Text(
                'Quiz Submitted!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You have successfully completed the quiz.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Score: ${attempt.score} / ${attempt.maxScore}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2c2c2c),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2c2c2c),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close Dialog
                  Navigator.pop(
                    context,
                    true,
                  ); // Close Screen & Refresh History
                },
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      String msg = 'Submission failed: $e';
      if (e.toString().contains('400')) {
        msg = 'You have already taken this quiz.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));

      // If already submitted, leave the screen
      if (e.toString().contains('400')) {
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final qs = _questions;

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title), centerTitle: true),
      body: qs.isEmpty
          ? const Center(child: Text('No questions available.'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: qs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, i) => _questionCard(qs[i], i + 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2c2c2c),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Submit Quiz',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _questionCard(Question q, int n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q$n. ${q.text}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (i) {
              return RadioListTile<int>(
                value: i,
                groupValue: _selected[q.id],
                activeColor: const Color(0xff2c2c2c),
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => _selected[q.id] = v!),
                title: Text(q.options[i]),
              );
            }),
          ],
        ),
      ),
    );
  }
}
