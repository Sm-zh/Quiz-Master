import 'question.dart';

class Quiz {
  final String id;
  final String title;
  final String? ownerId;
  final bool isOpen;
  final String? joinCode;
  final List<Question>? questions;

  Quiz({
    required this.id,
    required this.title,
    this.ownerId,
    this.isOpen = false,
    this.joinCode,
    this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json, {bool isTeacher = false}) {
    return Quiz(
      // ✅ FIX: Robust ID parsing (handles _id or id)
      id: json['id'] ?? json['_id'] ?? json['quizId'] ?? '',
      ownerId: json['owner'],
      title: json['title'] ?? 'Untitled Quiz',
      // ✅ FIX: Default to false if null
      isOpen: (json['isOpen'] as bool?) ?? false,
      joinCode: json['joinCode'],
      questions: json['questions'] != null
          ? (json['questions'] as List<dynamic>)
                .map((q) => Question.fromJson(q, isTeacher: isTeacher))
                .toList()
          : [],
    );
  }
}
