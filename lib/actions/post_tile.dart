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
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;

class PostTile implements AsyncAction<RootState> {
  final Tile tile;

  TileRepo tileRepo;

  PostTile({this.tile});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(tileRepo != null, 'tileRepo not injected');

    await tileRepo.insert(tile);
    tile
      ..card = state.cardMap[tile.cardId]
      ..user = state.user;

    if (tile.userId == state.user?.id)
      try {
        await p2p.addMessage(
            state.user.id,
            '0',
            'tile',
            '${tile.id}*${tile.type.index}*${tile.cardId}*${tile.content}',
            true,
            '');
      } on PlatformException {
        print('Flores: Failed addMessage');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }

    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        commentMap: state.commentMap,
        activityMap: state.activityMap,
        tiles: state.tiles..insert(0, tile),
        userMap: state.userMap,
        drawings: state.drawings,
        templates: state.templates);
  }
}
