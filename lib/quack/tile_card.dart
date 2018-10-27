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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: FileImage(File(tile.user.image)),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildTile(context),
        ))
      ],
    );
  }

  Widget _buildTile(BuildContext context) {
    switch (tile.type) {
      case TileType.card:
        return AspectRatio(
            aspectRatio: CardSummary.cardTypeAspectRatio[tile.card.type],
            child: CardSummary(cardId: tile.card.id));
        break;
      case TileType.drawing:
        return DrawingCard(tile: tile);
        break;
    }
  }
}
