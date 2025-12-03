import 'package:flutter/material.dart';

class AddTFQuestionScreen extends StatefulWidget {
  final void Function(String questionTitle, String type, List<String> answersText, int correctAnswerIndex) onDone;

  const AddTFQuestionScreen({
    super.key,
    required this.onDone,
  });

  @override
  State<AddTFQuestionScreen> createState() => _AddTFQuestionScreenState();
}

class _AddTFQuestionScreenState extends State<AddTFQuestionScreen> {
  final TextEditingController _questionTitleController = TextEditingController(text: 'Tap to add question');
  int _correctAnswerIndex = -1; 
  
  static const List<String> _tfOptions = ['True', 'False'];

  @override
  void dispose() {
    _questionTitleController.dispose();
    super.dispose();
  }
  
  void _handleDone() {
    final questionTitle = _questionTitleController.text.trim();
    
    if (questionTitle.isEmpty || questionTitle == 'Tap to add question') {
        _showErrorDialog('Question title cannot be empty.');
        return;
    }
    if (_correctAnswerIndex == -1) {
        _showErrorDialog('You must select the correct answer (True or False).');
        return;
    }
    
    widget.onDone(
      questionTitle,
      'true_false',
      _tfOptions,
      _correctAnswerIndex,
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

  void _setCorrectAnswer(int index) {
    setState(() {
      _correctAnswerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isReady = _correctAnswerIndex != -1 && _questionTitleController.text.trim().isNotEmpty && _questionTitleController.text.trim() != 'Tap to add question';
    final Color doneButtonColor = isReady ? Colors.green : Colors.grey;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('True or False'),
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
                  const SizedBox(height: 32),

                  _buildAnswerButton(
                    text: _tfOptions[0],
                    index: 0,
                    isSelected: _correctAnswerIndex == 0, 
                  ),
                  const SizedBox(height: 16),

                  _buildAnswerButton(
                    text: _tfOptions[1],
                    index: 1,
                    isSelected: _correctAnswerIndex == 1,
                  ),
                ],
              ),
            ),
          ),
          
          _buildBottomControlButtons(doneButtonColor),
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
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Tap to add question',
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton({
    required String text,
    required int index,
    required bool isSelected,
  }) {
    final Color buttonColor = isSelected ? Colors.green : Colors.transparent;
    final Color borderColor = isSelected ? Colors.green : Colors.brown;
    final Color textColor = isSelected ? Colors.white : (index == 0 ? Colors.green : Colors.brown);

    return OutlinedButton(
      onPressed: () => _setCorrectAnswer(index),
      style: OutlinedButton.styleFrom(
        backgroundColor: buttonColor,
        side: BorderSide(color: borderColor, width: 2),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomControlButtons(Color doneButtonColor) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زر Done 
            ElevatedButton(
              onPressed: _handleDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: doneButtonColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            // زر Cancel (أحمر)
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