import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_progress.dart';
import 'package:maui/actions/fetch_card_detail.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/user_repo.dart';
import '../actions/deduct_points.dart';
import 'package:nima/nima_actor.dart';

class CardLock extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;

  const CardLock({Key key, this.card, this.parentCardId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Connect<RootState, double>(
      convert: (state) => state.progressMap[card.id],
      where: (prev, next) => next != prev,
      builder: (progress) {
        return progress == null
            ? InkWell(
                onTap: () => _askToUnlock(context),
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
            : AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  child: Align(
                    alignment: Alignment(0.0, 1.0),
                    child: CollectionProgressIndicator(
                      card: card,
                    ),
                  ),
                ),
              );
      },
      nullable: true,
    );
  }

  void _goToCardDetail(BuildContext context) {
    Provider.dispatch<RootState>(context, FetchCardDetail(card.id));
    Provider.dispatch<RootState>(
        context, AddProgress(card: card, parentCardId: card.id));

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => CardDetail(
                card: card,
                parentCardId: parentCardId,
              )),
    );
  }

  Future<Null> _askToUnlock(BuildContext context) async {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Connect<RootState, int>(
            convert: (state) => state.user.points,
            where: (prev, next) {
              return next != prev;
            },
            builder: (points) {
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
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
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
                                        animation: points > 3 ? 'happy' : 'sad',
                                        mixSeconds: 0.02,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
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
                                          width:
                                              ((size.width * 0.7) * 0.5) / 1.8,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: points > 3
                                                  ? Colors.blue
                                                  : Colors.grey[400]),
                                          child: new FlatButton(
                                            onPressed: points > 3
                                                ? () {
                                                    // new DeductPoints(points: 1);
                                                    Provider.dispatch<
                                                            RootState>(
                                                        context,
                                                        DeductPoints(
                                                            points: 1));

                                                    new Future.delayed(
                                                        const Duration(
                                                            seconds: 4),
                                                        () => _goToCardDetail(
                                                            context));
                                                  }
                                                : null,
                                            child: Center(
                                              child: Text(
                                                "Buy",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    )
        ? _goToCardDetail(context)
        : {};
  }
}
