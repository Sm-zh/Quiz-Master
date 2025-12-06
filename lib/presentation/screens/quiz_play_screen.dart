import 'package:flutter/material.dart';

import '../../data/data_repository/quiz_repository.dart';
import '../../data/models/answer.dart';
import '../../data/models/attempt.dart';
import '../../data/models/question.dart';
import '../../data/models/quiz.dart';

class QuizPlayScreen extends StatefulWidget {
  final String token;
  final Quiz quiz;
  final QuizRepository quizRepository;

  const QuizPlayScreen({
    super.key,
    required this.token,
    required this.quiz,
    required this.quizRepository,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  final Map<String, int> _selectedOptions = {};
  bool _isSubmitting = false;
  Attempt? _submittedAttempt;

  List<Question> get _questions => widget.quiz.questions ?? [];

  Future<void> _submitAnswers() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No questions found in this quiz')),
      );
      return;
    }

    // Ensure all questions answered
    final unanswered = _questions.where(
      (q) => !_selectedOptions.containsKey(q.id),
    );

    if (unanswered.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final answers = _questions
          .map(
            (q) => Answer(
              questionId: q.id,
              chosenOptionIndex: _selectedOptions[q.id]!,
            ),
          )
          .toList();

      final attempt = await widget.quizRepository.submitAnswers(
        widget.quiz.id,
        answers,
      );

      setState(() {
        _submittedAttempt = attempt;
      });

      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Quiz Submitted'),
          content: Text('Your score: ${attempt.score} / ${attempt.maxScore}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      Navigator.of(context).pop(true); // tell previous screen to refresh
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit quiz: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title, overflow: TextOverflow.ellipsis),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: questions.isEmpty
                  ? const Center(
                      child: Text('No questions available for this quiz.'),
                    )
                  : ListView.separated(
                      itemCount: questions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final question = questions[index];
                        return _buildQuestionCard(question, index + 1);
                      },
                    ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff2c2c2c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitAnswers,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Submit Answers',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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

  Widget _buildQuestionCard(Question question, int number) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q$number. ${question.text}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (question.options.isEmpty)
            const Text(
              'No options for this question.',
              style: TextStyle(color: Colors.black54),
            )
          else
            Column(
              children: [
                for (int i = 0; i < question.options.length; i++)
                  RadioListTile<int>(
                    value: i,
                    groupValue: _selectedOptions[question.id],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedOptions[question.id] = value;
                      });
                    },
                    title: Text(question.options[i]),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
