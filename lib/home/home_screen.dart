import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/tile_card.dart';
import 'package:maui/loca.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/app.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/screens/select_opponent_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
//    final crossAxisCount = (media.size.width / 400.0).floor();
    final crossAxisCount = 2;
    final aspectRatio = media.size.width / (140.0 * crossAxisCount);
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Connect<RootState, Map<String, QuackCard>>(
              convert: (state) => state.frontMap,
              where: (prev, next) => true,
              builder: (frontMap) {
                final gameNum = Random().nextInt(gameNames.length);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                        context: context,
                        name: Loca.of(context).post,
                        color: Color(0xFFE37825),
                        child: CardSummary(
                          card: frontMap['open'],
                          showSocialSummary: false,
                          parentCardId: 'open',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                          context: context,
                          name: Loca.of(context).story,
                          routeName: '/stories',
                          color: Color(0xFFEE4069),
                          child: CardSummary(
                            showSocialSummary: false,
                            card: frontMap['story'],
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                        context: context,
                        name: Loca.of(context).topic,
                        routeName: '/topics',
                        color: Color(0xFFFED060),
                        child: CardSummary(
                          showSocialSummary: false,
                          card: frontMap['topic'],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                        context: context,
                        name: Loca.of(context).game,
                        routeName: '/games',
                        color: Color(0xFF7FC4EC),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                  return SelectOpponentScreen(
                                    gameName: gameNames[gameNum].item1,
                                  );
                                }));
                              },
                              child: Material(
                                elevation: 8.0,
                                borderRadius: const BorderRadius.all(
                                    const Radius.circular(16.0)),
                                clipBehavior: Clip.antiAlias,
                                color: SingleGame.gameColors[gameNames[0].item1]
                                    [0],
                                child: Stack(
                                  children: <Widget>[
                                    Image.asset(
                                        "assets/background_image/${gameNames[gameNum].item1}_small.png"),
                                    Hero(
                                      tag:
                                          "assets/hoodie/${gameNames[gameNum].item1}.png",
                                      child: Image.asset(
                                        "assets/hoodie/${gameNames[gameNum].item1}.png",
                                        scale: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(Loca.of(context)
                                  .intl(gameNames[gameNum].item1)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
        SliverToBoxAdapter(
            child: Divider(
          height: 32.0,
        )),
        Connect<RootState, List<Tile>>(
          convert: (state) => state.tiles,
          where: (prev, next) => true,
          nullable: true,
          builder: (tiles) {
            return tiles == null
                ? SliverToBoxAdapter(
                    child: Center(
                        child: new SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: new CircularProgressIndicator(),
                    )),
                  )
                : SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: aspectRatio),
                    delegate: SliverChildListDelegate(tiles
                        .map((t) => Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Material(
                                elevation: 8.0,
                                clipBehavior: Clip.antiAlias,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16.0)),
                                child: TileCard(
                                  tile: t,
                                ))))
                        .toList(growable: false)),
                  );
          },
        )
      ],
    );
  }

  Widget _buildBox(
      {BuildContext context,
      String name,
      String routeName,
      Widget child,
      Color color}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: InkWell(
              onTap: routeName == null
                  ? null
                  : () => Navigator.of(context).pushNamed(routeName),
              child: Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                  color: color,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        routeName == null ? '' : Loca.of(context).seeAll,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
