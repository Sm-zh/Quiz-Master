import 'package:flutter/material.dart';
import 'package:quiz_master/data/models/quiz.dart';

import '../../data/data_repository/quiz_repository.dart';
import '../../data/models/quiz_statistics.dart';
import '../../data/models/attempt.dart';

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

  Future<void> _showFullResults(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<List<Attempt>>(
              future: quizRepository.getQuizResults(quiz.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Failed to load results: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No attempts for this quiz yet.'),
                  );
                }

                final attempts = snapshot.data!;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Full Results (${attempts.length} attempts)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: attempts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final attempt = attempts[index];
                          final score = '${attempt.score}/${attempt.maxScore}';

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              title: Text(
                                'Student: ${attempt.studentId}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('Score: $score'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(quiz.title), centerTitle: true),
      body: FutureBuilder<QuizStatistics>(
        future: quizRepository.getQuizStats(quiz.id),
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
            decoration: const BoxDecoration(
              color: Color(0xff2c2c2c),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: TextButton(
              onPressed: () => _showFullResults(context),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Quiz Statistics',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
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
          Text(label, style: const TextStyle(fontSize: 18)),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff2c2c2c),
              borderRadius: BorderRadius.circular(10),
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
