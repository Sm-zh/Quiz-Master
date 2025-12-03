class QuizStatistics {
  final String quizId;
  final String title;
  final int totalQuestions;
  final int totalStudents;
  final int maxPoint;
  final int minPoint;
  final double meanPoint;

  QuizStatistics({
    required this.quizId,
    required this.title,
    required this.totalQuestions,
    required this.totalStudents,
    required this.maxPoint,
    required this.minPoint,
    required this.meanPoint,
  });

  factory QuizStatistics.fromJson(Map<String, dynamic> json) {
    return QuizStatistics(
      quizId: json['quizId'],
      title: json['title'],
      totalQuestions: json['totalQuestions'],
      totalStudents: json['totalStudents'],
      maxPoint: json['maxPoint'],
      minPoint: json['minPoint'],
      meanPoint: (json['meanPoint'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'title': title,
      'totalQuestions': totalQuestions,
      'totalStudents': totalStudents,
      'maxPoint': maxPoint,
      'minPoint': minPoint,
      'meanPoint': meanPoint,
    };
  }
}