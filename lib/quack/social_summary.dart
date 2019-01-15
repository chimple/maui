import 'package:flutter/material.dart';
import 'package:maui/containers/like_container.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/quack/user_activity.dart';

//TODO: pass userActivity

class SocialSummary extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final int likes;
  final int comments;
  final UserActivity userActivity;

  const SocialSummary(
      {Key key,
      this.parentId,
      this.tileType,
      this.likes,
      this.comments,
      this.userActivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[
      Row(
        children: <Widget>[
          LikeContainer(
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
  }
}
