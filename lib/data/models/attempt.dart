import 'package:quiz_master/data/models/answer.dart';

class Attempt {
  final String id;
  final String quizId;
  final String studentId;
  int score;
  int maxScore;
  List<Answer> answers;

  Attempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.score,
    required this.maxScore,
    required this.answers,
  });

  factory Attempt.fromJson(Map<String, dynamic> json) {
    return Attempt(
      id: json['id'] ?? json['_id'] ?? json['attemptId'],
      quizId: json['quiz'],
      studentId: json['student'],
      score: json['score'] as int,
      maxScore: json['maxScore'] as int,
      answers: (json['answers'] as List<dynamic>)
          .map((answer) => Answer.fromJson(answer))
          .toList(),
    );
  }
}
