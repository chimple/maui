import 'package:flutter/material.dart';
import 'package:maui/models/quiz_session.dart';
import 'package:maui/state/app_state_container.dart';

class QuizWaitingScreen extends StatefulWidget {
 final QuizSession quizSession;
  QuizWaitingScreen({Key key, this.quizSession});

  @override
  _QuizWaitingScreenState createState() => _QuizWaitingScreenState();
}

class _QuizWaitingScreenState extends State<QuizWaitingScreen> {

  @override
  void initState() {
    super.initState();
    print('QuizWaitingScreen.....................................');
    print(widget.quizSession.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Quiz Waiting Screen'),
      ),
      resizeToAvoidBottomPadding: false,
      body: new Text("Waiting to Start Quiz.>!!"),
    );
  }
}







