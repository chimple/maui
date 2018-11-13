import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/quack/drawing_card.dart';

class TileCard extends StatelessWidget {
  final Tile tile;

  const TileCard({Key key, this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: FileImage(File(tile.user.image)),
          ),
        ),
        Expanded(
          child: _buildTile(context),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context) {
    switch (tile.type) {
      case TileType.card:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tile.content,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  border: new Border.all(
                    width: 1.0,
                    color: Color(0xFFEF823F),
                  ),
                ),
                constraints: BoxConstraints.tightFor(height: 120.0),
                child: CardSummary(
                  card: tile.card,
                  orientation: Orientation.landscape,
                ),
              )
            ],
          ),
        );
        break;
      case TileType.drawing:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${tile.user.name} made a drawing',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Container(
              constraints: BoxConstraints.tightFor(height: 120.0),
              child: DrawingCard(tile: tile),
            )
          ],
        );
        break;
      case TileType.message:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${tile.user.name} wrote',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(8.0),
                  border: new Border.all(
                    width: 1.0,
                    color: Color(0xFFEF823F),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    tile.content,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
              )
            ],
          ),
        );
    }
  }
}
