import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/games/single_game.dart';

class Hud extends StatelessWidget {
  User user;
  bool amICurrentUser;
  double height;

  bool start;
  Color backgroundColor;
  Color foregroundColor;
  GameMode gameMode;
  int playTime;
  Function onEnd;
  double progress;
  int score;

  Hud({
    Key key,
    this.user,
    this.height,
    this.start = true,
    this.backgroundColor,
    this.foregroundColor,
    this.gameMode,
    this.playTime,
    this.onEnd,
    this.amICurrentUser,
    this.progress,
    this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = height * 0.6;
    // final fontSize = min(18.0, height / 2);
    var headers = <Widget>[
      new Container(
          width: height,
          height: height,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  image: new FileImage(new File(user.image)),
                  fit: BoxFit.fill))),
    ];

    return new Row(
        mainAxisAlignment:
            start ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: start ? headers : headers.reversed.toList(growable: false));
  }
}
