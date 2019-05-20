import 'package:built_collection/built_collection.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:maui/widgets/game_timer.dart';
import 'package:maui/widgets/intermediate_quiz_score.dart';
import 'package:maui/models/performance.dart';
import 'package:maui/models/quiz_session.dart';
// import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/game_score.dart';
import 'package:maui/widgets/score.dart';
import 'package:maui/widgets/slide_up_route.dart';
import 'package:maui/widgets/stars.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/widgets/theme_background.dart';

class Game extends StatefulWidget {
  final QuizSession quizSession;
  final UpdateCoins updateCoins;
  final OnGameUpdate onGameUpdate;
  const Game({Key key, this.quizSession, this.updateCoins, this.onGameUpdate})
      : super(key: key);
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  int _score = 0;
  int _currentGameScore = 0;
  int _stars = 0;
  String timeTaken;
  int gameIndex = 0;
  bool gameTimer = true;
  bool timeEnd = false;
  BuiltList<SubScore> _subScores;

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
    _subScores = BuiltList<SubScore>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _navigator = Navigator(
      onGenerateRoute: (settings) => SlideUpRoute(
            widgetBuilder: (context) => _buildGame(context, 0),
          ),
    );

    MediaQueryData media = MediaQuery.of(context);
    Size size = media.size;

    double upPadding = size.height * 0.05;
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () => showExitDialog(context),
          child: Stack(
            children: <Widget>[
              ThemeBackground(),
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
                          child: FlareActor("assets/character/chimp_ik.flr",
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
                  Expanded(flex: 3, child: buildUI(size, context)),
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
      ),
    );
  }

  Widget buildUI(Size size, BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: InkWell(
                    onTap: () => showExitDialog(context),
                    child: Icon(
                      Icons.close,
                      size: size.width * 0.08,
                      color: Colors.black,
                    ),
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
                              '$_score',
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

  showExitDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text("Do you want to exit?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  // Navigator.of(context).pop(context);
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName('/jam_games'));
                },
              ),
              new FlatButton(
                child: new Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
            ],
          );
        });
  }

  Widget _buildGame(BuildContext context, index) {
    print("lets check the values ..is  $index");
    print('lets check the tim end $timeEnd');

    return buildGame(
        gameData: widget.quizSession.gameData[index],
        onGameUpdate: ({int score, int max, bool gameOver, bool star}) {
          print("in side clicking or not lets check $index");
          setState(() {
            _score += score - _currentGameScore;
            _currentGameScore = score;
            timeEnd = false;
            if (star) _stars++;
            if (gameOver) {
              ++gameIndex;
              _score += score;
              _currentGameScore = 0;
              _subScores = _subScores.rebuild((b) => b.add(SubScore((b) => b
                ..gameId = widget.quizSession.gameData[index].gameId
                ..score = score
                ..complete = star
                ..startTime = DateTime.now().toUtc()
                ..endTime = DateTime.now().toUtc())));

              AppStateContainer.of(context).addPerformance(Performance((b) => b
                ..studentId =
                    AppStateContainer.of(context).state.loggedInUser.id
                ..sessionId = widget.quizSession.sessionId
                ..title = widget.quizSession.title
                ..numGames = widget.quizSession.gameData.length
                ..score = _score
                ..subScores.addAll(_subScores)
                ..startTime = DateTime.now().toUtc()
                ..endTime = DateTime.now().toUtc()));
              Navigator.push(
                  context,
                  SlideUpRoute(
                      widgetBuilder: (context) => index + 1 <
                              widget.quizSession.gameData.length
                          ? widget.quizSession.sessionId != 'game'
                              ? IntermediateQuizScore(
                                  onTap: () => Navigator.push(
                                      context,
                                      SlideUpRoute(
                                          widgetBuilder: (context) =>
                                              _buildGame(context, index + 1))))
                              : _buildGame(context, index + 1)
                          : GameScore(scores: _score)));
            }
          });
        });
  }
}
