import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';

class LikeButton extends StatefulWidget {
  final String parentId;
  final TileType tileType;
  final String userId;

  const LikeButton({Key key, this.parentId, this.tileType, this.userId})
      : super(key: key);

  @override
  LikeButtonState createState() {
    return new LikeButtonState();
  }
}

class LikeButtonState extends State<LikeButton> {
  bool _isLoading = true;
  Like _like;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    _like = await LikeRepo().getLikeByParentIdAndUserId(
        widget.parentId, widget.userId, widget.tileType);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _like == null) {
      return InkWell(
        child: Icon(
          Icons.favorite_border,
          color: Colors.red,
        ),
        onTap: _isLoading ? null : () => _onPressed(context),
      );
    } else {
      return Icon(
        Icons.favorite,
        color: Colors.red,
      );
    }
  }

  Future<Null> _onPressed(BuildContext context) async {
    setState(() => _like = Like(
        id: Uuid().v4(),
        parentId: widget.parentId,
        userId: widget.userId,
        timeStamp: DateTime.now(),
        type: 0,
        user: AppStateContainer.of(context).state.loggedInUser));
    LikeRepo().insert(_like, widget.tileType);
  }
}
