import 'package:flutter/material.dart';
import 'package:quiz_master/data/data_repository/quiz_repository.dart';
import 'package:quiz_master/data/data_sources/quiz_data_sources.dart';
import 'package:quiz_master/data/models/quiz.dart';
import 'package:quiz_master/presentation/screens/quiz_details.dart';

import '../../data/data_sources/base_data_source.dart';

class TeacherQuizWidget extends StatelessWidget {
  final String token;
  final Quiz quiz;
  const TeacherQuizWidget({super.key, required this.token, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                children: [
                  Text(
                    quiz.title,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xff2c2c2c),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: TextButton(
              onPressed: () => _showDetails(quiz, context),
              child: Text(
                'Details',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(Quiz quiz, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => QuizDetails(
          token: token,
          quiz: quiz,
          quizRepository: QuizRepository(
            token,
            QuizDataSource(HttpClient(), token: token),
          ),
        ),
      ),
    );
  }
}
