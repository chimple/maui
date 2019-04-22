import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  final VoidCallback startQuiz;
  QuizPage({Key key, this.startQuiz}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        onPressed: () {
          // startQuiz();
        },
        child: Text('Start'),
      ),
      body: Center(
        child: Text(
          'Quiz',
          style: TextStyle(fontSize: 40, color: Colors.red),
        ),
      ),
    );
  }
}
