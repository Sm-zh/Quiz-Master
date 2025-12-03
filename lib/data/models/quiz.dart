import 'question.dart';

class Quiz {
  final String id;
  final String title;
  final String? ownerId;
  final bool? isOpen;
  final String? joinCode;
  final List<Question>? questions;

  Quiz({
    required this.id,
    required this.title,
    this.ownerId,
    this.isOpen,
    this.joinCode,
    this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json, {bool isTeacher = false}) {
    return Quiz(
      id: json['id'] ?? json['_id'] ?? json['quizId'],
      ownerId: json['owner'],
      title: json['title'],
      isOpen: json['isOpen'] as bool,
      joinCode: json['joinCode'],
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}
