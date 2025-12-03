import 'package:flutter/material.dart';
import 'package:quiz_master/presentation/screens/add_mcq_question_screen.dart';
import 'package:quiz_master/presentation/screens/add_tf_question_screen.dart';

class AddQuestionScreen extends StatelessWidget {
  final void Function(
    String questionTitle,
    String type,
    List<String> answersText,
    int correctAnswerIndex,
  )
  onDone;
  const AddQuestionScreen({super.key, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a Question',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      endDrawer: const Drawer(),
      body: Container(
        padding: EdgeInsets.all(64),
        color: Colors.grey[400],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 32,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xff2c2c2c),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: TextButton(
                onPressed: () => _createMCQQuestion(context),
                child: const Text(
                  'MCQ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff2c2c2c),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: TextButton(
                onPressed: () => _createToFQuestion(context),
                child: const Text(
                  'True Or False',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 64),
          child: Container(
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
        ),
      ),
    );
  }

  void _createMCQQuestion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddMCQQuestionScreen(onDone: onDone),
      ),
    );
  }

  void _createToFQuestion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AddTFQuestionScreen(onDone: onDone),
      ),
    );
  }
}
