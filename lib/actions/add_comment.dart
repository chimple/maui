import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/comment.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/comment_repo.dart';
import 'package:maui/repos/log_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;

class AddComment implements AsyncAction<RootState> {
  final Comment comment;
  final TileType tileType;
  final bool addTile;
  CommentRepo commentRepo;
  TileRepo tileRepo;

  AddComment({this.comment, this.tileType, this.addTile = false});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(commentRepo != null, 'commentRepo not injected');
    assert(tileRepo != null, 'tileRepo not injected');
    commentRepo.insert(comment, tileType);
    switch (tileType) {
      case TileType.card:
        state.cardMap[comment.parentId].comments =
            (state.cardMap[comment.parentId].comments ?? 0) + 1;
        break;
      case TileType.drawing:
        final commentTile = state.tiles
            .firstWhere((t) => t.id == comment.parentId, orElse: () => null);
        if (commentTile != null)
          commentTile.comments = (commentTile.comments ?? 0) + 1;
        break;
      case TileType.message:
        final commentTile = state.tiles
            .firstWhere((t) => t.id == comment.parentId, orElse: () => null);
        if (commentTile != null)
          commentTile.comments = (commentTile.comments ?? 0) + 1;
        break;
    }

    var tile;

    if (addTile) {
      var tiles = await tileRepo.getTilesByCardId(comment.parentId);
      if (tiles.length == 0) {
        tile = Tile(
            id: Uuid().v4(),
            cardId: comment.parentId,
            type: TileType.card,
            userId: comment.userId,
            updatedAt: DateTime.now(),
            card: state.cardMap[comment.parentId],
            user: state.user); //TODO put real user
        await tileRepo.insert(tile);
      }
    }
    if (comment.userId == state.user.id)
      try {
        await p2p.addMessage(
            state.user.id,
            '0',
            'comment',
            '${comment.id}${floresSeparator}${tileType.index}${floresSeparator}${comment.parentId}${floresSeparator}${comment.comment}',
            true,
            '');
      } on PlatformException {
        print('Flores: Failed addMessage');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
    final commentMap = state.commentMap;
    if (!addTile) {
      if (commentMap[comment.parentId] == null) {
        commentMap[comment.parentId] = [];
      }
      commentMap[comment.parentId].insert(0, comment);
    }
    writeLog('comment,${comment.parentId},${comment.comment}');
    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap,
        commentMap: commentMap,
        tiles: tile == null ? state.tiles : (state.tiles..insert(0, tile)),
        drawings: state.drawings,
        userMap: state.userMap,
        templates: state.templates);
  }
}
