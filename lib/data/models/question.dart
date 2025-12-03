class Question {
  final String id;
  final String text;
  final String type;
  final List<String> options;
  final int? correctOptionIndex;
  final int points;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    this.correctOptionIndex,
    required this.points,
  });

  factory Question.fromJson(
    Map<String, dynamic> json, {
    bool isTeacher = false,
  }) {
    return Question(
      id: json['id'] ?? json['_id'],
      text: json['text'],
      type: json['type'],
      options: List<String>.from(json['options']),
      correctOptionIndex: isTeacher ? json['correctOptionIndex'] as int : null,
      points: json['points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'points': points,
    };
  }
}
