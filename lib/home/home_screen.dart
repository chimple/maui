import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/tile_card.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/app.dart';
import 'package:maui/screens/game_list_view.dart';
import 'package:maui/screens/select_opponent_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final crossAxisCount = (media.size.width / 400.0).floor();
    final aspectRatio = media.size.width / (140.0 * crossAxisCount);
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Connect<RootState, Map<String, QuackCard>>(
              convert: (state) => state.frontMap,
              where: (prev, next) => true,
              builder: (frontMap) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                        context: context,
                        name: 'Discuss',
                        routeName: '/topics',
                        child: CardSummary(
                          card: frontMap['open'],
                          parentCardId: 'open',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                          context: context,
                          name: 'Story',
                          routeName: '/stories',
                          child: CardSummary(
                            card: frontMap['story'],
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                        context: context,
                        name: 'Topic',
                        routeName: '/topics',
                        child: CardSummary(
                          card: frontMap['topic'],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildBox(
                        context: context,
                        name: 'Game',
                        routeName: '/games',
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) {
                                  return SelectOpponentScreen(
                                    gameName: gameNames[0].item1,
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
                                        "assets/background_image/${gameNames[0].item1}_small.png"),
                                    Hero(
                                      tag:
                                          "assets/hoodie/${gameNames[0].item1}.png",
                                      child: Image.asset(
                                        "assets/hoodie/${gameNames[0].item1}.png",
                                        scale: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(gameNames[0].item2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
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
      {BuildContext context, String name, String routeName, Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed(routeName),
                  child: Text(
                    'See All',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
