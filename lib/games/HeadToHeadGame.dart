import 'package:flutter/material.dart';
import 'SingleGame.dart';

class HeadToHeadGame extends StatelessWidget {
  String gameName;
  
  HeadToHeadGame(this.gameName);
  
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
            child: new RotatedBox(child: new SingleGame(gameName), quarterTurns: 2)),
        new Expanded(child: new SingleGame(gameName))
      ],
    );
  }
}

