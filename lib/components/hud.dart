import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/db/entity/user.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/progress_circle.dart';
import 'package:maui/components/progress_bar.dart';

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

  Hud({
    Key key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    height = height * 0.6;
    width = width;
    print('nikhil  12 ${user.name} ');

    print("hello this ia who is playing current user in game;;;;::${onEnd}");
    final fontSize = min(18.0, height / 2);

    var headers = <Widget>[
      new Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // alignment: AlignmentDirectional.center,
        children: <Widget>[
          new Container(
              width: height,
              height: height,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      image: new FileImage(new File(user.image)),
                      fit: BoxFit.fill))),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(children: [
          Text(
            '$score',
            style: new TextStyle(fontSize: 20.0, color: foregroundColor),
          ),
        ]),
      ),
      _builProgressbar(context, amICurrentUser, start),
    ];

    return new Row(
        mainAxisAlignment:
            start ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: start ? headers : headers.reversed.toList(growable: false));
  }

  _builProgressbar(BuildContext context, bool amICurrentUser, bool start) {
    return amICurrentUser
        ? new Stack(
            alignment: AlignmentDirectional.center,
            // crossAxisAlignment:
            //     start ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: new SizedBox(
                    width: width,
                    height: 25.0,
                    child: new LinearProgressIndicator(
                      // strokeWidth: height / 8.0,
                      value: 1.0,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(backgroundColor),
                    )),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: new SizedBox(
                    width: width,
                    height: 25.0,
                    child: gameMode == GameMode.timed
                        ? new ProgressBar(
                            time: playTime,
                            onEnd: () => onEnd(context),
                            // strokeWidth: height / 8.0,
                          )
                        : new ProgressBar(
                            progress: progress,
                            // strokeWidth: height / 8.0,
                          )),
              ),
            ],
          )
        : new Container();
  }
}
