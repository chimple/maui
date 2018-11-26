import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_like.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class LikeButton extends StatelessWidget {
  final String parentId;
  final TileType tileType;
  final bool isInteractive;

  const LikeButton(
      {Key key, this.parentId, this.tileType, this.isInteractive = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Connect<RootState, bool>(
      convert: (state) => state.activityMap[parentId]?.like,
      where: (prev, next) => next != prev,
      builder: (like) {
        if (like ?? false)
          return Icon(
            Icons.favorite_border,
            color: Colors.red,
          );
        else if (!isInteractive) {
          return Icon(
            Icons.favorite_border,
            color: Colors.black,
          );
        } else {
          return InkWell(
            child: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            onTap: () => (!isInteractive)
                ? null
                : Provider.dispatch<RootState>(
                    context, AddLike(parentId: parentId, tileType: tileType)),
          );
        }
      },
      nullable: true,
    );
  }
}
