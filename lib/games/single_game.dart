import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/nima.dart';
import 'package:maui/components/progress_bar.dart';
import 'package:maui/components/progress_circle.dart';
import 'package:maui/games/ClueGame.dart';
import 'package:maui/games/Draw_Challenge.dart';
import 'package:maui/games/TrueFalse.dart';
import 'package:maui/games/abacus.dart';
import 'package:maui/games/bingo.dart';
import 'package:maui/games/calculate_numbers.dart';
import 'package:maui/games/casino.dart';
import 'package:maui/games/connectdots.dart';
import 'package:maui/games/crossword.dart';
import 'package:maui/games/drawing_game.dart';
import 'package:maui/games/fill_in_the_blanks.dart';
import 'package:maui/games/fill_number.dart';
import 'package:maui/games/first_word.dart';
import 'package:maui/games/guess.dart';
import 'package:maui/games/identify_game.dart';
import 'package:maui/games/match_the_following.dart';
import 'package:maui/games/memory.dart';
import 'package:maui/games/order_it.dart';
import 'package:maui/games/quiz.dart';
import 'package:maui/games/reflex.dart';
import 'package:maui/games/spin_wheel.dart';
import 'package:maui/games/tables.dart';
import 'package:maui/games/tap_home.dart';
import 'package:maui/games/tap_wrong.dart';
import 'package:maui/games/wordgrid.dart';
import 'package:tuple/tuple.dart';

enum GameMode { timed, iterations }

enum GameDisplay {
  single,
  myHeadToHead,
  otherHeadToHead,
  myTurnByTurn,
  otherTurnByTurn
}

enum UnitMode { text, image, audio }

class GameConfig {
  final UnitMode questionUnitMode;
  final UnitMode answerUnitMode;
  final int gameCategoryId;
  final int level;

  GameConfig(
      {this.questionUnitMode,
      this.answerUnitMode,
      this.gameCategoryId,
      this.level});
}

class SingleGame extends StatefulWidget {
  final String gameName;
  final int gameCategoryId;
  final Function onGameEnd;
  final Function onScore;
  final GameMode gameMode;
  final bool isRotated;
  final GameDisplay gameDisplay;
  final Key key;

  SingleGame(this.gameName,
      {this.key,
      this.gameMode = GameMode.iterations,
      this.gameDisplay = GameDisplay.single,
      this.gameCategoryId,
      this.onGameEnd,
      this.onScore,
      this.isRotated = false})
      : super(key: key);

  @override
  _SingleGameState createState() {
    return new _SingleGameState();
  }
}

class _SingleGameState extends State<SingleGame> {
  int _score = 0;
  double _progress = 0.0;
  int _iteration = 0;
  int maxIterations = 2;
  int playTime = 10000;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('_SingleGameState:build');
    MediaQueryData media = MediaQuery.of(context);
    print(media.size);
    print(widget.key.toString());
    var gameTuple = buildSingleGame(context, widget.gameDisplay.toString());
    return new Theme(
        data: gameTuple.item2,
        child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            body: media.size.height > media.size.width ||
                    widget.gameDisplay != GameDisplay.single
                ? new Column(children: <Widget>[
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.gameDisplay == GameDisplay.single
                            ? <Widget>[new Nima(_score), new Text('$_score')]
                            : <Widget>[new Text('$_score')]),
                    widget.gameMode == GameMode.timed
                        ? new ProgressBar(
                            time: playTime, onEnd: () => _onGameEnd(context))
                        : new ProgressBar(progress: _progress),
                    new Expanded(child: gameTuple.item1)
                  ])
                : new Row(children: <Widget>[
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.gameDisplay == GameDisplay.single
                            ? <Widget>[
                                new Nima(_score),
                                new Text('$_score'),
                                widget.gameMode == GameMode.timed
                                    ? new ProgressCircle(
                                        time: playTime,
                                        onEnd: () => _onGameEnd(context))
                                    : new ProgressCircle(progress: _progress)
                              ]
                            : <Widget>[
                                new Text('$_score'),
                                widget.gameMode == GameMode.timed
                                    ? new ProgressCircle(
                                        time: playTime,
                                        onEnd: () => _onGameEnd(context))
                                    : new ProgressCircle(progress: _progress)
                              ]),
                    new Expanded(child: gameTuple.item1)
                  ])));
  }

  _onScore(int incrementScore) {
    setState(() {
      _score += incrementScore;
    });
    if (widget.onScore != null) widget.onScore(_score);
  }

  _onProgress(double progress) {
    if (widget.gameMode == GameMode.iterations) {
      setState(() {
        _progress = (_iteration + progress) / maxIterations;
      });
    }
  }

  _onEnd(BuildContext context) {
    if (widget.gameMode == GameMode.iterations) {
      if (_iteration + 1 < maxIterations) {
        setState(() {
          _iteration++;
        });
      } else {
        _onGameEnd(context);
      }
    } else {
      setState(() {
        _iteration++;
      });
    }
  }

  _onGameEnd(BuildContext context) {
    if (widget.onGameEnd != null) {
      widget.onGameEnd(context);
    } else {
      showDialog<String>(
          context: context,
          child: new AlertDialog(
            content: new Text('$_score'),
          )).then<Null>((String s) {
        Navigator.pop(context);
      });
    }
  }

  Tuple2<Widget, ThemeData> buildSingleGame(
      BuildContext context, String keyName) {
    Random random = new Random();
    switch (widget.gameName) {
      case 'reflex':
        playTime = 15000;
        maxIterations = 1;
        return new Tuple2(
            new Reflex(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameConfig: new GameConfig(
                    gameCategoryId: widget.gameCategoryId,
                    questionUnitMode: UnitMode.values[random.nextInt(3)],
                    answerUnitMode: UnitMode.values[random.nextInt(3)],
                    level: random.nextInt(10) + 1)),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'order_it':
        maxIterations = 1;
        return new Tuple2(
            new OrderIt(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.blue, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'true_or_false':
        return new Tuple2(
            new TrueFalseGame(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.orange, //bg
                backgroundColor: Colors.purpleAccent, //behind progress bar
                accentColor: Colors.deepPurple, //progress bar
                buttonColor: Colors.red));
        break;
      case 'identify':
        return new Tuple2(
            new IdentifyGame(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                isRotated: widget.isRotated,
                iteration: _iteration),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'abacus':
        return new Tuple2(
            new Abacus(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'drawing':
        return new Tuple2(
            new Drawing(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                isRotated: widget.isRotated,
                iteration: _iteration),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'bingo':
        return new Tuple2(
            new Bingo(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'fill_in_the_blanks':
        return new Tuple2(
            new FillInTheBlanks(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
              scaffoldBackgroundColor: new Color(0xffff8edda3), //bg
              backgroundColor: new Color(0xffffeaca8b), //behind progress bar
              accentColor: Colors.brown, //progress bar
            ));
        break;
      case 'clue_game':
        return new Tuple2(
            new ClueGame(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: new Color(0xffffefce97)));
        break;
      case 'casino':
        return new Tuple2(
            new Casino(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
              scaffoldBackgroundColor: new Color(0xfffffef7c3a), //bg
              backgroundColor: new Color(0xfffff2d0d21), //behind progress bar
              accentColor: Colors.brown, //progress bar
              buttonColor: new Color(0xffffff8c43c),
              // primaryTextTheme:new TextTheme(display1: ),
            ));
        break;
      case 'crossword':
        return new Tuple2(
            new Crossword(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                isRotated: widget.isRotated,
                iteration: _iteration),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'tables':
        playTime = 20000;
        maxIterations = 1;
        return new Tuple2(
            new Tables(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'match_the_following':
        playTime = 15000;
        maxIterations = 4;
        return new Tuple2(
            new MatchTheFollowing(
              key: new GlobalObjectKey(keyName),
              onScore: _onScore,
              onProgress: _onProgress,
              onEnd: () => _onEnd(context),
              iteration: _iteration,
              isRotated: widget.isRotated,
              gameCategoryId: widget.gameCategoryId,
            ),
            new ThemeData(
                scaffoldBackgroundColor: new Color(0xFF28c9c9), //bg
                backgroundColor: new Color(0xFFfcc335), //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: new Color(0xFFed4a79)));
        break;
      case 'calculate_numbers':
        playTime = 25000;
        maxIterations = 10;
        return new Tuple2(
            new CalculateTheNumbers(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.orange[100], //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.orange));
        break;
      case 'memory':
        return new Tuple2(
            new Memory(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'fill_number':
        return new Tuple2(
            new Fillnumber(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: new Color(0xFFf7ebcb), //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.black, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'quiz':
        playTime = 15000;
        maxIterations = 10;
        return new Tuple2(
            new Quiz(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: const Color(0xFFf8c43c), //bg
                backgroundColor: const Color(0xFF9d4e70), //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'connect_the_dots':
        return new Tuple2(
            new Connectdots(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: new Color(0xFFf5c5b7), //bg
                backgroundColor: new Color(0xFF951664), //behind progress bar
                accentColor: new Color(0xFFfff176), //progress bar
                buttonColor: new Color(0xFFed2d85)));
        break;
      case 'tap_home':
        playTime = 20000;
        maxIterations = 10;
        return new Tuple2(
            new TapHome(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'tap_wrong':
        return new Tuple2(
            new TapWrong(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'wordgrid':
        return new Tuple2(
            new Wordgrid(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'guess':
        return new Tuple2(
            new GuessIt(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
      case 'spin_wheel':
        return new Tuple2(
            new SpinWheel(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'first_word':
        return new Tuple2(
            new FirstWord(
                key: new GlobalObjectKey(keyName),
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                iteration: _iteration,
                isRotated: widget.isRotated,
                gameCategoryId: widget.gameCategoryId),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
      case 'draw_challenge':
        maxIterations = 1;
        return new Tuple2(
            new Draw_Challenge(
                onScore: _onScore,
                onProgress: _onProgress,
                onEnd: () => _onEnd(context),
                isRotated: widget.isRotated,
                iteration: _iteration),
            new ThemeData(
                scaffoldBackgroundColor: Colors.lime, //bg
                backgroundColor: Colors.amber, //behind progress bar
                accentColor: Colors.brown, //progress bar
                buttonColor: Colors.pink));
        break;
    }
    return null;
  }
}
