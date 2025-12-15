import 'package:flutter/material.dart';
import 'package:quiz_master/data/models/quiz.dart';
import '../../data/data_repository/quiz_repository.dart';
import '../../data/models/quiz_statistics.dart';

class QuizDetails extends StatelessWidget {
  final String token;
  final Quiz quiz;
  final QuizRepository quizRepository;

  const QuizDetails({
    super.key,
    required this.token,
    required this.quiz,
    required this.quizRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Statistics'), centerTitle: true),
      body: FutureBuilder<QuizStatistics>(
        future: quizRepository.getQuizStats(quiz.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Could not load statistics.\n\nError: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No statistics available.'));
          }

          final stats = snapshot.data!;
          return _buildStatisticsBody(stats);
        },
      ),
    );
  }

  Widget _buildStatisticsBody(QuizStatistics stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            stats.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildStatRow('Total Questions', '${stats.totalQuestions}'),
                  const Divider(),
                  _buildStatRow('Total Students', '${stats.totalStudents}'),
                  const Divider(),
                  _buildStatRow('Highest Score', '${stats.maxPoint}'),
                  const Divider(),
                  _buildStatRow('Lowest Score', '${stats.minPoint}'),
                  const Divider(),
                  _buildStatRow(
                    'Average Score',
                    stats.meanPoint.toStringAsFixed(1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
