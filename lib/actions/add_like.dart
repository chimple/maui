import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/user_activity.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/repos/user_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    //TODO maybe update card in db also
    switch (tileType) {
      case TileType.card:
        state.cardMap[parentId].likes =
            (state.cardMap[parentId].likes ?? 0) + 1;
        break;
      case TileType.drawing:
        final likeTile =
            state.tiles.firstWhere((t) => t.id == parentId, orElse: () => null);
        if (likeTile != null) likeTile.likes = (likeTile.likes ?? 0) + 1;
        break;
      case TileType.message:
        final likeTile =
            state.tiles.firstWhere((t) => t.id == parentId, orElse: () => null);
        if (likeTile != null) likeTile.likes = (likeTile.likes ?? 0) + 1;
        break;
    }

//    var tile =
//        state.tiles.firstWhere((t) => t.id == parentId, orElse: () => null);
//    print('tile: $tile');
//    if (tile == null) {
//      tile = Tile(
//          id: Uuid().v4(),
//          cardId: parentId,
//          content: '${user.name} liked this',
//          type: TileType.card,
//          userId: userId ?? state.user.id,
//          updatedAt: DateTime.now(),
//          card: state.cardMap[parentId],
//          user: state.user); //TODO put real user
//      await tileRepo.insert(tile);
//    }

    final userActivity = state.activityMap[parentId] ?? UserActivity();
    if (userId == null) {
      userActivity.like = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userActivity', json.encode(state.activityMap));

      try {
        await p2p.addMessage(state.user.id, '0', 'like',
            '${tileType.index}${floresSeparator}$parentId', true, '');
      } on PlatformException {
        print('Flores: Failed addChat');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }
    }

    return (RootState state) {
      return RootState(
          frontMap: state.frontMap,
          user: state.user,
          collectionMap: state.collectionMap,
          cardMap: state.cardMap,
          activityMap: userId != null ? state.activityMap : state.activityMap
            ..[parentId] = userActivity,
          commentMap: state.commentMap,
          tiles: state.tiles,
          drawings: state.drawings,
          userMap: state.userMap,
          templates: state.templates);
    };
  }
}
