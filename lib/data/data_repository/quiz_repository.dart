import '../data_sources/quiz_data_sources.dart';
import '../models/answer.dart';
import '../models/attempt.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import '../models/quiz_statistics.dart';

class QuizRepository {
  final String token;
  final QuizDataSource quizDataSource;

  QuizRepository(this.token, this.quizDataSource);

  // Teacher
  Future<Quiz> createNewQuiz(String title, List<Question> questions) {
    return quizDataSource.createQuiz(title, questions);
  }

  Future<List<Quiz>> getTeacherQuizzes() async {
    return quizDataSource.listMyQuizzes();
  }

  Future<Quiz> toggleQuizStatus(String quizId, bool open) {
    if (open) {
      return quizDataSource.openQuiz(quizId);
    } else {
      return quizDataSource.closeQuiz(quizId);
    }
  }

  Future<QuizStatistics> getQuizStats(String quizId) async {
    final jsonStats = await quizDataSource.getQuizStatsJson(token, quizId);
    return QuizStatistics.fromJson(jsonStats);
  }

  // Student
  Future<Quiz> joinQuizByCode(String code) {
    return quizDataSource.joinQuiz(code);
  }

  Future<Attempt> submitAnswers(String quizId, List<Answer> answers) {
    return quizDataSource.submitQuiz(quizId, answers);
  }

  Future<List<Attempt>> getStudentAttempts() {
    return quizDataSource.getMyAttempts();
  }

  Future<List<Attempt>> getQuizResults(String quizId) {
    return quizDataSource.getQuizAttempts(quizId);
  }
}
