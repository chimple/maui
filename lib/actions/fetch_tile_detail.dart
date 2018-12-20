import 'dart:async';

import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/comment_repo.dart';

class FetchTileDetail implements AsyncAction<RootState> {
  final Tile tile;
  CommentRepo commentRepo;

  FetchTileDetail(this.tile);

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(commentRepo != null, 'commentRepo not injected');

    final comments =
        await commentRepo.getCommentsByParentId(tile.id, tile.type);

    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap,
        tiles: state.tiles,
        userMap: state.userMap,
        drawings: state.drawings,
        templates: state.templates,
        commentMap: state.commentMap..[tile.id] = comments);
  }
}
