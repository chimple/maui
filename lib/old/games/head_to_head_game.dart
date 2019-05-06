import 'package:meta/meta.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'single_game.dart';
import 'package:maui/screens/score_screen.dart';
import 'package:maui/state/app_state_container.dart';

class HeadToHeadGame extends StatefulWidget {
  final String gameName;
  final GameMode gameMode;
  final GameConfig gameConfig;

  HeadToHeadGame(this.gameName,
      {this.gameMode = GameMode.iterations, @required this.gameConfig});

  @override
  HeadToHeadGameState createState() {
    return new HeadToHeadGameState();
  }
}

class HeadToHeadGameState extends State<HeadToHeadGame> {
  int _myScore = 0;
  int _otherScore = 0;
  GameConfig myGameConfig;
  GameConfig otherGameConfig;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    myGameConfig = GameConfig(
        questionUnitMode: widget.gameConfig.questionUnitMode,
        answerUnitMode: widget.gameConfig.answerUnitMode,
        gameCategoryId: widget.gameConfig.gameCategoryId,
        level: widget.gameConfig.level,
        amICurrentPlayer: true,
        myUser: widget.gameConfig.myUser,
        myScore: 0,
        orientation: Orientation.landscape,
        gameDisplay: GameDisplay.myHeadToHead);
    otherGameConfig = GameConfig(
        questionUnitMode: widget.gameConfig.questionUnitMode,
        answerUnitMode: widget.gameConfig.answerUnitMode,
        gameCategoryId: widget.gameConfig.gameCategoryId,
        amICurrentPlayer: true,
        level: widget.gameConfig.level,
        myUser: widget.gameConfig.otherUser,
        myScore: 0,
        orientation: Orientation.landscape,
        gameDisplay: GameDisplay.otherHeadToHead);
  }

  setMyScore(int score) {
    print("HeadToHeadGame:setMyScore ${myGameConfig.myScore} $score");
    setState(() {
      myGameConfig.myScore = score;
    });
  }

  setOtherScore(int score) {
    print("HeadToHeadGame:setOtherScore ${otherGameConfig.myScore} $score");
    setState(() {
      otherGameConfig.myScore = score;
    });
  }

  onGameEnd(BuildContext context) {
    // Navigator.of(context).pop();
    print("HeadToHead:onGameEnd");
    Navigator.push(context,
        new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new ScoreScreen(
        gameName: widget.gameName,
        gameDisplay: GameDisplay.myHeadToHead,
        myUser: AppStateContainer.of(context).state.loggedInUser,
        myScore: myGameConfig.myScore,
        otherUser: otherGameConfig.myUser,
        otherScore: otherGameConfig.myScore,
        isGameOver: true,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return Row(children: <Widget>[
      new Expanded(
          child: new SingleGame(
        widget.gameName,
        key: new GlobalObjectKey('SingleGame.my'),
        gameMode: widget.gameMode,
        gameConfig: myGameConfig,
        onScore: setMyScore,
        onGameEnd: onGameEnd,
      )),
      new Expanded(
          child: new SingleGame(widget.gameName,
              key: new GlobalObjectKey('SingleGame.other'),
              gameMode: widget.gameMode,
              gameConfig: otherGameConfig,
              onScore: setOtherScore,
              onGameEnd: onGameEnd)),
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }
}
