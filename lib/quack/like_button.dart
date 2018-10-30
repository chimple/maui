import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/add_like.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class LikeButton extends StatelessWidget {
  final String parentId;
  final TileType tileType;

  const LikeButton({Key key, this.parentId, this.tileType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Connect<RootState, bool>(
      convert: (state) => state.likeMap[parentId] != null,
      where: (prev, next) => next != prev,
      builder: (like) {
        return like ?? false
            ? Icon(
                Icons.favorite,
                size: 40.0,
                color: Colors.red,
              )
            : InkWell(
                child: Icon(
                  Icons.favorite_border,
                  size: 40.0,
                  color: Colors.black,
                ),
                onTap: () => like == null
                    ? null
                    : Provider.dispatch<RootState>(context,
                        AddLike(parentId: parentId, tileType: TileType.card)),
              );
      },
      nullable: true,
    );
  }
}
