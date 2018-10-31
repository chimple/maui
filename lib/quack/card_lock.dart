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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: progress == null
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
              : Center(
                  child: CollectionProgressIndicator(card: card)),
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
        // return object of type Dialog
        return Connect<RootState, int>(
            convert: (state) => state.user.points,
            where: (prev, next) => next != prev,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                height: size.height * 0.3 - 90,
                                width: (size.width * 0.7) * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: new Image.asset(
                                  'assets/Fruits.png',
                                  fit: BoxFit.fill,
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
                                        "Cost is - 2",
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
                                              color: points >= 2
                                                  ? Colors.blue
                                                  : Colors.grey[400]),
                                          child: new FlatButton(
                                            onPressed: points >= 2
                                                ? () {
                                                    // new DeductPoints(points: 1);
                                                    Provider.dispatch<
                                                            RootState>(
                                                        context,
                                                        DeductPoints(
                                                            points: 1));
                                                    Navigator.pop(
                                                        context, true);
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
              // return new CustomAlertDialog(
              //   titlePadding: EdgeInsets.all(0.0),
              //   title: Container(
              //       height: 60.0,
              //       decoration: new BoxDecoration(
              //         shape: BoxShape.rectangle,
              //         color: Colors.amber,
              //         borderRadius: new BorderRadius.only(
              //             topLeft: new Radius.circular(20.0),
              //             topRight: new Radius.circular(20.0)),
              //       ),
              //       // color: Colors.amber,
              //       child: Center(child: new Text(
              //                             'Your Points-$points',
              //                             style: new TextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: size.height / 4 * 0.1,
              //                                 fontWeight: FontWeight.bold),
              //                           )

              //    )),
              //   content: new Container(
              //     // width: .0,
              //     // height: 230.0,
              //     decoration: new BoxDecoration(
              //       shape: BoxShape.rectangle,
              //       color: const Color(0xFFFFFF),
              //       borderRadius:
              //           new BorderRadius.all(new Radius.circular(32.0)),
              //     ),
              //     child: new Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       children: <Widget>[
              //         new Container(
              //           width: size.width / 4,
              //           height: size.height / 4,
              //           decoration: new BoxDecoration(
              //             color: Colors.white,
              //           ),
              //           child: Card(
              //             child: Center(
              //               child: new Image.asset(
              //                 'assets/Fruits.png',
              //                 fit: BoxFit.cover,
              //               ),
              //             ),
              //           ),
              //         ),
              //         new Container(
              //           width: size.width / 4,
              //           height: size.height / 4,
              //           child: Card(
              //             child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                 children: [
              //                  new Text(
              //                             "Cost -1",
              //                             style: new TextStyle(
              //                                 color: Colors.blue,
              //                                 fontSize: size.height / 4 * 0.1,
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                   new OutlineButton(
              //                       padding: EdgeInsets.all(0.0),
              //                       onPressed: points >= 5
              //                           ? () {
              //                               Provider.dispatch<RootState>(
              //                                   context,
              //                                   DeductPoints(points: 1));
              //                               Navigator.pop(context, true);
              //                             }
              //                           : null,
              //                       child: Container(

              //                           height: size.height / 4 * 0.2,
              //                           width: size.width / 4 * .6,
              //                           decoration: new BoxDecoration(
              //                             shape: BoxShape.rectangle,
              //                             color: points >= 5
              //                                 ? Colors.blue
              //                                 : Colors.grey,
              //                             borderRadius: new BorderRadius.all(
              //                                 new Radius.circular(32.0)),
              //                           ),
              //                           child: Center(
              //                               child: new Text(
              //                             "Buy",
              //                             style: new TextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: size.height / 4 * 0.1,
              //                                 fontWeight: FontWeight.bold),
              //                           ))),
              //                       shape: new RoundedRectangleBorder(
              //                           borderRadius:
              //                               new BorderRadius.circular(30.0)))
              //                 ]),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            });
      },
    )
        ? _goToCardDetail(context)
        : {};

    // await showDialog<bool>(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return Connect<RootState, int>(
    //               convert: (state) => state.user.points,
    //               where: (prev, next) => next != prev,
    //               builder: (points) {
    //                 return SimpleDialog(
    //                   titlePadding: EdgeInsets.all(0.0),
    //                   title: Container(
    //                       height: 60.0,
    //                       //             decoration: new BoxDecoration(
    //                       // shape: BoxShape.rectangle,
    //                       // // color: const Color(0xFFFFFF),
    //                       // borderRadius:
    //                       //     new BorderRadius.all(new Radius.circular(32.0)),
    //                       // ),
    //                       color: Colors.blue,
    //                       child: Center(child: Text('your points-$points'))),
    //                   children: <Widget>[
    //                     // SimpleDialogOption(
    //                     //   onPressed: () {
    //                     //     Navigator.pop(context, true);
    //                     //   },
    //                     //   child: const Text('Yes'),
    //                     // ),
    //                     // SimpleDialogOption(
    //                     //   onPressed: () {
    //                     //     Navigator.pop(context, false);
    //                     //   },
    //                     //   child: const Text('No'),
    //                     // ),
    //                     new Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         Container(
    //                             width: 200.0,
    //                             height: 200.0,
    //                             child: Card(
    //                               child: new Image.asset(
    //                                 'assets/Fruits.png',
    //                                 fit: BoxFit.cover,
    //                               ),
    //                             )),
    //                         Container(
    //                           height: 200.0,
    //                           width: 200.0,
    //                           child: Card(
    //                             child: Column(
    //                                 mainAxisAlignment: MainAxisAlignment.center,
    //                                 children: [
    //                                   new Text(
    //                                     "cost- 1",
    //                                   ),
    //                                   new RaisedButton(
    //                                     onPressed: points >= 5
    //                                         ? () {
    //                                             // new DeductPoints(points: 1);
    //                                             Provider.dispatch<RootState>(
    //                                                 context,
    //                                                 DeductPoints(points: 1));
    //                                             Navigator.pop(context, true);
    //                                           }
    //                                         : null,
    //                                     child: Text("buy"),
    //                                   )
    //                                 ]),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   ],
    //                 );
    //               });
    //         })
    // ? _goToCardDetail(context)
    // : {};
  }
}
