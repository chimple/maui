import 'dart:async';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:uuid/uuid.dart';

class AddComment implements AsyncAction<RootState> {
  final String parentId;
  final String text;
  final TileType tileType;

  CommentRepo commentRepo;

  AddComment({this.parentId, this.text, this.tileType});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(commentRepo != null, 'commentRepo not injected');

    final comment = Comment(
        id: Uuid().v4(),
        parentId: parentId,
        userId: state.user.id,
        timeStamp: DateTime.now(),
        comment: text,
        user: state.user);
    commentRepo.insert(comment, tileType);
    state.cardMap[parentId].comments =
        (state.cardMap[parentId].comments ?? 0) + 1;
    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        likeMap: state.likeMap,
        comments: state.comments..add(comment),
        progressMap: state.progressMap);
  }
}
