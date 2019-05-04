import 'package:flare_flutter/flare_actor.dart';
import 'package:maui/jamaica/widgets/game_timer.dart';
import 'package:maui/models/quiz_session.dart';
// import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/game_score.dart';
import 'package:maui/jamaica/widgets/score.dart';
import 'package:maui/jamaica/widgets/slide_up_route.dart';
import 'package:maui/jamaica/widgets/stars.dart';

typedef UpdateQuizScore(int score);

class Game extends StatefulWidget {
  final QuizSession quizSession;
  final UpdateCoins updateCoins;
  final OnGameUpdate onGameUpdate;
  final UpdateQuizScore updateScore;
  const Game(
      {Key key,
      this.quizSession,
      this.updateCoins,
      this.onGameUpdate,
      this.updateScore})
      : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int _currentGame = 0;
  int _score = 0;
  int _stars = 0;
  String timeTaken;
  int gameIndex = 0;
  bool gameTimer = true;
  bool timeEnd = false;

  Navigator _navigator;

  timeCallback(t) {
    setState(() {
      timeTaken = t;
    });
  }

  timeEndCallback(t) {
    setState(() {
      if (gameIndex + 1 == widget.quizSession.gameData.length) {
        gameTimer = false;
      }
      timeEnd = t;
      ++gameIndex;
      timeEnd = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _navigator = Navigator(
      onGenerateRoute: (settings) => SlideUpRoute(
            widgetBuilder: (context) =>
                _buildGame(context, gameIndex, widget.updateScore),
          ),
    );

    MediaQueryData media = MediaQuery.of(context);
    Size size = media.size;

    double upPadding = size.height * 0.05;
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              // height: 1000,
              // width: 1000,
              color: Colors.white,
              child: FlareActor("assets/hud/bg.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  animation: "bg"),
            ),
            Column(
              verticalDirection: VerticalDirection.up,
              children: <Widget>[
                Expanded(
                  flex: 37,
                  child: _navigator,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: size.width * 0.17,
                      width: size.width * 0.17,
                      child: Hero(
                        tag: 'chimp',
                        child: FlareActor("assets/hud/chimp_1.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.cover,
                            animation: "happy"),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(),
                    ),
                    Flexible(
                        flex: 50,
                        child: Text(
                          'In this game you have to click on the alphabets in sequence order.',
                          style: Theme.of(context).textTheme.headline,
                        ))
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Divider(
                  color: Colors.black,
                  height: 0.0,
                ),
                Expanded(flex: 3, child: buildUI(size)),
                gameTimer
                    ? GameTimer(
                        time: 30,
                        onGameUpdate: widget.onGameUpdate,
                        timeCallback: timeCallback,
                        timeEndCallback: timeEndCallback)
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUI(Size size) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Icon(
                    Icons.close,
                    size: size.width * 0.095,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 10,
            child: Container(),
          ),
          Flexible(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            flex: 2,
                            child: Text(
                              '$_stars',
                              style: TextStyle(fontSize: size.width * 0.05),
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: Center(
                              child: Stars(
                                total: 5,
                                show: _stars,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGame(BuildContext context, index, updateScore) {
    print("lets check the values ..is  $index");
    print('lets check the tim end $timeEnd');

    if (index < widget.quizSession.gameData.length) {
      return buildGame(
          gameData: widget.quizSession.gameData[index],
          onGameUpdate: ({int score, int max, bool gameOver, bool star}) {
            print("in side clicking or not lets check $index");
            setState(() {
              _score += score;
              timeEnd = false;
              ++gameIndex;
              // updateScore(_score);
              if (score > 0) _stars++;
              //  _currentGame++;
            });

            Navigator.push(
                context,
                SlideUpRoute(
                    widgetBuilder: (context) =>
                        _buildGame(context, ++index, updateScore)));
          });
    } else {
      return GameScore(scores: _score);
    }
  }
}
