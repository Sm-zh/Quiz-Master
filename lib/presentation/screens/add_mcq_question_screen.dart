import 'package:flutter/material.dart';

class _InternalAnswerModel {
  String text;
  bool isCorrect;
  _InternalAnswerModel(this.text, {this.isCorrect = false});
}

class AddMCQQuestionScreen extends StatefulWidget {
  final void Function(String questionTitle, String type, List<String> answersText, int correctAnswerIndex) onDone;

  const AddMCQQuestionScreen({
    super.key,
    required this.onDone,
  });

  @override
  State<AddMCQQuestionScreen> createState() => _AddMCQQuestionScreenState();
}

class _AddMCQQuestionScreenState extends State<AddMCQQuestionScreen> {
  final TextEditingController _questionTitleController = TextEditingController();
  final List<_InternalAnswerModel> _answers = [
    _InternalAnswerModel('Answer 1', isCorrect: true),
  ];

  @override
  void dispose() {
    _questionTitleController.dispose();
    super.dispose();
  }

  void _addAnswer() {
    setState(() {
      _answers.add(_InternalAnswerModel('New Answer ${_answers.length + 1}'));
    });
  }

  Future<void> _editAnswer(int index) async {
    final TextEditingController controller = TextEditingController(text: _answers[index].text);
    final newText = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Answer'),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (newText != null && newText.isNotEmpty) {
      setState(() {
        _answers[index].text = newText;
      });
    }
  }

  void _setCorrectAnswer(int correctIndex) {
    setState(() {
      for (int i = 0; i < _answers.length; i++) {
        _answers[i].isCorrect = (i == correctIndex);
      }
    });
  }

  void _handleDone() {
    final questionTitle = _questionTitleController.text.trim();    
    final List<String> answersText = _answers.map((a) => a.text).toList();    
    final int correctAnswerIndex = _answers.indexWhere((a) => a.isCorrect);

    if (questionTitle.isEmpty || questionTitle == 'Tap to add question') {
        _showErrorDialog('Question title cannot be empty.');
        return;
    }
    if (_answers.isEmpty) {
        _showErrorDialog('You must add at least one answer.');
        return;
    }
    if (correctAnswerIndex == -1) {
        _showErrorDialog('You must select one correct answer.');
        return;
    }
    
    widget.onDone(
      questionTitle,
      'mcq',
      answersText,
      correctAnswerIndex,
    );
    
    Navigator.of(context).pop();
  }

  void _showErrorDialog(String message) {
     showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('MCQ'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildQuestionInput(),
                  const SizedBox(height: 16),

                  ..._answers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final answer = entry.value;
                    return _buildAnswerTile(index, answer);
                  }),
                  const SizedBox(height: 16),
                  
                  _buildAddAnswerButton(),
                ],
              ),
            ),
          ),
          
          _buildBottomControlButtons(),
        ],
      ),
    );
  }

  Widget _buildQuestionInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _questionTitleController,
          maxLines: 4,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Tap to add question',
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerTile(int index, _InternalAnswerModel answer) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        title: Text(
          answer.text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey[600]),
              onPressed: () => _editAnswer(index),
            ),
            Radio<bool>(
              value: true,
              // ignore: deprecated_member_use
              groupValue: answer.isCorrect,
              // ignore: deprecated_member_use
              onChanged: (bool? value) {
                if (value == true) {
                  _setCorrectAnswer(index);
                }
              },
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAnswerButton() {
    return ElevatedButton(
      onPressed: _addAnswer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        'Add Answer',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildBottomControlButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _handleDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}