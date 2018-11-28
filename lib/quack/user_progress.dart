import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/collection_progress_indicator.dart';

class UserProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return new LayoutBuilder(builder: (context, constraints) {
      return Connect<RootState, List<QuackCard>>(
        convert: (state) => state.cardMap.values
            .where((c) =>
                c.type == CardType.concept &&
                (state.activityMap[c.id]?.progress ?? 0.0) > 0.0)
            .toList(growable: false),
        where: (prev, next) => next != prev,
        builder: (cards) {
          return cards == null
              ? Container()
              : ListView(
                  primary: true,
                  children: cards
                      .map(
                        (c) => Container(
                              decoration: BoxDecoration(
                                  border: BorderDirectional(
                                      bottom: BorderSide(
                                          width: 2.0,
                                          color:
                                              Colors.black.withOpacity(0.2)))),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  new Column(
                                    children: <Widget>[
                                      new Container(
                                        margin: EdgeInsets.only(
                                            top: 4.0, bottom: 4.0, left: 15.0),
                                        width: constraints.maxWidth * 0.21875,
                                        height: constraints.maxHeight * 0.20902,
                                        decoration: new BoxDecoration(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          border: new Border.all(
                                              width: 3.0, color: Colors.grey),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: new CardHeader(card: c),
                                      ),
                                      new Container(
                                        margin: const EdgeInsets.only(
                                            top: 4.0, bottom: 4.0, left: 15.0),
                                        width: constraints.maxWidth * 0.21875,
                                        child: new Text(
                                          c.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                      child: new Padding(
                                    padding: new EdgeInsets.only(
                                        left: 30.0, bottom: 25.0),
                                    child: CollectionProgressIndicator(
                                      card: c,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                      )
                      .toList(growable: false));
        },
      );
    });
  }
}
