import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/collection_progress_indicator.dart';
import 'package:maui/quack/like_button.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
    return Connect<RootState, UserActivity>(
        convert: (state) => state.activityMap[parentId],
        where: (prev, next) => next != prev,
        nullable: true,
        builder: (userActivity) {
          final widgets = <Widget>[
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
              children: <Widget>[
                Icon(Icons.chat_bubble_outline),
                Text("${comments ?? ''}")
              ],
            )
          ];

          if (tileType == TileType.card) {
            widgets.add(userActivity?.progress == null
                ? Icon(Icons.lock_outline, color: Colors.red)
                : (userActivity.progress ?? 0.0) < 1.0
                    ? Icon(
                        Icons.lock_open,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.done,
                        color: Colors.green,
                      ));
          }

          return Container(
            color: Color(0x88888888),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widgets,
            ),
          );
        });
  }
}
