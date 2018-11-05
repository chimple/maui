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
    await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return Connect<RootState, int>(
                  convert: (state) => state.user.points,
                  where: (prev, next) => next != prev,
                  builder: (points) {
                    return SimpleDialog(
                      titlePadding: EdgeInsets.all(0.0),
                      title: Container(
                          height: 60.0,
                          //             decoration: new BoxDecoration(
                          // shape: BoxShape.rectangle,
                          // // color: const Color(0xFFFFFF),
                          // borderRadius:
                          //     new BorderRadius.all(new Radius.circular(32.0)),
                          // ),
                          color: Colors.blue,
                          child: Center(child: Text('your points-$points'))),
                      children: <Widget>[
                        // SimpleDialogOption(
                        //   onPressed: () {
                        //     Navigator.pop(context, true);
                        //   },
                        //   child: const Text('Yes'),
                        // ),
                        // SimpleDialogOption(
                        //   onPressed: () {
                        //     Navigator.pop(context, false);
                        //   },
                        //   child: const Text('No'),
                        // ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 200.0,
                                height: 200.0,
                                child: Card(
                                  child: new Image.asset(
                                    'assets/Fruits.png',
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Container(
                              height: 200.0,
                              width: 200.0,
                              child: Card(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      new Text(
                                        "cost- 1",
                                      ),
                                      new RaisedButton(
                                        onPressed: points >= 5
                                            ? () {
                                                // new DeductPoints(points: 1);
                                                Provider.dispatch<RootState>(
                                                    context,
                                                    DeductPoints(points: 1));
                                                Navigator.pop(context, true);
                                              }
                                            : null,
                                        child: Text("buy"),
                                      )
                                    ]),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  });
            })
        ? _goToCardDetail(context)
        : {};
  }
}
