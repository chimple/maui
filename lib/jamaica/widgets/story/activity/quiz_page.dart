import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/widgets/game.dart';
import 'package:maui/models/game_data.dart';
import 'package:maui/models/multi_data.dart';
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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Game(
                updateCoins: (coins) => print(coins),
                quizSession: QuizSession((b) => b
                  ..gameId = 'MultipleChoiceGame'
                  ..level = 1
                  ..sessionId = '1'
                  ..gameData.addAll(gameData)))));
  }
}
