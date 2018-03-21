import 'package:flutter/material.dart';
import 'single_game.dart';

class HeadToHeadGame extends StatefulWidget {
  final String gameName;
  final int maxIterations;
  final int playTime;

  HeadToHeadGame(this.gameName, {this.maxIterations = 0, this.playTime = 0});

  @override
  HeadToHeadGameState createState() {
    return new HeadToHeadGameState();
  }
}

class HeadToHeadGameState extends State<HeadToHeadGame> {
  int _myScore = 0;
  int _otherScore = 0;

  setMyScore(int score) {
    _myScore = score;
  }

  setOtherScore(int score) {
    _otherScore = score;
  }

  onGameEnd(BuildContext context) {
    showDialog<String>(
        context: context,
        child: new AlertDialog(
          content: new Column(
            children: <Widget>[
              new Expanded(
                  child: new RotatedBox(
                child: new Text('$_otherScore'),
                quarterTurns: 2,
              )),
              new Expanded(child: new Text('$_myScore'))
            ],
          ),
        )).then<Null>((String s) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
            child: new RotatedBox(
                child: new SingleGame(
                  widget.gameName,
                  maxIterations: widget.maxIterations,
                  playTime: widget.playTime,
                  onScore: setOtherScore,
                  onGameEnd: onGameEnd,
                ),
                quarterTurns: 2)),
        new Expanded(
            child: new SingleGame(
          widget.gameName,
          maxIterations: widget.maxIterations,
          playTime: widget.playTime,
          onScore: setMyScore,
          onGameEnd: onGameEnd,
        ))
      ],
    );
  }
}
