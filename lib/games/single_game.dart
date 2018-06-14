import 'dart:io';
import 'dart:math';
import 'dart:async';

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
import 'package:maui/games/picture_sentence.dart';
import 'package:maui/screens/score_screen.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/components/hud.dart';
import 'package:maui/games/friendWord.dart';
import 'package:maui/games/word_fight.dart';
import 'package:maui/games/first_word.dart';

enum GameMode { timed, iterations }

enum GameDisplay {
  single,
  myHeadToHead,
  otherHeadToHead,
  localTurnByTurn,
  networkTurnByTurn
}

enum UnitMode { text, image, audio }

class GameConfig {
  UnitMode questionUnitMode;
  UnitMode answerUnitMode;
  int gameCategoryId;
  int level;
  GameDisplay gameDisplay;
  User otherUser;
  int myScore;
  int otherScore;
  bool amICurrentPlayer;
  Orientation orientation;
  //board
  //local or n/w

  GameConfig(
      {this.questionUnitMode,
      this.answerUnitMode,
      this.gameCategoryId,
      this.gameDisplay,
      this.level,
      this.otherUser,
      this.myScore,
      this.otherScore,
      this.orientation,
      this.amICurrentPlayer});
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
    'wordgrid': [Color(0xFF7A8948), Color(0xFFC79690), Color(0xFF7592BC)],
    'picture_sentence': [
      Color(0xFF7A8948),
      Color(0xFFC79690),
      Color(0xFF7592BC)
    ]
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

class _SingleGameState extends State<SingleGame> with TickerProviderStateMixin {
  double _myProgress = 0.0;
  double _otherProgress = 0.0;
  int _myIteration = 0;
  int _otherIteration = 0;
  int maxIterations = 2;
  int playTime = 10000;
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
//    SystemChrome.setEnabledSystemUIOverlays([]);
    if (widget.gameConfig.gameDisplay != GameDisplay.myHeadToHead ||
        widget.gameConfig.gameDisplay != GameDisplay.otherHeadToHead) {
      if (widget.gameConfig.orientation == Orientation.landscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    }
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    final CurvedAnimation curve =
        new CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _animation =
        new Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.0))
            .animate(curve);
    new Future.delayed(const Duration(milliseconds: 250), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
//    SystemChrome.setEnabledSystemUIOverlays(
//        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([]);
    _controller?.dispose();
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
    final oh2h = widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead;
    return new Theme(
        data: theme,
        child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: colors[0],
            body: new SafeArea(
                child: Stack(fit: StackFit.expand, children: <Widget>[
              Image.asset(
                'assets/background_tile.png',
                repeat: ImageRepeat.repeat,
              ),
              new Column(verticalDirection: VerticalDirection.up, children: <
                  Widget>[
                new Expanded(
                    child: SlideTransition(position: _animation, child: game)),
                SizedBox(
                    height: media.size.height / 8.0,
                    child: Material(
                        elevation: 8.0,
                        color: oh2h ? colors[2] : colors[0],
                        child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              !oh2h
                                  ? Positioned(
                                      left: 0.0,
                                      top: 0.0,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        color: Colors.white,
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ))
                                  : Container(),
                              new Positioned(
                                  left: !oh2h ? 32.0 : null,
                                  right: oh2h ? 32.0 : null,
                                  child: Hud(
                                      user: AppStateContainer
                                          .of(context)
                                          .state
                                          .loggedInUser,
                                      height: media.size.height / 8.0,
                                      gameMode: widget.gameMode,
                                      playTime: playTime,
                                      onEnd: widget.onGameEnd,
                                      progress: _myProgress,
                                      start: !oh2h,
                                      score: widget.gameConfig.myScore,
                                      backgroundColor:
                                          oh2h ? colors[0] : colors[2],
                                      foregroundColor: colors[1])),
                              new Center(
                                child: Nima(
                                    name: widget.gameName,
                                    score: widget.gameConfig.myScore,
                                    tag: !oh2h
                                        ? 'assets/hoodie/${widget.gameName}.png'
                                        : 'other.png'),
                              ),
                              widget.gameConfig.gameDisplay ==
                                          GameDisplay.localTurnByTurn ||
                                      widget.gameConfig.gameDisplay ==
                                          GameDisplay.networkTurnByTurn
                                  ? Positioned(
                                      right: 32.0,
                                      child: Hud(
                                          start: false,
                                          user: widget.gameConfig.otherUser,
                                          height: media.size.height / 8.0,
                                          gameMode: widget.gameMode,
                                          playTime: playTime,
                                          onEnd: widget.onGameEnd,
                                          progress: _otherProgress,
                                          score: widget.gameConfig.otherScore,
                                          backgroundColor: colors[2],
                                          foregroundColor: colors[1]))
                                  : Container(),
                              widget.gameConfig.gameDisplay ==
                                          GameDisplay.localTurnByTurn ||
                                      widget.gameConfig.gameDisplay ==
                                          GameDisplay.networkTurnByTurn
                                  ? new AnimatedPositioned(
                                      key: ValueKey<String>('currentPlayer'),
                                      left: widget.gameConfig.amICurrentPlayer
                                          ? 32.0
                                          : media.size.width -
                                              32.0 -
                                              media.size.height / 8.0 * 0.6,
                                      bottom: 0.0,
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.elasticOut,
                                      child: Container(
                                        color: colors[1],
                                        width: media.size.height / 8.0 * 0.6,
                                        height: 8.0,
                                      ),
                                    )
                                  : Container()
                            ])))
              ]),
            ]))));
  }

  _onScore(int incrementScore) {
    setState(() {
      if (widget.gameConfig.amICurrentPlayer) {
        widget.gameConfig.myScore =
            max(0, widget.gameConfig.myScore + incrementScore);
      } else {
        widget.gameConfig.otherScore =
            max(0, widget.gameConfig.otherScore + incrementScore);
      }
    });
    //for now we only pass myscore up to the head to head
    if (widget.onScore != null) widget.onScore(widget.gameConfig.myScore);
  }

  _onProgress(double progress) {
    if (widget.gameMode == GameMode.iterations) {
      setState(() {
        if (widget.gameConfig.amICurrentPlayer) {
          _myProgress = (_myIteration + progress) / maxIterations;
        } else {
          _otherProgress = (_otherIteration + progress) / maxIterations;
        }
      });
    }
  }

  _onEnd(BuildContext context) {
    if (widget.gameConfig.amICurrentPlayer) {
      setState(() {
        _myIteration++;
      });
      if (_myIteration >= maxIterations &&
          widget.gameConfig.gameDisplay != GameDisplay.localTurnByTurn)
        _onGameEnd(context);
    } else {
      setState(() {
        _otherIteration++;
      });
      if (_otherIteration >= maxIterations) _onGameEnd(context);
    }
    if (widget.gameConfig.gameDisplay == GameDisplay.localTurnByTurn ||
        widget.gameConfig.gameDisplay == GameDisplay.networkTurnByTurn) {
      widget.gameConfig.amICurrentPlayer = !widget.gameConfig.amICurrentPlayer;
    }
  }

  _onTurn(BuildContext context) {
    widget.gameConfig.amICurrentPlayer = !widget.gameConfig.amICurrentPlayer;
  }

  _onGameEnd(BuildContext context) {
    if (widget.onGameEnd != null) {
      widget.onGameEnd(context);
    } else {
      // Navigator.of(context).pop();
      Navigator.push(context,
          new MaterialPageRoute<void>(builder: (BuildContext context) {
        return new ScoreScreen(
          gameName: widget.gameName,
          gameDisplay: GameDisplay.single,
          myUser: AppStateContainer.of(context).state.loggedInUser,
          myScore: widget.gameConfig.myScore,
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
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'identify':
        maxIterations = 1;
        return new IdentifyGame(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _myIteration);
        break;
      case 'abacus':
        playTime = 15000;
        maxIterations = 1;
        return new Abacus(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'drawing':
        return new Drawing(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _myIteration);
        break;
      case 'dice':
        return new Dice(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'bingo':
        return new Bingo(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'clue_game':
        return new ClueGame(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'casino':
        return new Casino(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'crossword':
        playTime = 15000;
        maxIterations = 1;
        return new Crossword(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'tables':
        playTime = 60000;
        maxIterations = 1;
        return new Tables(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'fill_number':
        return new Fillnumber(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'picture_sentence':
        return new PictureSentence(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'connect_the_dots':
        return new Connectdots(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'tap_wrong':
        playTime = 15000;
        maxIterations = 4;
        return new TapWrong(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'wordgrid':
        playTime = 15000;
        maxIterations = 2;
        return new Wordgrid(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'guess':
        maxIterations = 1;
        return new GuessIt(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated);
      case 'spin_wheel':
        return new SpinWheel(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'circle_word':
        return new Circleword(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
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
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'first_word':
        return new FirstWord(
          key: new GlobalObjectKey(keyName),
          onScore: _onScore,
          onProgress: _onProgress,
          onEnd: () => _onEnd(context),
          iteration: _myIteration + _otherIteration,
          isRotated: widget.isRotated,
        );
        break;
      case 'word_fight':
        return new WordFight(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _myIteration + _otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
    }
    return null;
  }
}
