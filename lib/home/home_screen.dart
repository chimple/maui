import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/tile_card.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/app.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    print(media);
    final crossAxisCount = (media.size.width / 300.0).floor();
    final aspectRatio = media.size.width / (140.0 * crossAxisCount);
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Connect<RootState, List<QuackCard>>(
                convert: (state) => state.collectionMap['Occupations']
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
        Connect<RootState, List<Tile>>(
          convert: (state) => state.tiles,
          where: (prev, next) => next != prev,
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
                            padding: EdgeInsets.all(8.0),
                            child: Material(
                                elevation: 8.0,
                                clipBehavior: Clip.antiAlias,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
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
              FlatButton(
//                onPressed: () => Navigator.of(context).pushNamed(routeName),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
