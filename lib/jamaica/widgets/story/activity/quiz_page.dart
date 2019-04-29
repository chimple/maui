import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/game.dart';
import 'package:maui/models/game_data.dart';
import 'package:maui/models/quiz_session.dart';

class QuizPage extends StatelessWidget {
  final BuiltList<GameData> gameData;
  final VoidCallback startQuiz;
  QuizPage({Key key, this.startQuiz, this.gameData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RaisedButton(
        onPressed: () => _startQuiz(context),
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

  _startQuiz(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Game(
                quizSession: QuizSession((s) => s
                  ..gameData = ListBuilder(gameData)
                  ..level = 1
                  ..sessionId = '1'))));
  }
}
