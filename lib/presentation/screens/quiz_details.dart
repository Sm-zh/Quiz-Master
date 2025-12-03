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
    final Future<QuizStatistics> statsFuture = quizRepository.getQuizStats(
      quiz.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Statistics',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: const Drawer(),
      body: FutureBuilder<QuizStatistics>(
        future: statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No statistics available.'));
          }

          final QuizStatistics stats = snapshot.data!;

          return _buildStatisticsBody(context, stats);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 64),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff2c2c2c),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Export Full Statistics',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsBody(BuildContext context, QuizStatistics stats) {
    return Container(
      height: double.infinity,
      color: Colors.grey[400],
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(stats.title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatRow(
                  'Total Questions:',
                  stats.totalQuestions.toString(),
                ),
                _buildStatRow(
                  'Total Students:',
                  stats.totalStudents.toString(),
                ),
                _buildStatRow('Max Point:', stats.maxPoint.toString()),
                _buildStatRow('Min Point:', stats.minPoint.toString()),
                _buildStatRow('Mean:', stats.meanPoint.toStringAsFixed(1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff2c2c2c),
              borderRadius: BorderRadius.circular(8),
            ),
            width: 72,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
