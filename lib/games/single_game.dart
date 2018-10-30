import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:maui/components/show_help.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maui/state/button_state_container.dart';
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
import 'package:maui/quiz/quiz_pager.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:maui/repos/score_repo.dart';
import 'package:maui/db/entity/score.dart';
import 'package:maui/repos/notif_repo.dart';
import 'package:maui/repos/log_repo.dart';
import 'package:maui/repos/game_category_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/components/gameaudio.dart';
import 'package:maui/db/entity/lesson.dart';

import '../components/progress_bar.dart';

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
  String topicId;
  int level;
  GameDisplay gameDisplay;
  User myUser;
  User otherUser;
  int myScore;
  int otherScore;
  int myIteration;
  int otherIteration;
  bool amICurrentPlayer;
  Orientation orientation;
  Map<String, dynamic> gameData;
  String sessionId;
  bool isGameOver;
  //board
  //local or n/w

  @override
  String toString() {
    return 'GameConfig{questionUnitMode: $questionUnitMode, answerUnitMode: $answerUnitMode, gameCategoryId: $gameCategoryId, topicId: $topicId, level: $level, gameDisplay: $gameDisplay, myUser: $myUser, otherUser: $otherUser, myScore: $myScore, otherScore: $otherScore, myIteration: $myIteration, otherIteration: $otherIteration, amICurrentPlayer: $amICurrentPlayer, orientation: $orientation, gameData: $gameData, sessionId: $sessionId, isGameOver: $isGameOver}';
  }

  GameConfig(
      {this.questionUnitMode,
      this.answerUnitMode,
      this.gameCategoryId,
      this.topicId = "lion", //TODO: This is a temporary initialization
      this.gameDisplay,
      this.level,
      this.otherUser,
      this.myUser,
      this.myScore,
      this.otherScore,
      this.myIteration = 0,
      this.otherIteration = 0,
      this.orientation,
      this.gameData,
      this.sessionId,
      this.isGameOver = false,
      this.amICurrentPlayer});

  String toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionUnitMode'] = questionUnitMode.index;
    data['answerUnitMode'] = answerUnitMode.index;
    data['gameCategoryId'] = gameCategoryId;
    data['topicId'] = topicId;
    data['gameDisplay'] = gameDisplay.index;
    data['level'] = level;
    data['myScore'] = myScore;
    data['otherScore'] = otherScore;
    data['myIteration'] = myIteration;
    data['otherIteration'] = otherIteration;
    data['gameData'] = gameData;
    data['isGameOver'] = isGameOver;
    return json.encode(data);
  }

  GameConfig.fromJson(String jsonStr) {
    Map<String, dynamic> data = json.decode(jsonStr);
    questionUnitMode = UnitMode.values[data['questionUnitMode']];
    answerUnitMode = UnitMode.values[data['answerUnitMode']];
    gameCategoryId = data['gameCategoryId'];
    topicId = data['topicId'];
    gameDisplay = GameDisplay.values[data['gameDisplay']];
    level = data['level'];
    myScore = data['myScore'];
    otherScore = data['otherScore'];
    myIteration = data['myIteration'];
    otherIteration = data['otherIteration'];
    gameData = data['gameData'];
    isGameOver = data['isGameOver'];
  }
}

enum Learning { literacy, maths }

class SingleGame extends StatefulWidget {
  final String gameName;
  final GameConfig gameConfig;

  final Function onGameEnd;
  final Function onScore; //TODO: Can be removed
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
    'first_word': [Color(0xFFEB706F), Color(0xFFa9b78a), Color(0xFF8C82D8)],
    'circle_word': [Color(0xFFA1EF6F), Color(0xFF7592BC), Color(0xFFFF9D7F)],
    'clue_game': [Color(0xFF57DBFF), Color(0xFFe27329), Color(0xFF77DB65)],
    'connect_the_dots': [
      Color(0xFFFF8481),
      Color(0xFF76abd3),
      Color(0xFFE068D5)
    ],
    'crossword': [Color(0xFF56EDE6), Color(0xFFD32F2F), Color(0xFF379EDD)],
    'draw_challenge': [Color(0xFFEDC23B), Color(0xFFef4822), Color(0xFF1EC1A1)],
    'drawing': [Color(0xFF66488C), Color(0xFFffb300), Color(0xFF1EA6AD)],
    'dice': [Color(0xFF66488c), Color(0xFFffb300), Color(0xFF282828)],
    'fill_in_the_blanks': [
      Color(0xFFDD6154),
      Color(0xFFffb300),
      Color(0xFF9A66CC)
    ],
    'fill_number': [Color(0xFFEDC23B), Color(0xFFFFF1B8), Color(0xFF1EC1A1)],
    'friend_word': [Color(0xFF48AECC), Color(0xFFfcc335), Color(0xFFD154BF)],
    'guess': [Color(0xFF77DB65), Color(0xFFe58a28), Color(0xFF57C3FF)],
    'identify': [Color(0xFFA292FF), Color(0xFF9b671b), Color(0xFF52CC57)],
    'match_the_following': [
      Color(0xFFDD4785),
      Color(0xFF9b671b),
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
    'wordgrid': [Color(0xFFFF7D8F), Color(0xFFDAECF7), Color(0xFFFFCB57)],
    'picture_sentence': [
      Color(0xFF1DC8CC),
      Color(0xFF282828),
      Color(0xFFFE6677)
    ],
    'quiz_pager': [Color(0xFF1DC8CC), Color(0xFF282828), Color(0xFFFE6677)]
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
  int maxIterations = 2;
  int playTime = 10000;
  AnimationController _controller;
  Animation<Offset> _animation;
  int _cumulativeIncrement = 0;

  @override
  void initState() {
    super.initState();
//    SystemChrome.setEnabledSystemUIOverlays([]);
    print('_SingleGameState: initState');
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
    _initData();
    if (widget.gameConfig.isGameOver) {
      _onGameEnd(context, ack: true);
      return;
    }
  }

  void _initData() async {
    if (widget.gameConfig.gameDisplay == GameDisplay.networkTurnByTurn &&
        widget.gameConfig.myIteration > 1 &&
        widget.gameConfig.amICurrentPlayer) {
      await NotifRepo()
          .increment(widget.gameConfig.otherUser.id, widget.gameName, -1);
    }
    writeLog('game,${widget.gameName},${widget.gameConfig}');
  }

  @override
  void dispose() {
//    SystemChrome.setEnabledSystemUIOverlays(
//        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([]);
    _controller?.dispose();
    super.dispose();
  }

  Widget alertDialog(BuildContext context) {
    var colors = SingleGame.gameColors[widget.gameName];
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: new Container(
          width: 350.0,
          height: 200.0,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
          ),
          child: new Container(
              child: new Column(
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              new Text(
                'Exit?',
                style: TextStyle(
                    color: colors[1],
                    fontStyle: FontStyle.normal,
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold),
              ),
              new Row(
                children: <Widget>[
                  new Padding(
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 40.0),
                      width: 130.0,
                      decoration: BoxDecoration(
                        color: colors[0],
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xFF919191),
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 6.0),
                          )
                        ],
                      ),
                      child: new FlatButton(
                        child: Center(
                          child: IconButton(
                            iconSize: 40.0,
                            alignment: AlignmentDirectional.bottomStart,
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: null,
                          ),
                        ),
                        onPressed: () {
                          AppStateContainer.of(context).play('_audiotap.mp3');
                          Navigator.of(context).pop(false);
                        },
                      )),
                  new Padding(
                    padding: EdgeInsets.only(right: 70.0),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 40.0),
                      width: 130.0,
                      decoration: BoxDecoration(
                        color: colors[0],
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xFF919191),
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 6.0),
                          )
                        ],
                      ),
                      child: new FlatButton(
                        child: Center(
                          child: IconButton(
                            iconSize: 40.0,
                            alignment: AlignmentDirectional.bottomStart,
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: null,
                          ),
                        ),
                        onPressed: () {
                          AppStateContainer.of(context).play('_audiotap.mp3');
                          Navigator.of(context)
                              .popUntil(ModalRoute.withName('/tab'));
                        },
                      )),
                ],
              )
            ],
          ))),
    ));
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: alertDialog,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    print('_SingleGameState:build: ${widget.gameConfig}');
    print("this i want know topicid is,,,,...::${widget.gameConfig.topicId}");

    MediaQueryData media = MediaQuery.of(context);
    print(media.size);
    var size = media.size;
    double progregressPading = media.size.width / 2;
    print(widget.key.toString());
    var _scaffoldKey = new GlobalKey<ScaffoldState>();
    print("scaffold key is....::$_scaffoldKey");
    var colors = SingleGame.gameColors[widget.gameName];
    var theme = new ThemeData(
        primaryColor:
            widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead
                ? colors[2]
                : colors[0],
        accentColor: colors[1]);
    var game =
        buildSingleGame(context, widget.gameConfig.gameDisplay.toString());

    print("this... my game in the quize iiss......::${game.runtimeType}");
    final mh2h = widget.gameConfig.gameDisplay == GameDisplay.myHeadToHead;
    final oh2h = widget.gameConfig.gameDisplay == GameDisplay.otherHeadToHead;
    print("here we have to check the oh2h....::$oh2h");

    print(
        "this is height when its comes to head to head,,,....::${media.size.width}");
    var headers = <Widget>[
      Hud(
          user: widget.gameConfig.myUser,
          height: media.size.height / 8,
          gameMode: widget.gameMode,
          playTime: playTime,
          onEnd: widget.onGameEnd,
          progress: _myProgress,
          start: !oh2h,
          score: widget.gameConfig.myScore,
          backgroundColor: oh2h ? colors[0] : colors[2],
          foregroundColor: colors[1]),

      //     Padding(
      //     padding: !oh2h && !mh2h
      //             ? media.size.width > media.size.height
      //                 ? EdgeInsets.all(progregressPading -
      //                     (media.size.width / 2.8) / 2 -
      //                     32 -
      //                     media.size.height / 8)
      //                 : EdgeInsets.all(progregressPading -
      //                     (media.size.width / 2.8) / 2 -
      //                     32 -
      //                     media.size.height / 8)
      //             : EdgeInsets.all((progregressPading / 1.5 -
      //                     (media.size.width / 2.8) / 3 -
      //                     32 -
      //                     media.size.height / 8) /
      //                 2),
      //       child: Container(
      //         height: 150.0,
      //         color: Colors.white,
      //         child: new Column(
      //           children: <Widget>[
      //              Container(
      //   child: Stack(children: [
      //         Padding(
      //           padding: const EdgeInsets.all(10.0),
      //           child: Text(
      //             '${widget.gameConfig.myScore}',
      //             style: new TextStyle(fontSize: 20.0, color: colors[1]),
      //           ),
      //         ),
      //   ]),
      // ),
      // widget.gameConfig.amICurrentPlayer
      //         ? Padding(
      //           padding: const EdgeInsets.all(10.0),
      //           child: new Stack(
      //             alignment: AlignmentDirectional.center,
      //             // crossAxisAlignment:
      //             //     start ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      //             // mainAxisAlignment: MainAxisAlignment.spaceAround
      //             children: <Widget>[
      //               Card(
      //                 shape: RoundedRectangleBorder(
      //                     borderRadius: BorderRadius.circular(15.0)),
      //                 child: new SizedBox(
      //                     width: !oh2h && !mh2h
      //                         ? media.size.width > media.size.height
      //                             ? media.size.width / 2.8
      //                             : media.size.width / 2.25
      //                         : media.size.width / 3.5,
      //                     height: 25.0,
      //                     child: new LinearProgressIndicator(
      //                       // strokeWidth: height / 8.0,
      //                       value: 1.0,
      //                       valueColor: new AlwaysStoppedAnimation<Color>(
      //                           oh2h ? colors[0] : colors[2]),
      //                     )),
      //               ),
      //               Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(15.0),
      //                 ),
      //                 child: new SizedBox(
      //                     width: !oh2h && !mh2h
      //                         ? media.size.width > media.size.height
      //                             ? media.size.width / 2.8
      //                             : media.size.width / 2.25
      //                         : media.size.width / 3.5,
      //                     height: 25.0,
      //                     child: widget.gameMode == GameMode.timed
      //                         ? new ProgressBar(
      //                             time: playTime,
      //                             onEnd: () => widget.onGameEnd(context),
      //                             // strokeWidth: height / 8.0,
      //                           )
      //                         : new ProgressBar(
      //                             progress: _myProgress,
      //                             // strokeWidth: height / 8.0,
      //                           )),
      //               ),
      //             ],
      //           ),
      //         )
      //         : new Container()
      //           ],
      //         ),
      //       ),
      //     ),
    ];
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Theme(
        data: theme,
        child: Scaffold(
            key: _scaffoldKey,
            endDrawer: new ShowHelp(topicId: widget.gameConfig.topicId),
            resizeToAvoidBottomPadding: false,
            body: new SafeArea(
                top: false,
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  Image.asset(
                    'assets/background_tile.png',
                    repeat: ImageRepeat.repeat,
                  ),
                  new Column(
                      verticalDirection: VerticalDirection.up,
                      children: <Widget>[
                        new Expanded(
                            child: SlideTransition(
                                position: _animation,
                                child: ButtonStateContainer(child: game))),
                        SizedBox(
                            height: media.size.height / 8.0,
                            child: Material(
                              elevation: 8.0,
                              color: oh2h ? colors[2] : colors[0],
                              child: Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: <Widget>[
                                    new Positioned(
                                        left: !oh2h ? 32.0 : null,
                                        right: oh2h ? 32.0 : null,
                                        child: Hud(
                                            user: widget.gameConfig.myUser,
                                            height: media.size.height / 8,
                                            width: media.size.width / 2,
                                            gameMode: widget.gameMode,
                                            playTime: playTime,
                                            onEnd: widget.onGameEnd,
                                            progress: _myProgress,
                                            start: !oh2h,
                                            score: widget.gameConfig.myScore,
                                            backgroundColor:
                                                oh2h ? colors[0] : colors[2],
                                            foregroundColor: colors[1])),
                                    //  game.runtimeType==QuizPager
                                    //       ? Container()
                                    //       : new Center(
                                    //           child: Nima(
                                    //               name: widget.gameName,
                                    //               score: _cumulativeIncrement,
                                    //               tag: !oh2h
                                    //                   ? 'assets/hoodie/${widget.gameName}.png'
                                    //                   : 'other.png'),
                                    //         ),
                                    !oh2h
                                        ? Positioned(
                                            left: 0.0,
                                            top: 0.0,
                                            child: IconButton(
                                              icon: Icon(Icons.arrow_back),
                                              color: Colors.white,
                                              onPressed: () {
                                                AppStateContainer.of(context)
                                                    .play('_audiotap.mp3');
                                                _onWillPop();
                                              },
                                            ))
                                        : Container(),
                                    !oh2h
                                        ? Positioned(
                                            right: 0.0,
                                            top: 0.0,
                                            child: IconButton(
                                              icon: Icon(Icons.help_outline),
                                              color: Colors.white,
                                              onPressed: () {
                                                print(
                                                    "scaffold data is.......::${_scaffoldKey.currentState}");
                                                _scaffoldKey.currentState
                                                    .openEndDrawer();
                                              },
                                            ))
                                        : Container(),
                                    widget.gameConfig.gameDisplay ==
                                                GameDisplay.localTurnByTurn ||
                                            widget.gameConfig.gameDisplay ==
                                                GameDisplay.networkTurnByTurn
                                        ? Positioned(
                                            right: 32.0,
                                            child: Hud(
                                                start: false,
                                                amICurrentUser: widget
                                                    .gameConfig
                                                    .amICurrentPlayer,
                                                user:
                                                    widget.gameConfig.otherUser,
                                                width: media.size.width / 2,
                                                height: media.size.height / 8.0,
                                                gameMode: widget.gameMode,
                                                playTime: playTime,
                                                onEnd: widget.onGameEnd,
                                                progress: _otherProgress,
                                                score: widget
                                                    .gameConfig.otherScore,
                                                backgroundColor: colors[2],
                                                foregroundColor: colors[1]))
                                        : Container(),
                                    widget.gameConfig.gameDisplay ==
                                                GameDisplay.localTurnByTurn ||
                                            widget.gameConfig.gameDisplay ==
                                                GameDisplay.networkTurnByTurn
                                        ? new AnimatedPositioned(
                                            key: ValueKey<String>(
                                                'currentPlayer'),
                                            left: widget
                                                    .gameConfig.amICurrentPlayer
                                                ? 32.0
                                                : media.size.width -
                                                    32.0 -
                                                    media.size.height /
                                                        8.0 *
                                                        0.6,
                                            bottom: 0.0,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.elasticOut,
                                            child: Container(
                                              color: colors[1],
                                              width:
                                                  media.size.height / 8.0 * 0.6,
                                              height: 8.0,
                                            ),
                                          )
                                        : Container()
                                  ]),
                            ))
                      ]),
                ]))),
      ),
    );
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
      _cumulativeIncrement += incrementScore;
    });
    //for now we only pass myscore up to the head to head
    //if (widget.onScore != null) widget.onScore(widget.gameConfig.myScore);
  }

  _onProgress(double progress) {
    if (widget.gameMode == GameMode.iterations) {
      setState(() {
        if (widget.gameConfig.amICurrentPlayer) {
          _myProgress =
              (widget.gameConfig.myIteration + progress) / maxIterations;
        } else {
          _otherProgress =
              (widget.gameConfig.otherIteration + progress) / maxIterations;
        }
      });
    }
  }

  _onEnd(BuildContext context,
      {Map<String, dynamic> gameData, bool end = false}) async {
    widget.gameConfig.gameData = gameData;
    print('_onEnd gameData: $gameData');
    if (widget.gameConfig.amICurrentPlayer) {
      setState(() {
        widget.gameConfig.myIteration++;
      });
    } else {
      setState(() {
        widget.gameConfig.otherIteration++;
      });
    }

    if (widget.gameConfig.gameDisplay != GameDisplay.localTurnByTurn &&
        widget.gameConfig.gameDisplay != GameDisplay.networkTurnByTurn) {
      if (maxIterations > 0) {
        if (widget.gameConfig.amICurrentPlayer) {
          if (widget.gameConfig.myIteration >= maxIterations)
//            _onGameEnd(context, gameData: gameData);
            widget.gameConfig.isGameOver = true;
        } else {
          if (widget.gameConfig.otherIteration >= maxIterations)
//            _onGameEnd(context);
            widget.gameConfig.isGameOver = true;
        }
      } else {
        if (end) {
//          _onGameEnd(context, gameData: gameData);
          widget.gameConfig.isGameOver = true;
        }
      }
      if (widget.gameConfig.isGameOver) {
        _onGameEnd(context, gameData: gameData);
      }
    } else {
      widget.gameConfig.amICurrentPlayer = !widget.gameConfig.amICurrentPlayer;
      if (maxIterations > 0) {
        //since we have already switched amICurrentPlayer, test for reverse condition
//        if (!widget.gameConfig.amICurrentPlayer) {
//          if (widget.gameConfig.myIteration >= maxIterations &&
//              widget.gameConfig.gameDisplay == GameDisplay.networkTurnByTurn)
////            _onGameEnd(context, gameData: gameData);
//            widget.gameConfig.isGameOver = true;
//        } else {
//          if (widget.gameConfig.otherIteration >= maxIterations &&
//              widget.gameConfig.gameDisplay == GameDisplay.localTurnByTurn)
////            _onGameEnd(context);
//            widget.gameConfig.isGameOver = true;
//        }
        if (widget.gameConfig.myIteration >= maxIterations &&
            widget.gameConfig.otherIteration >= maxIterations) {
          widget.gameConfig.isGameOver = true;
        }
      } else {
        if (end) {
//          _onGameEnd(context, gameData: gameData);
          widget.gameConfig.isGameOver = true;
        }
      }
      if (widget.gameConfig.gameDisplay == GameDisplay.networkTurnByTurn) {
        try {
          await p2p.addMessage(
              widget.gameConfig.myUser.id,
              widget.gameConfig.otherUser.id,
              widget.gameName,
              widget.gameConfig.toJson(),
              true,
              widget.gameConfig.sessionId ?? Uuid().v4());
        } on PlatformException {
          print('Flores: Failed addMessage');
        } catch (e, s) {
          print('Exception details:\n $e');
          print('Stack trace:\n $s');
        }
      }
      if (widget.gameConfig.isGameOver) {
        _onGameEnd(context, gameData: gameData);
      }
      if (widget.gameConfig.gameDisplay == GameDisplay.networkTurnByTurn) {
        Navigator.push(context,
            new MaterialPageRoute<void>(builder: (BuildContext context) {
          final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
          return new ScoreScreen(
            gameName: widget.gameName,
            gameDisplay: widget.gameConfig.gameDisplay,
            myUser: loggedInUser,
            myScore: loggedInUser == widget.gameConfig.myUser
                ? widget.gameConfig.myScore
                : widget.gameConfig.otherScore,
            otherUser: loggedInUser == widget.gameConfig.myUser
                ? widget.gameConfig.otherUser
                : widget.gameConfig.myUser,
            otherScore: loggedInUser == widget.gameConfig.myUser
                ? widget.gameConfig.otherScore
                : widget.gameConfig.myScore,
            isGameOver: false,
          );
        }));
      }
    }
  }

  _onGameEnd(BuildContext context,
      {Map<String, dynamic> gameData, bool ack = false}) async {
    if (widget.gameConfig.gameDisplay == GameDisplay.networkTurnByTurn && ack) {
      widget.gameConfig.amICurrentPlayer = !widget.gameConfig.amICurrentPlayer;
      try {
        await p2p.addMessage(
            widget.gameConfig.myUser.id,
            widget.gameConfig.otherUser.id,
            widget.gameName,
            widget.gameConfig.toJson(),
            false,
            widget.gameConfig.sessionId ?? Uuid().v4());
      } on PlatformException {
        print('Failed getting messages');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
    }
    ScoreRepo().insert(Score(
        myUser: widget.gameConfig.myUser.id,
        otherUser: widget.gameConfig.otherUser?.id,
        myScore: widget.gameConfig.myScore,
        otherScore: widget.gameConfig.otherScore,
        game: widget.gameName,
        playedAt: DateTime.now().millisecondsSinceEpoch));
    writeLog(
        'score,${widget.gameName},${widget.gameConfig.gameCategoryId},${widget.gameConfig.myUser.id},${widget.gameConfig.otherUser?.id},${widget.gameConfig.myScore},${widget.gameConfig.otherScore}');
    var lessonId = await new GameCategoryRepo().getLessonIdByGameCategoryId(
        widget.gameName, widget.gameConfig.gameCategoryId);
    if (lessonId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var numPlays = prefs.getInt('lessonId$lessonId') ?? 0;
      if (++numPlays >= 3 &&
          AppStateContainer.of(context).state.loggedInUser.currentLessonId <
              Lesson.maxLessonId) {
        AppStateContainer.of(context).state.loggedInUser.currentLessonId++;
        await UserRepo()
            .update(AppStateContainer.of(context).state.loggedInUser);
      }
      prefs.setInt('lessonId$lessonId', numPlays);
    }

    if (widget.onGameEnd != null) {
      widget.onGameEnd(context);
    } else {
      Navigator.push(context,
          new MaterialPageRoute<void>(builder: (BuildContext context) {
        final loggedInUser = AppStateContainer.of(context).state.loggedInUser;
        return new ScoreScreen(
          gameName: widget.gameName,
          gameDisplay: widget.gameConfig.gameDisplay,
          myUser: loggedInUser,
          myScore: loggedInUser == widget.gameConfig.myUser
              ? widget.gameConfig.myScore
              : widget.gameConfig.otherScore,
          otherUser: loggedInUser == widget.gameConfig.myUser
              ? widget.gameConfig.otherUser
              : widget.gameConfig.myUser,
          otherScore: loggedInUser == widget.gameConfig.myUser
              ? widget.gameConfig.otherScore
              : widget.gameConfig.myScore,
        );
      }));
    }
  }

  Widget buildSingleGame(BuildContext context, String keyName) {
    print('buildSingleGame: ${widget.gameConfig.gameData}');
    switch (widget.gameName) {
      case 'reflex':
        playTime = 15000;
        maxIterations = 1;
        return new Reflex(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: (Map<String, dynamic> gameData, bool end) =>
                _onEnd(context, gameData: gameData, end: end),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'quiz_pager':
        playTime = 15000;
        maxIterations = 1;
        return new QuizPager(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated);
        break;
      case 'order_it':
        playTime = 15000;
        maxIterations = 1;
        return new OrderIt(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'identify':
        maxIterations = 2;
        return new IdentifyGame(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration);
        break;
      case 'abacus':
        playTime = 15000;
        maxIterations = 1;
        return new Abacus(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'drawing':
        maxIterations = 1;
        return new Drawing(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: (Map<String, dynamic> gameData, bool end) =>
                _onEnd(context, gameData: gameData, end: end),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'dice':
        maxIterations = -1;
        return new Dice(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: (Map<String, dynamic> gameData, bool end) =>
                _onEnd(context, gameData: gameData, end: end),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'bingo':
        playTime = 15000;
        maxIterations = 1;
        return new Bingo(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'clue_game':
        maxIterations = 1;
        return new ClueGame(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameConfig.gameCategoryId);
        break;
      case 'casino':
        return new Casino(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'fill_number':
        return new Fillnumber(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'picture_sentence':
        return new PictureSentence(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'connect_the_dots':
        return new Connectdots(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'guess':
        maxIterations = 2;
        return new GuessIt(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated);
      case 'spin_wheel':
        maxIterations = 1;
        return new SpinWheel(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'circle_word':
        return new Circleword(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
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
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'first_word':
        return new FirstWord(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
      case 'word_fight':
        return new WordFight(
            key: new GlobalObjectKey(keyName),
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: widget.gameConfig.myIteration +
                widget.gameConfig.otherIteration,
            isRotated: widget.isRotated,
            gameConfig: widget.gameConfig);
        break;
    }
    return null;
  }
}
