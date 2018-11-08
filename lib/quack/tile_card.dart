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
                    color: Colors.red,
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
        return Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
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
                  tile.user.name,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Card(
                elevation: 8.0,
                margin: EdgeInsets.all(8.0),
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
