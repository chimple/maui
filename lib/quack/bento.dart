import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/home/home_screen.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/friend_strip.dart';

class Bento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 90.0, child: FriendStrip()),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: HomeScreen()),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Connect<RootState, List<QuackCard>>(
                            convert: (state) => state.collectionMap['story']
                                .map((cardId) => state.cardMap[cardId])
                                .toList(growable: false),
                            where: (prev, next) => next != prev,
                            builder: (cards) {
                              return Expanded(
                                flex: 1,
                                child: _buildBox(
                                    context: context,
                                    name: 'Story',
                                    routeName: '/stories',
                                    child: CardSummary(
                                      card: cards[0],
                                    )),
                              );
                            }),
                        Connect<RootState, List<QuackCard>>(
                          convert: (state) => state.collectionMap['Animals']
                              .map((cardId) => state.cardMap[cardId])
                              .toList(growable: false),
                          where: (prev, next) => next != prev,
                          builder: (cards) {
                            return Expanded(
                              flex: 1,
                              child: _buildBox(
                                context: context,
                                name: 'Topic',
                                routeName: '/collections',
                                child: CardSummary(
                                  card: cards[0],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBox(
      {BuildContext context, String name, String routeName, Widget child}) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(name)),
            FlatButton(
                onPressed: () => Navigator.of(context).pushNamed(routeName),
                child: Text('See All')),
          ],
        ),
        child,
      ],
    );
  }
}
