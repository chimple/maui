import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/state/app_state_container.dart';
import '../actions/deduct_points.dart';
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
  void _goToCardDetail(BuildContext context) {
    Provider.dispatch<RootState>(context, FetchCardDetail(widget.card.id));
    Provider.dispatch<RootState>(
        context, AddProgress(card: widget.card, parentCardId: widget.card.id));

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => CardDetail(
              card: widget.card,
              parentCardId: widget.parentCardId,
            )));
  }

  void onPressed() {
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogContent(
              onPressed: onPressed,
              initialPoints: initialPoints + 1,
              shouldDisplayNima: true);
        },
        barrierDismissible: false);
    new Future.delayed(const Duration(seconds: 4), () {
      _goToCardDetail(context);
    });

    Provider.dispatch<RootState>(context, DeductPoints(points: 1));
  }

  @override
  Widget build(BuildContext context) {
    initialPoints = AppStateContainer.of(context).state.loggedInUser.points;
    return Connect<RootState, double>(
      convert: (state) => state.progressMap[widget.card.id],
      where: (prev, next) => next != prev,
      builder: (progress) {
        return progress == null
            ? InkWell(
                onTap: () => initialPoints < 3
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogContent(
                              onPressed: onPressed,
                              initialPoints: initialPoints,
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
                    color: Color(0x99999999),
                    child: Icon(
                      Icons.lock,
                      color: Colors.white24,
                    ),
                  ),
                ),
              )
            : AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Align(
                    alignment: Alignment(0.0, 1.0),
                    child: CollectionProgressIndicator(
                      card: widget.card,
                    ),
                  ),
                ),
              );
      },
      nullable: true,
    );
  }
}

class DialogContent extends StatelessWidget {
  final VoidCallback onPressed;
  final bool shouldDisplayNima;
  final int initialPoints;
  DialogContent(
      {Key key, this.onPressed, this.shouldDisplayNima, this.initialPoints})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    return Connect<RootState, int>(
        convert: (state) => state.user.points,
        where: (prev, next) {
          return next != prev;
        },
        builder: (points) {
          if (initialPoints < 3) {
            new Future.delayed(const Duration(seconds: 4), () {
              Navigator.of(context).pop();
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
                            'Your Points-$points',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      shouldDisplayNima
                          ? Container(
                              height: size.height * 0.3 - 90,
                              width: (size.width * 0.7) * 0.5,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: 0.5,
                                  child: Container(
                                    height: size.height * 0.25 - 90,
                                    width: (size.width * 0.7) * 0.5,
                                    child: new NimaActor(
                                      "assets/quack",
                                      alignment: Alignment.center,
                                      fit: BoxFit.scaleDown,
                                      animation:
                                          initialPoints > 3 ? 'happy' : 'sad',
                                      mixSeconds: 0.02,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: size.height * 0.3 - 75,
                              width: (size.width * 0.7) * 0.5,
                              child: Center(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Center(
                                        child: new Text(
                                      "Cost is - 3",
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
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.blue),
                                        child: new FlatButton(
                                          onPressed: onPressed,
                                          child: Center(
                                            child: Text(
                                              "Buy",
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
        });
  }
}
