import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/state/app_state_container.dart';
import '../actions/update_points.dart';
import 'package:nima/nima_actor.dart';

class CardLock extends StatefulWidget {
  final QuackCard card;
  final String parentCardId;
  CardLock({Key key, this.card, this.parentCardId}) : super(key: key);

  @override
  State createState() {
    return new CardLockState();
  }
}

class CardLockState extends State<CardLock> {
  int initialPoints;
  bool shouldPushPage = false;

  void _goToCardDetail(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CardDetail(
              card: widget.card,
              parentCardId: widget.parentCardId,
            )));
    Provider.dispatch<RootState>(context, FetchCardDetail(widget.card.id));
    Provider.dispatch<RootState>(
        context,
        AddProgress(
            cardId: widget.card.id, parentCardId: widget.card.id, index: 0));
  }

  void onCompleteNima() {
    if (!shouldPushPage)
      Navigator.of(context).pop();
    else
      _goToCardDetail(context);
  }

  void onPressed() {
    shouldPushPage = true;
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogContent(
              onPressed: onPressed,
              initialPoints: initialPoints - 5,
              onCompleteNima: onCompleteNima,
              shouldDisplayNima: true);
        },
        barrierDismissible: false);

    Provider.dispatch<RootState>(context, UpdatePoints(points: -5));
  }

  @override
  Widget build(BuildContext context) {
    initialPoints = AppStateContainer.of(context).state.loggedInUser.points;
    return Connect<RootState, double>(
      convert: (state) => state.activityMap[widget.card.id]?.progress,
      where: (prev, next) => next != prev,
      builder: (progress) {
        return progress == null
            ? InkWell(
                onTap: () => initialPoints < 5
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
                    color: Color(0x88888888),
                  ),
                ),
              )
            : Container();
      },
      nullable: true,
    );
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
      _animation = widget.initialPoints > 5 ? 'happy' : 'sad';
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
          child: new Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 60.0,
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue,
                      borderRadius: new BorderRadius.only(
                          topLeft: new Radius.circular(20.0),
                          topRight: new Radius.circular(20.0)),
                    ),
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
                ),
              ),
              widget.shouldDisplayNima
                  ? Expanded(
                      flex: 4,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: NimaActor("assets/quack",
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
                  : Expanded(
                      flex: 4,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                  child: new Text(
                                Loca.of(context).costIs,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 5),
                                    constraints: BoxConstraints(
                                        maxWidth: 150, maxHeight: 50),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
