import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'single_game.dart';
import 'package:maui/screens/score_screen.dart';
import 'package:maui/state/app_state_container.dart';

class TurnByTurnGame extends StatefulWidget {
  final String gameName;
  final GameMode gameMode;
  final GameConfig gameConfig;

  TurnByTurnGame(this.gameName,
      {this.gameMode = GameMode.iterations, @required this.gameConfig});

  @override
  TurnByTurnGameState createState() {
    return new TurnByTurnGameState();
  }
}

class TurnByTurnGameState extends State<TurnByTurnGame> {
  onGameEnd(BuildContext context) {
    // Navigator.of(context).pop();
    Navigator.push(context,
        new MaterialPageRoute<void>(builder: (BuildContext context) {
      return new ScoreScreen(
        gameName: widget.gameName,
        gameDisplay: GameDisplay.myHeadToHead,
        myUser: AppStateContainer.of(context).state.loggedInUser,
        myScore: _myScore,
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
        gameConfig: new GameConfig(
            questionUnitMode: widget.gameConfig.questionUnitMode,
            answerUnitMode: widget.gameConfig.answerUnitMode,
            gameCategoryId: widget.gameConfig.gameCategoryId,
            level: widget.gameConfig.level,
            gameDisplay: GameDisplay.myHeadToHead),
        onScore: setMyScore,
        onGameEnd: onGameEnd,
      )),
      new Expanded(
          child: new SingleGame(widget.gameName,
              key: new GlobalObjectKey('SingleGame.other'),
              gameMode: widget.gameMode,
              gameConfig: new GameConfig(
                  questionUnitMode: widget.gameConfig.questionUnitMode,
                  answerUnitMode: widget.gameConfig.answerUnitMode,
                  gameCategoryId: widget.gameConfig.gameCategoryId,
                  level: widget.gameConfig.level,
                  gameDisplay: GameDisplay.otherHeadToHead),
              onScore: setOtherScore,
              onGameEnd: onGameEnd)),
    ]);
  }
}
