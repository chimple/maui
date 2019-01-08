import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/components/drawing_wrapper.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/state/app_state_container.dart';
import '../actions/update_points.dart';
import 'package:nima/nima_actor.dart';

class DrawingLock extends StatefulWidget {
  final Tile tile;
  DrawingLock({Key key, this.tile}) : super(key: key);

  @override
  State createState() {
    return new DrawingLockState();
  }
}

class DrawingLockState extends State<DrawingLock> {
  int initialPoints;
  bool shouldPushPage = false;

  void _goToDrawing(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => DrawingWrapper(
              activityId: widget.tile.cardId,
              drawingId: widget.tile.id,
            )));
  }

  void onCompleteNima() {
    if (!shouldPushPage)
      Navigator.of(context).pop();
    else
      _goToDrawing(context);
  }

  void onPressed() {
    shouldPushPage = true;
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogContent(
              onPressed: onPressed,
              initialPoints: initialPoints - 1,
              onCompleteNima: onCompleteNima,
              shouldDisplayNima: true);
        },
        barrierDismissible: false);
    Provider.dispatch<RootState>(context, UpdatePoints(points: -5));
  }

  @override
  Widget build(BuildContext context) {
    initialPoints = AppStateContainer.of(context).state.loggedInUser.points;
    return widget.tile.updatedAt == null
        ? InkWell(
            onTap: () => initialPoints < 3
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogContent(
                          onPressed: onPressed,
                          initialPoints: initialPoints,
                          onCompleteNima: onCompleteNima,
                          shouldDisplayNima: true);
                    },
                    barrierDismissible: false)
                : showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogContent(
                          onPressed: onPressed,
                          initialPoints: initialPoints,
                          shouldDisplayNima: false);
                    }),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                constraints: BoxConstraints.expand(),
                alignment: AlignmentDirectional(1.2, -1.2),
//                    color: Color(0x99999999),
                child: Icon(
                  Icons.lock,
                  color: Colors.blue,
                  size: 24.0,
                ),
              ),
            ),
          )
        : Container();
  }
}

class DialogContent extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onCompleteNima;
  bool shouldDisplayNima;
  final int initialPoints;
  DialogContent(
      {Key key,
      this.onPressed,
      this.shouldDisplayNima = false,
      this.initialPoints,
      this.onCompleteNima})
      : super(key: key);
  @override
  State createState() {
    return new DialogContentState();
  }
}

class DialogContentState extends State<DialogContent> {
  String _animation;
  bool paused = false;

  @override
  Widget build(BuildContext context) {
    if (widget.shouldDisplayNima)
      _animation = widget.initialPoints > 2 ? 'happy' : 'sad';
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;

    void _complete() {
      setState(() {
        paused = true;
        _animation = null;
      });
    }

    return new Center(
      child: Material(
        type: MaterialType.transparency,
        child: new Container(
          height: size.height * 0.3,
          width: size.width * 0.7,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(25.0),
          ),
          child: Container(
            child: new Column(
              children: <Widget>[
                Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blue,
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(20.0),
                        topRight: new Radius.circular(20.0)),
                  ),
                  height: 60.0,
                  width: size.width * 0.7,
                  child: Center(
                    child: new Text(
                      '${Loca.of(context).yourPoints} ${widget.initialPoints}',
                      style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                widget.shouldDisplayNima
                    ? Container(
                        height: size.height * 0.3 - 90,
                        width: size.width * 0.4,
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: 0.5,
                            child: new NimaActor("assets/quack",
                                alignment: Alignment.center,
                                paused: paused,
                                fit: BoxFit.scaleDown,
                                animation: _animation,
                                mixSeconds: 0.2,
                                completed: (String animtionName) {
                              widget.onCompleteNima();
                              _complete();
                            }),
                          ),
                        ),
                      )
                    : Container(
                        height: size.height * 0.3 - 75,
                        width: (size.width * 0.7) * 0.5,
                        child: Center(
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Center(
                                  child: new Text(
                                 Loca.of(context).costIs,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )),
                              Container(
                                  // margin: EdgeInsets.only(top: 80.0),
                                  width: ((size.width * 0.7) * 0.5) / 1.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.blue),
                                  child: new FlatButton(
                                    onPressed: widget.onPressed,
                                    child: Center(
                                      child: Text(
                                        Loca.of(context).buy,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
