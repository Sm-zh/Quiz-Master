import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/quiz_repository.dart';
import 'package:quiz_master/data/data_sources/quiz_data_sources.dart';
import 'package:quiz_master/data/models/quiz.dart';
import 'package:quiz_master/presentation/screens/quiz_details.dart';

import '../../data/data_sources/base_data_source.dart';

class TeacherQuizWidget extends StatelessWidget {
  final String token;
  final Quiz quiz;

  const TeacherQuizWidget({super.key, required this.token, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: _buildQuizInfo()),
              const Icon(Icons.chevron_right, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizInfo() {
    final isOpen = quiz.isOpen ?? false;
    final joinCode = quiz.joinCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          quiz.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (joinCode != null && joinCode.isNotEmpty)
          Text(
            'Code: $joinCode',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isOpen ? Colors.green[600] : Colors.red[600],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isOpen ? 'Open' : 'Closed',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => QuizDetails(
          token: token,
          quiz: quiz,
          quizRepository: QuizRepository(
            token,
            QuizDataSource(HttpClient(), token: token),
          ),
        ),
      ),
    );
  }
}
