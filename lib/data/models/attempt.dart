import 'package:quiz_master/data/models/answer.dart';

class Attempt {
  final String id;
  final String quizId;
  final String studentId;
  final int score;
  final int maxScore;
  final List<Answer> answers;

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
      // ✅ FIX 1: specific check for id variants
      id: json['id'] ?? json['_id'] ?? json['attemptId'] ?? '',

      // ✅ FIX 2: Check if 'quiz' is a Map (Object) or a String
      quizId: json['quiz'] is Map
          ? (json['quiz']['id'] ?? json['quiz']['_id'] ?? '')
          : (json['quiz']?.toString() ?? ''),

      // ✅ FIX 3: Check if 'student' is a Map (Object) or a String
      studentId: json['student'] is Map
          ? (json['student']['id'] ?? json['student']['_id'] ?? '')
          : (json['student']?.toString() ?? ''),

      // ✅ FIX 4: Safe number parsing (handles 10, 10.0, "10", or null)
      score: int.tryParse(json['score']?.toString() ?? '0') ?? 0,
      maxScore: int.tryParse(json['maxScore']?.toString() ?? '0') ?? 0,

      // ✅ FIX 5: Safe list parsing
      answers: json['answers'] != null && json['answers'] is List
          ? (json['answers'] as List<dynamic>)
                .map((a) => Answer.fromJson(a is Map<String, dynamic> ? a : {}))
                .toList()
          : [],
    );
  }
}
