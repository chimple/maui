import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/like_button.dart';

class SocialSummary extends StatelessWidget {
  final QuackCard card;
  final TileType tileType;

  const SocialSummary({Key key, this.card, this.tileType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            LikeButton(
              parentId: card.id,
              tileType: TileType.card,
              isInteractive: false,
            ),
            Text("${card.likes ?? ''}"),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.comment),
            Text("${card.comments ?? ''}")
          ],
        )
      ],
    );
  }
}
