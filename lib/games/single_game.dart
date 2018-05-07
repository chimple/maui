import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/nima.dart';
import 'package:maui/components/progress_circle.dart';
import 'package:maui/games/ClueGame.dart';
import 'package:maui/games/Draw_Challenge.dart';
import 'package:maui/games/TrueFalse.dart';
import 'package:maui/games/abacus.dart';
import 'package:maui/games/bingo.dart';
import 'package:maui/games/calculate_numbers.dart';
import 'package:maui/games/casino.dart';
import 'package:maui/games/circleword.dart';
import 'package:maui/games/connectdots.dart';
import 'package:maui/games/crossword.dart';
import 'package:maui/games/drawing_game.dart';
import 'package:maui/games/fill_in_the_blanks.dart';
import 'package:maui/games/fill_number.dart';
import 'package:maui/games/friendWord.dart';
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
import 'package:maui/screens/score_screen.dart';
import 'package:maui/state/app_state_container.dart';
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

enum Learning { literacy, maths }

class SingleGame extends StatefulWidget {
  final String gameName;
  final int gameCategoryId;
  final Function onGameEnd;
  final Function onScore;
  final GameMode gameMode;
  final bool isRotated;
  final GameDisplay gameDisplay;
  final Key key;

  static final Map<String, List<Color>> gameColors = {
    'reflex': [Color(0xFFC79690), Color(0xFF7A8948), Color(0xFF7592BC)],
    'abacus': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'bingo': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'calculate_numbers': [
      Color(0xFF7A8948),
      Color(0xFFC79690),
      Color(0xFF7592BC)
    ],
    'casino': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'circle_word': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'clue_game': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'connect_the_dots': [
      Color(0xFF7A8948),
      Color(0xFFC79690),
      Color(0xFF7592BC)
    ],
    'crossword': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'draw_challenge': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'drawing': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'fill_in_the_blanks': [
      Color(0xFF7A8948),
      Color(0xFFC79690),
      Color(0xFF7592BC)
    ],
    'fill_number': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'friend_word': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'guess': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'identify': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'match_the_following': [
      Color(0xFF7A8948),
      Color(0xFFC79690),
      Color(0xFF7592BC)
    ],
    'memory': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'order_it': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'quiz': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'spin_wheel': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'tables': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'tap_home': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'tap_wrong': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'true_or_false': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'wordgrid': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)]
  };

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
    var colors = SingleGame.gameColors[widget.gameName];
    var theme = new ThemeData(primaryColor: colors[0], buttonColor: colors[1]);
    var game = buildSingleGame(context, widget.gameDisplay.toString());
    return new Theme(
        data: theme,
        child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            body: media.size.height > media.size.width ||
                    widget.gameDisplay != GameDisplay.single
                ? new Column(children: <Widget>[
                    new Material(
                        elevation: 8.0,
                        color: theme.primaryColor,
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.gameDisplay == GameDisplay.single
                                ? <Widget>[
                                    new Expanded(
                                      child: new Row(children: <Widget>[
                                        new InkWell(
                                            child: new Icon(Icons.arrow_back),
                                            onTap: () =>
                                                Navigator.of(context).pop()),
                                        _hud(context)
                                      ]),
                                      flex: 1,
                                    ),
                                    new Expanded(
                                        child: new Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: new Nima(_score)),
                                        flex: 1),
                                    new Expanded(
                                        child: new Text('$_score'), flex: 1)
                                  ]
                                : <Widget>[
                                    _hud(context),
                                    new Text('$_score')
                                  ])),
                    new Expanded(child: game)
                  ])
                : new Row(children: <Widget>[
                    new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: widget.gameDisplay == GameDisplay.single
                            ? <Widget>[
                                new Nima(_score),
                                new Text('$_score'),
                                _hud(context)
                              ]
                            : <Widget>[new Text('$_score'), _hud(context)]),
                    new Expanded(child: game)
                  ])));
  }

  _hud(BuildContext context) {
    print(Theme.of(context).primaryColor);
    var user = AppStateContainer.of(context).state.loggedInUser;

    return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(user.name, style: new TextStyle(fontSize: 24.0)),
          new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  new Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              image: new FileImage(new File(user.image)),
                              fit: BoxFit.fill))),
                  new SizedBox(
                      width: 64.0,
                      height: 64.0,
                      child: new CircularProgressIndicator(
                        strokeWidth: 8.0,
                        value: 1.0,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )),
                  new SizedBox(
                      width: 64.0,
                      height: 64.0,
                      child: widget.gameMode == GameMode.timed
                          ? new ProgressCircle(
                              time: playTime, onEnd: () => _onGameEnd(context))
                          : new ProgressCircle(progress: _progress)),
                ],
              )),
          new Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                '$_score',
                style: new TextStyle(fontSize: 24.0),
              ))
        ]);
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
      Navigator.of(context).pop();
      Navigator.push(context,
          new MaterialPageRoute<void>(builder: (BuildContext context) {
        return new ScoreScreen(
          myUser: AppStateContainer.of(context).state.loggedInUser,
          myScore: _score,
        );
      }));
    }
  }

  Widget buildSingleGame(BuildContext context, String keyName) {
    Random random = new Random();
    switch (widget.gameName) {
      case 'reflex':
        playTime = 15000;
        maxIterations = 1;
        return new Reflex(
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
                level: random.nextInt(10) + 1));
        break;
      case 'order_it':
        playTime = 15000;
        maxIterations = 1;
        return new OrderIt(
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
                level: random.nextInt(10) + 1));
        break;
      case 'true_or_false':
        return new TrueFalseGame(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'identify':
        return new IdentifyGame(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'abacus':
        return new Abacus(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'drawing':
        return new Drawing(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'bingo':
        return new Bingo(
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
                level: random.nextInt(10) + 1));
        break;
      case 'fill_in_the_blanks':
        playTime = 20000;
        maxIterations = 5;
        return new FillInTheBlanks(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'clue_game':
        return new ClueGame(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'casino':
        return new Casino(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'crossword':
        return new Crossword(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'tables':
        playTime = 60000;
        maxIterations = 1;
        return new Tables(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'match_the_following':
        playTime = 15000;
        maxIterations = 4;
        return new MatchTheFollowing(
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
                level: random.nextInt(10) + 1));
        break;
      case 'calculate_numbers':
        playTime = 25000;
        maxIterations = 10;
        return new CalculateTheNumbers(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'memory':
        playTime = 15000;
        maxIterations = 1;
        return new Memory(
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
                level: random.nextInt(10) + 1));
        break;
      case 'fill_number':
        return new Fillnumber(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'quiz':
        playTime = 15000;
        maxIterations = 10;
        return new Quiz(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'connect_the_dots':
        return new Connectdots(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'tap_home':
        playTime = 60000;
        maxIterations = 10;
        return new TapHome(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'tap_wrong':
        return new TapWrong(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'wordgrid':
        return new Wordgrid(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'guess':
        return new GuessIt(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated);
      case 'spin_wheel':
        return new SpinWheel(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'circle_word':
        return new Circleword(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;

      case 'draw_challenge':
        maxIterations = 1;
        return new Draw_Challenge(
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
                level: random.nextInt(10) + 1));
        break;
      case 'friend_word':
        maxIterations = 1;
        return new FriendWord(
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
                level: random.nextInt(10) + 1));
        break;
    }
    return null;
  }
}
