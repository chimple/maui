import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;

class AddLike implements AsyncAction<RootState> {
  final String parentId;
  final TileType tileType;
  final String userId;

  LikeRepo likeRepo;
  TileRepo tileRepo;
  UserRepo userRepo;

  AddLike({this.parentId, this.tileType, this.userId});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(likeRepo != null, 'likeRepo not injected');
    assert(tileRepo != null, 'tileRepo not injected');
    assert(userRepo != null, 'userRepo not injected');

    final user = userId == null ? state.user : await userRepo.getUser(userId);
    final like = Like(
        id: Uuid().v4(),
        parentId: parentId,
        userId: userId ?? state.user.id,
        timeStamp: DateTime.now(),
        type: 0,
        user: user);
    likeRepo.insert(like, tileType);
    state.cardMap[parentId].likes = (state.cardMap[parentId].likes ?? 0) + 1;

    tileRepo.insert(Tile(
        id: Uuid().v4(),
        cardId: parentId,
        content: '${user.name} liked this topic',
        type: TileType.card,
        updatedAt: DateTime.now(),
        userId: userId ?? state.user.id));

    if (userId == null)
      try {
        await p2p.addMessage(
            state.user.id, '', 'tile', '${tileType.index}*$parentId', true, '');
      } on PlatformException {
        print('Flores: Failed addChat');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }

    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        likeMap: state.likeMap..[parentId] = like,
        commentMap: state.commentMap,
        tiles: state.tiles,
        templates: state.templates,
        progressMap: state.progressMap);
  }
}
