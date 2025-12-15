import '../models/answer.dart';
import '../models/attempt.dart';
import '../models/question.dart';
import '../models/quiz.dart';
import 'base_data_source.dart';

class QuizDataSource {
  final HttpClient client;
  final String token;

  QuizDataSource(this.client, {required this.token});

  List<dynamic> _parseList(dynamic response) {
    if (response == null) return [];
    if (response is List) return response;

    if (response is Map<String, dynamic>) {
      if (response['list'] is List) return response['list'];
      if (response['data'] is List) return response['data'];
      if (response['attempts'] is List) return response['attempts'];
      if (response['quizzes'] is List) return response['quizzes'];
    }
    return [];
  }

  Future<Quiz> createQuiz(String title, List<Question> questions) async {
    final response = await client.post(
      '$BASE_URL/quizzes',
      token: token,
      body: {
        'title': title,
        'questions': questions.map((q) => q.toJson()).toList(),
      },
    );
    final data = response.containsKey('quiz') ? response['quiz'] : response;
    return Quiz.fromJson(data, isTeacher: true);
  }

  Future<List<Quiz>> listMyQuizzes() async {
    final response = await client.get('$BASE_URL/quizzes', token: token);
    final List list = _parseList(response);
    return list.map((json) => Quiz.fromJson(json, isTeacher: true)).toList();
  }

  Future<Quiz> openQuiz(String quizId) async {
    final response = await client.post(
      '$BASE_URL/quizzes/$quizId/open',
      token: token,
      body: {},
    );
    final data = response.containsKey('quiz') ? response['quiz'] : response;
    return Quiz.fromJson(data, isTeacher: true);
  }

  Future<Quiz> closeQuiz(String quizId) async {
    final response = await client.post(
      '$BASE_URL/quizzes/$quizId/close',
      token: token,
      body: {},
    );
    final data = response.containsKey('quiz') ? response['quiz'] : response;
    return Quiz.fromJson(data, isTeacher: true);
  }

  Future<Quiz> joinQuiz(String code) async {
    final response = await client.post(
      '$BASE_URL/quizzes/join',
      token: token,
      body: {'code': code},
    );
    final data = response.containsKey('quiz') ? response['quiz'] : response;
    return Quiz.fromJson(data, isTeacher: false);
  }

  Future<Attempt> submitQuiz(String quizId, List<Answer> answers) async {
    final response = await client.post(
      '$BASE_URL/quizzes/$quizId/submit',
      token: token,
      body: {'answers': answers.map((a) => a.toJson()).toList()},
    );
    final data = response.containsKey('attempt')
        ? response['attempt']
        : response;
    return Attempt.fromJson(data);
  }

  Future<List<Attempt>> getMyAttempts() async {
    final response = await client.get(
      '$BASE_URL/quizzes/my-attempts',
      token: token,
    );
    final List list = _parseList(response);
    return list.map((json) => Attempt.fromJson(json)).toList();
  }

  Future<List<Attempt>> getQuizAttempts(String quizId) async {
    final response = await client.get(
      '$BASE_URL/quizzes/$quizId/attempts',
      token: token,
    );
    final List list = _parseList(response);
    return list.map((json) => Attempt.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> getQuizStatsJson(
    String token,
    String quizId,
  ) async {
    final response = await client.get(
      '$BASE_URL/quizzes/$quizId/stats',
      token: token,
    );
    if (response.containsKey('stats')) return response['stats'];
    return response;
  }
}
