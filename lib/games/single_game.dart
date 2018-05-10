import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/nima.dart';
import 'package:maui/components/progress_circle.dart';
import 'package:maui/games/clue_game.dart';
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
import 'package:maui/games/dice_game.dart';
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

import 'package:maui/games/friendWord.dart';
import 'package:maui/games/word_fight.dart';
import 'package:maui/games/first_word.dart';

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
  final GameConfig gameConfig;
  final Function onGameEnd;
  final Function onScore;
  final GameMode gameMode;
  final bool isRotated;
  final GameDisplay gameDisplay;
  final Key key;

  static final Map<String, List<Color>> gameColors = {
    'reflex': [Color(0xFF52B3CC), Color(0xFFFF80AB), Color(0xFF36B241)],
    'abacus': [Color(0xFF492515), Color(0xFFffb300), Color(0xFF713D72)],
    'bingo': [Color(0xFF52c5ce), Color(0xFFfafafa), Color(0xFFE25A9B)],
    'calculate_numbers': [
      Color(0xFF6D3A6A),
      Color(0xFFff80ab),
      Color(0xFF42152D)
    ],
    'casino': [Color(0xFFD64C60), Color(0xFF734052), Color(0xFFf9a346)],
    'circle_word': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'clue_game': [Color(0xFF7ccc83c), Color(0xFFe27329), Color(0xFF301a0b)],
    'connect_the_dots': [
      Color(0xFFAF3773),
      Color(0xFF76abd3),
      Color(0xFF5B3C27)
    ],
    'crossword': [Color(0xFF37A061), Color(0xFFd32f2f), Color(0xFF2D1707)],
    'draw_challenge': [Color(0xFF3F1F12), Color(0xFFef4822), Color(0xFF673E6B)],
    'drawing': [Color(0xFF66488c), Color(0xFFffb300), Color(0xFF282828)],
    'dice': [Color(0xFF66488c), Color(0xFFffb300), Color(0xFF282828)],
    'fill_in_the_blanks': [
      Color(0xFF7A8948),
      Color(0xFFC79690),
      Color(0xFF7592BC)
    ],
    'fill_number': [Color(0xFFd83242), Color(0xFFa3bc8b), Color(0xFF663a5c)],
    'friend_word': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'guess': [Color(0xFF2abcaa), Color(0xFFe58a28), Color(0xFF7301a0b)],
    'identify': [Color(0xFF754cc70), Color(0xFF9b671b), Color(0xFF2D1505)],
    'match_the_following': [
      Color(0xFFDD4785),
      Color(0xFF3d3d3d),
      Color(0xFFf99b67)
    ],
    'memory': [Color(0xFF7F3B6C), Color(0xFFffffca), Color(0xFFD84C77)],
    'order_it': [Color(0xFF441c06), Color(0xFF2ed8d3), Color(0xFFe05570)],
    'quiz': [Color(0xFF35C9C1), Color(0xFFed4a79), Color(0xFF2D1A49)],
    'spin_wheel': [Color(0xFFD14AA1), Color(0xFF000000), Color(0xFFc14d4d)],
    'tables': [Color(0xFFED546A), Color(0xFF5b1d12), Color(0xFF54cc70)],
    'tap_home': [Color(0xFFDD5E5E), Color(0xFFffdc48), Color(0xFF42AD56)],
    'tap_wrong': [Color(0xFF331A0A), Color(0xFF30d858), Color(0xFF6d4103)],
    'true_or_false': [Color(0xFFDD4A74), Color(0xFF18c9c0), Color(0xFFEF886C)],
    'wordgrid': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)]
  };

  SingleGame(this.gameName,
      {this.key,
      this.gameMode = GameMode.iterations,
      this.gameDisplay = GameDisplay.single,
      this.gameConfig,
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
    var theme = new ThemeData(
        primaryColor: widget.gameDisplay == GameDisplay.otherHeadToHead
            ? colors[2]
            : colors[0],
        accentColor: colors[1]);
    var game = buildSingleGame(context, widget.gameDisplay.toString());
    return new Theme(
        data: theme,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            body: new Column(children: <Widget>[
              new Material(
                  elevation: 8.0,
                  color: widget.gameDisplay == GameDisplay.otherHeadToHead
                      ? colors[2]
                      : colors[0],
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.gameDisplay == GameDisplay.single
                          ? <Widget>[
                              new Expanded(
                                child: new Row(children: <Widget>[
                                  new InkWell(
                                      child: new Icon(Icons.arrow_back),
                                      onTap: () => Navigator.of(context).pop()),
                                  _hud(context)
                                ]),
                                flex: 1,
                              ),
                              new Expanded(
                                  child: new Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: new Nima(
                                          name: widget.gameName,
                                          score: _score)),
                                  flex: 1),
                              new Expanded(child: new Text('$_score'), flex: 1)
                            ]
                          : <Widget>[_hud(context), new Text('$_score')])),
              new Expanded(
                  child: new Stack(fit: StackFit.expand, children: <Widget>[
                Image.asset(
                  'assets/background_tile.png',
                  repeat: ImageRepeat.repeat,
                ),
                game
              ]))
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
      _score = max(0, _score + incrementScore);
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
          gameName: widget.gameName,
          gameDisplay: GameDisplay.single,
          myUser: AppStateContainer.of(context).state.loggedInUser,
          myScore: _score,
        );
      }));
    }
  }

  Widget buildSingleGame(BuildContext context, String keyName) {
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
            gameConfig: widget.gameConfig);
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
            gameConfig: widget.gameConfig);
        break;
      case 'true_or_false':
        playTime = 15000;
        maxIterations = 10;
        return new TrueFalseGame(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameConfig: widget.gameConfig);
        break;
      case 'drawing':
        return new Drawing(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'dice':
        return new Dice(
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
            gameConfig: widget.gameConfig);
        break;
      case 'fill_in_the_blanks':
        playTime = 20000;
        maxIterations = 10;
        return new FillInTheBlanks(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'clue_game':
        return new ClueGame(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'casino':
        return new Casino(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameConfig: widget.gameConfig);
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
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameConfig: widget.gameConfig);
        break;
      case 'fill_number':
        return new Fillnumber(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'connect_the_dots':
        return new Connectdots(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'tap_wrong':
        return new TapWrong(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'wordgrid':
        return new Wordgrid(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'circle_word':
        return new Circleword(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
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
            gameConfig: widget.gameConfig);
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
            gameConfig: widget.gameConfig);
        break;
      case 'first_word':
        return new FirstWord(
          key: new GlobalObjectKey(keyName),
          onScore: _onScore,
          onProgress: _onProgress,
          onEnd: () => _onEnd(context),
          iteration: _iteration,
          isRotated: widget.isRotated,
        );
        break;
      case 'word_fight':
        return new WordFight(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
    }
    return null;
  }
}
