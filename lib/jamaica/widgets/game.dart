import 'package:data/models/quiz_session.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/score.dart';
import 'package:maui/jamaica/widgets/slide_up_route.dart';
import 'package:maui/jamaica/widgets/stars.dart';

typedef UpdateQuizScore(int score);

class Game extends StatefulWidget {
  final QuizSession quizSession;
  final UpdateCoins updateCoins;
  final UpdateQuizScore updateScore;
  const Game({Key key, this.quizSession, this.updateCoins, this.updateScore})
      : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int _currentGame = 0;
  int _score = 0;
  int _stars = 0;
  Navigator _navigator;

  @override
  void initState() {
    super.initState();
    _navigator = Navigator(
      onGenerateRoute: (settings) => SlideUpRoute(
            widgetBuilder: (context) =>
                _buildGame(context, 0, widget.updateScore),
          ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("......controll comming in game");
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Expanded(
              child: _navigator,
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 128.0,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: 128.0,
                        width: 128.0,
                        child: Hero(
                          tag: 'chimp',
                          child: FlareActor("assets/character/chimp.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: "idle"),
                        ),
                      ),
                      Expanded(
                        child: Stars(
                          total: widget.quizSession.gameData.length,
                          show: _stars,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGame(BuildContext context, int index, updateScore) {
    print("lets check the values ..is  $index");
    if (index < widget.quizSession.gameData.length) {
      return buildGame(
          gameData: widget.quizSession.gameData[index],
          onGameOver: (score) {
            print("in side clicking or not lets check $index");

            setState(() {
              _score += score;
              updateScore(_score);
              if (score > 0) _stars++;
//              _currentGame++;
            });

            Navigator.push(
                context,
                SlideUpRoute(
                    widgetBuilder: (context) =>
                        _buildGame(context, ++index, updateScore)));
          });
    } else {
      return Score(
        score: _score,
        starCount: _score,
        coinsCount: _score,
        updateCoins: widget.updateCoins,
      );
    }
  }
}
