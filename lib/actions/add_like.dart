import 'dart:async';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:uuid/uuid.dart';

class AddLike implements AsyncAction<RootState> {
  final String parentId;
  final TileType tileType;

  LikeRepo likeRepo;

  AddLike({this.parentId, this.tileType});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(likeRepo != null, 'likeRepo not injected');

    final like = Like(
        id: Uuid().v4(),
        parentId: parentId,
        userId: state.user.id,
        timeStamp: DateTime.now(),
        type: 0,
        user: state.user);
    likeRepo.insert(like, tileType);
    state.cardMap[parentId].likes = (state.cardMap[parentId].likes ?? 0) + 1;
    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        likeMap: state.likeMap..[parentId] = like,
        comments: state.comments,
        progressMap: state.progressMap);
  }
}
