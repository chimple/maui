import 'dart:async';
import 'dart:convert';

import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_extra.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_extra_repo.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';

class FetchComments implements AsyncAction<RootState> {
  final String parentId;
  final TileType tileType;

  CommentRepo commentRepo;

  FetchComments({this.parentId, this.tileType});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(commentRepo != null, 'commentRepo not injected');

    final comments =
        await commentRepo.getCommentsByParentId(parentId, tileType);
    print('FecthComments: $parentId');
    print(comments);
    print(state.commentMap);

    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap,
        tiles: state.tiles,
        drawings: state.drawings,
        userMap: state.userMap,
        templates: state.templates,
        commentMap: state.commentMap..[parentId] = comments);
  }
}
