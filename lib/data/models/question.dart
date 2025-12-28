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
      // ✅ FIX: Strongest possible ID check.
      // If the server sends _id, or id, or nothing, this handles it.
      id: json['id'] ?? json['_id'] ?? json['questionId'] ?? '',

      text: json['text'] ?? 'Question Text',
      type: json['type'] ?? 'mcq',

      // ✅ FIX: Safe Option List
      options: json['options'] != null && json['options'] is List
          ? List<String>.from(json['options'].map((x) => x.toString()))
          : [],

      correctOptionIndex: isTeacher
          ? (json['correctOptionIndex'] as num?)?.toInt()
          : null,

      points: (json['points'] as num?)?.toInt() ?? 1,
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
