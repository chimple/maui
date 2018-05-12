import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/components/nima.dart';
import 'package:maui/components/progress_circle.dart';
import 'package:maui/games/clue_game.dart';
import 'package:maui/games/Draw_Challenge.dart';
import 'package:maui/games/true_false.dart';
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
  UnitMode questionUnitMode;
  UnitMode answerUnitMode;
  int gameCategoryId;
  int level;
  GameDisplay gameDisplay;

  GameConfig(
      {this.questionUnitMode,
      this.answerUnitMode,
      this.gameCategoryId,
      this.gameDisplay,
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
  final Key key;

  static final Map<String, List<Color>> gameColors = {
    'reflex': [Color(0xFF48AECC), Color(0xFFffb300), Color(0xFFD154BF)],
    'abacus': [Color(0xFFAD85F9), Color(0xFFFFB300), Color(0xFF43D162)],
    'bingo': [Color(0xFF52C5CE), Color(0xFFFAFAFA), Color(0xFFE25A9B)],
    'calculate_numbers': [
      Color(0xFFFFCE73),
      Color(0xFFff80ab),
      Color(0xFF74D1D6)
    ],
    'casino': [Color(0xFFD64C60), Color(0xFF734052), Color(0xFFf9a346)],
    'circle_word': [Color(0xFFA1EF6F), Color(0xFF7592BC), Color(0xFFFF9D7F)],
    'clue_game': [Color(0xFF57DBFF), Color(0xFFe27329), Color(0xFF77DB65)],
    'connect_the_dots': [
      Color(0xFFFF8481),
      Color(0xFF76abd3),
      Color(0xFFE068D5)
    ],
    'crossword': [Color(0xFF77DB65), Color(0xFFFAFAFA), Color(0xFF379EDD)],
    'draw_challenge': [Color(0xFFEDC23B), Color(0xFFef4822), Color(0xFF1EC1A1)],
    'drawing': [Color(0xFF66488C), Color(0xFFffb300), Color(0xFF1EA6AD)],
    'dice': [Color(0xFF66488c), Color(0xFFffb300), Color(0xFF282828)],
    'fill_in_the_blanks': [
      Color(0xFFDD6154),
      Color(0xFFa3bc8b),
      Color(0xFF9A66CC)
    ],
    'fill_number': [Color(0xFFEDC23B), Color(0xFFFFF1B8), Color(0xFF1EC1A1)],
    'friend_word': [Color(0xFF48AECC), Color(0xFFfcc335), Color(0xFFD154BF)],
    'guess': [Color(0xFF77DB65), Color(0xFFe58a28), Color(0xFF57C3FF)],
    'identify': [Color(0xFFA292FF), Color(0xFF9b671b), Color(0xFF52CC57)],
    'match_the_following': [
      Color(0xFFDD4785),
      Color(0xFFEFEFEF),
      Color(0xFFf99b67)
    ],
    'memory': [Color(0xFFFF7676), Color(0xFFffffca), Color(0xFF896EDB)],
    'order_it': [Color(0xFFE66796), Color(0xFF75F2F2), Color(0xFFFFBB22)],
    'quiz': [Color(0xFF35C9C1), Color(0xFFed4a79), Color(0xFFEDC23B)],
    'spin_wheel': [Color(0xFF30C9E2), Color(0xFFFFF176), Color(0xFFEE69A3)],
    'tables': [Color(0xFFA46DBA), Color(0xFFFF812C), Color(0xFF4FC449)],
    'tap_home': [Color(0xFF42AD56), Color(0xFFffdc48), Color(0xFF4AC8DD)],
    'tap_wrong': [Color(0xFFF47C5D), Color(0xFF30d858), Color(0xFFA367F9)],
    'true_or_false': [Color(0xFFF97658), Color(0xFF18c9c0), Color(0xFFDB5D87)],
    'wordgrid': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)]
  };

  SingleGame(this.gameName,
      {this.key,
      this.gameMode = GameMode.iterations,
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
        primaryColor:
            widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead
                ? colors[2]
                : colors[0],
        accentColor: colors[1]);
    var game =
        buildSingleGame(context, widget.gameConfig.gameDisplay.toString());
    return new Theme(
        data: theme,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.white,
            body: new Column(children: <Widget>[
              SizedBox(
                  height: media.size.height / 8.0,
                  child: Material(
                      elevation: 8.0,
                      color: widget.gameConfig.gameDisplay ==
                              GameDisplay.otherHeadToHead
                          ? colors[2]
                          : colors[0],
                      child: new Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: widget.gameConfig.gameDisplay !=
                                            GameDisplay.otherHeadToHead
                                        ? <Widget>[
                                            new Flexible(
                                                flex: 1,
                                                child: _hud(
                                                    context: context,
                                                    height:
                                                        media.size.height / 8.0,
                                                    backgroundColor: colors[2],
                                                    foregroundColor:
                                                        colors[1])),
                                            new Nima(
                                                name: widget.gameName,
                                                score: _score),
                                            new Flexible(
                                                child: Container(), flex: 1)
                                          ]
                                        : <Widget>[
                                            new Flexible(
                                                child: Container(), flex: 1),
                                            new Nima(
                                                name: widget.gameName,
                                                score: _score),
                                            new Flexible(
                                                flex: 1,
                                                child: _hud(
                                                    context: context,
                                                    height:
                                                        media.size.height / 8.0,
                                                    backgroundColor: colors[0],
                                                    foregroundColor:
                                                        colors[1])),
                                          ]),
                                new InkWell(
                                    child: new Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 36.0,
                                        )),
                                    onTap: () => Navigator.of(context).pop()),
                              ])))),
              new Expanded(
                  flex: 10,
                  child: new Stack(fit: StackFit.expand, children: <Widget>[
                    Image.asset(
                      'assets/background_tile.png',
                      repeat: ImageRepeat.repeat,
                    ),
                    game
                  ]))
            ])));
  }

  _hud(
      {BuildContext context,
      double height,
      Color backgroundColor,
      Color foregroundColor}) {
    height = height * 0.7;
    final fontSize = min(18.0, height / 2.5);
    var user = AppStateContainer.of(context).state.loggedInUser;

    var headers = <Widget>[
      new Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Container(
              width: height,
              height: height,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      image: new FileImage(new File(user.image)),
                      fit: BoxFit.fill))),
          new SizedBox(
              width: height,
              height: height,
              child: new CircularProgressIndicator(
                strokeWidth: height / 8.0,
                value: 1.0,
                valueColor: new AlwaysStoppedAnimation<Color>(backgroundColor),
              )),
          new SizedBox(
              width: height,
              height: height,
              child: widget.gameMode == GameMode.timed
                  ? new ProgressCircle(
                      time: playTime,
                      onEnd: () => _onGameEnd(context),
                      strokeWidth: height / 8.0,
                    )
                  : new ProgressCircle(
                      progress: _progress,
                      strokeWidth: height / 8.0,
                    )),
        ],
      ),
      new Column(
        crossAxisAlignment:
            widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            user.name,
            style: new TextStyle(fontSize: fontSize, color: foregroundColor),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$_score',
            style: new TextStyle(fontSize: fontSize, color: foregroundColor),
          )
        ],
      )
    ];

    return new Row(
        mainAxisAlignment:
            widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
        children: widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead
            ? headers.reversed.toList(growable: false)
            : headers);
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
    if (_iteration + 1 < maxIterations) {
      setState(() {
        _iteration++;
      });
    } else {
      _onGameEnd(context);
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
            gameConfig: widget.gameConfig);
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
