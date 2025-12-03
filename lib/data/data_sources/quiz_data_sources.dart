import '../models/answer.dart';
import '../models/attempt.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import 'base_data_source.dart';

class QuizDataSource {
  final HttpClient client;
  final String token;

  QuizDataSource(this.client, {required this.token});

  // POST /quizzes (Teacher only)
  Future<Quiz> createQuiz(String title, List<Question> questions) async {
    final response = await client.post(
      '$BASE_URL/quizzes',
      token: token,
      body: {
        'title': title,
        'questions': questions.map((q) => q.toJson()).toList(),
      },
    );
    return Quiz.fromJson(response, isTeacher: true);
  }

  // GET /quizzes (Teacher only)
  Future<List<Quiz>> listMyQuizzes() async {
    final response = await client.get('$BASE_URL/quizzes', token: token);
    final List list = response['list'];
    return (list)
        .map((json) => Quiz.fromJson(json, isTeacher: true))
        .toList();
  }

  // POST /quizzes/:quizId/open (Teacher only)
  Future<Quiz> openQuiz(String quizId) async {
    final token = this.token;
    final response = await client.post(
      '$BASE_URL/quizzes/$quizId/open',
      token: token,
    );
    return Quiz.fromJson(response['quiz'], isTeacher: true);
  }

  // POST /quizzes/:quizId/close (Teacher only)
  Future<Quiz> closeQuiz(String quizId) async {
    final token = this.token;
    final response = await client.post(
      '$BASE_URL/quizzes/$quizId/close',
      token: token,
    );
    return Quiz.fromJson(response['quiz'], isTeacher: true);
  }

  // POST /quizzes/join (Student only)
  Future<Quiz> joinQuiz(String code) async {
    final token = this.token;
    final response = await client.post(
      '$BASE_URL/quizzes/join',
      token: token,
      body: {'code': code},
    );
    return Quiz.fromJson(response, isTeacher: false);
  }

  // POST /quizzes/:quizId/submit (Student only)
  Future<Attempt> submitQuiz(String quizId, List<Answer> answers) async {
    final token = this.token;
    final response = await client.post(
      '$BASE_URL/quizzes/$quizId/submit',
      token: token,
      body: {'answers': answers.map((a) => a.toJson()).toList()},
    );
    return Attempt.fromJson(response);
  }

  // GET /quizzes/my-attempts (Student only)
  Future<List<Attempt>> getMyAttempts() async {
    final token = this.token;
    final response = await client.get(
      '$BASE_URL/quizzes/my-attempts',
      token: token,
    );
    return (response as List<dynamic>)
        .map((json) => Attempt.fromJson(json))
        .toList();
  }

  // GET /quizzes/:quizId/attempts (Teacher only)
  Future<List<Attempt>> getQuizAttempts(String quizId) async {
    final token = this.token;
    final response = await client.get(
      '$BASE_URL/quizzes/$quizId/attempts',
      token: token,
    );
    return (response as List<dynamic>)
        .map((json) => Attempt.fromJson(json))
        .toList();
  }

  // GET /quizzes/:quizId/stats (Teacher only)
  Future<Map<String, dynamic>> getQuizStatsJson(
    String token,
    String quizId,
  ) async {
    // Endpoint: GET /quizzes/:quizId/stats
    final response = await client.get(
      '$BASE_URL/quizzes/$quizId/stats',
      token: token,
    );
    return response;
  }
}
