import 'package:flutter/material.dart';
import 'package:quiz_master/presentation/screens/add_question_screen.dart';
import '../../data/data_repository/quiz_repository.dart';
import '../../data/data_sources/base_data_source.dart';
import '../../data/data_sources/quiz_data_sources.dart';
import '../../data/models/question.dart';
import '../../data/models/quiz.dart';

class CreateQuizScreen extends StatefulWidget {
  final String token;
  CreateQuizScreen({super.key, required this.token});

  late final QuizRepository quizRepository = QuizRepository(
    token,
    QuizDataSource(HttpClient(), token: token),
  );

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  Quiz quiz = Quiz(
    id: 'q01',
    title: '',
    questions: [],
    joinCode: null,
    isOpen: false,
    ownerId: null,
  );

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  void _creatQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            AddQuestionScreen(onDone: addQuestion),
      ),
    );
  }

  void addQuestion(
    String questionTitle,
    String type,
    List<String> answersText,
    int correctAnswerIndex,
  ) {
    setState(() {
      Question question = Question(
        id: quiz.id,
        text: questionTitle,
        type: type,
        options: answersText,
        points: 1,
        correctOptionIndex: correctAnswerIndex,
      );
      quiz = Quiz(
        id: quiz.id,
        title: quiz.title,
        questions: [...quiz.questions!, question],
      );
    });
    Navigator.pop(context);
  }

  void addTFQuestion(String questionTitle, int correctAnswerIndex) {
    setState(() {
      Question question = Question(
        id: quiz.id,
        text: questionTitle,
        type: 'true_false',
        options: ['True', 'False'],
        points: 1,
        correctOptionIndex: correctAnswerIndex,
      );
      quiz = Quiz(
        id: quiz.id,
        title: quiz.title,
        questions: [...quiz.questions!, question],
      );
    });
    Navigator.pop(context);
  }

  Future<void> _saveQuiz() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (quiz.questions!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add Questions Before Saving')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final createdQuiz = await widget.quizRepository.createNewQuiz(
        quiz.title,
        quiz.questions!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved, Join Code: ${createdQuiz.joinCode}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        String message = 'Failed to Saved, Check your Connection';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a Quiz',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: const Drawer(),
      body: Container(
        height: double.infinity,
        color: Colors.grey[400],
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(bottom: 120),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: quiz.title,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Quiz Title',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Quiz Title';
                          }
                          return null;
                        },
                        onChanged: (newTitle) {
                          setState(() {
                            quiz = Quiz(
                              id: quiz.id,
                              title: newTitle,
                              questions: quiz.questions,
                              joinCode: quiz.joinCode,
                              isOpen: quiz.isOpen,
                              ownerId: quiz.ownerId,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Questions (${quiz.questions!.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...quiz.questions!.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.key + 1} - ${entry.value.type == 'mcq' ? 'MCQ' : 'True or False'}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  entry.value.text,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff2c2c2c),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: TextButton(
                          onPressed: _creatQuestion,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Add a Question',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff14AE5C),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton(
                  onPressed: _isLoading ? null : _saveQuiz,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffEC221F),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
