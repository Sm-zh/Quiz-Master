class Answer {
  final String questionId;
  final int chosenOptionIndex;

  Answer({required this.questionId, required this.chosenOptionIndex});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      // ✅ FIX: Handle null questionId safely
      questionId: json['question'] ?? json['questionId'] ?? '',
      chosenOptionIndex: (json['chosenOptionIndex'] as num?)?.toInt() ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'chosenOptionIndex': chosenOptionIndex};
  }
}
