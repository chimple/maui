import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:maui/db/entity/user.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/progress_circle.dart';

class Hud extends StatelessWidget {
  User user;
  bool amICurrentUser;
  double height;
  double width;
  bool start;
  Color backgroundColor;
  Color foregroundColor;
  GameMode gameMode;
  int playTime;
  Function onEnd;
  double progress;
  int score;
  bool quizeType;

  Hud(
      {Key key,
      this.user,
      this.height,
      this.width,
      this.start = true,
      this.backgroundColor,
      this.foregroundColor,
      this.gameMode,
      this.playTime,
      this.onEnd,
      this.amICurrentUser,
      this.progress,
      this.score,
      this.quizeType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = height * 0.6;
    width = width;

    final fontSize = min(18.0, height / 2);

    var headers = <Widget>[
      new Stack(
     
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Container(
              width: height / 1.4,
              height: height / 1.4,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      image: new FileImage(new File(user.image)),
                      fit: BoxFit.fill))),
          new SizedBox(
              width: height / 1.4,
              height: height / 1.4,
              child: new CircularProgressIndicator(
                strokeWidth: height / 8.5,
                value: 1.0,
                valueColor: new AlwaysStoppedAnimation<Color>(backgroundColor),
              )),
          new SizedBox(
              width: height / 1.4,
              height: height / 1.4,
              child: gameMode == GameMode.timed
                  ? new ProgressCircle(
                      time: playTime,
                      onEnd: () => onEnd(context),
                      strokeWidth: height / 8.5,
                    )
                  : new ProgressCircle(
                      progress: progress,
                      strokeWidth: height / 8.5,
                    )),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(children: [
          Text(
            '$score',
            style: new TextStyle(fontSize: fontSize, color: foregroundColor),
          ),
        ]),
      ),
    ];

    return new Row(
        mainAxisAlignment:
            start ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: start ? headers : headers.reversed.toList(growable: false));
  }
}
