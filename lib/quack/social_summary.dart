import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/like_button.dart';

class SocialSummary extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final int likes;
  final int comments;

  const SocialSummary(
      {Key key, this.parentId, this.tileType, this.likes, this.comments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          children: <Widget>[
            LikeButton(
              parentId: parentId,
              tileType: TileType.card,
              isInteractive: false,
            ),
            Text("${likes ?? ''}"),
          ],
        ),
        Row(
          children: <Widget>[Icon(Icons.comment), Text("${comments ?? ''}")],
        )
      ],
    );
  }
}
