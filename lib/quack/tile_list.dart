import 'package:flutter/material.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/tile_card.dart';

class TileList extends StatelessWidget {
  final List<Tile> tiles;

  const TileList({Key key, this.tiles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    print(media);
    final crossAxisCount = (media.size.width / 300.0).floor();
    final aspectRatio = media.size.width / (140.0 * crossAxisCount);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount, childAspectRatio: aspectRatio),
      delegate: SliverChildListDelegate(tiles
          .map((t) => Padding(
              padding: EdgeInsets.all(16.0),
              child: Material(
                  elevation: 8.0,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: TileCard(
                    tile: t,
                  ))))
          .toList(growable: false)),
    );
  }
}
