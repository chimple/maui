import 'package:flutter/material.dart';
import 'single_game.dart';

class HeadToHeadGame extends StatelessWidget {
  final String gameName;
  final int maxIterations;
  final int playTime;

  HeadToHeadGame(this.gameName, {this.maxIterations = 0, this.playTime = 0});
  
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
            child: new RotatedBox(child: new SingleGame(gameName, maxIterations: maxIterations, playTime: playTime), quarterTurns: 2)),
        new Expanded(child: new SingleGame(gameName, maxIterations: maxIterations, playTime: playTime))
      ],
    );
  }
}

