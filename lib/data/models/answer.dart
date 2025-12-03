class Answer {
  final String questionId;
  final int chosenOptionIndex;
  final bool? isCorrect;

  Answer({
    required this.questionId,
    required this.chosenOptionIndex,
    this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['questionId'],
      chosenOptionIndex: json['chosenOptionIndex'] as int,
      isCorrect: ['isCorrect'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'questionId': questionId, 'chosenOptionIndex': chosenOptionIndex};
  }
}
