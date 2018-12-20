import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:uuid/uuid.dart';
import 'package:maui/repos/p2p.dart' as p2p;

class PostTile implements AsyncAction<RootState> {
  final Tile tile;
  final String tileId;

  TileRepo tileRepo;

  PostTile({this.tileId, this.tile});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(tileRepo != null, 'tileRepo not injected');
    Tile pTile;

    if (tileId != null) {
      pTile = await tileRepo.getTile(tileId);
    } else {
      await tileRepo.upsert(tile);
      pTile = await tileRepo.getTile(tile.id);
    }
    print('post_tile: $pTile');
    if (pTile.type == TileType.dot) {
      pTile = null;
    }

    if (pTile != null &&
        pTile.userId == state.user?.id &&
        pTile.content.length < 12000)
      try {
        await p2p.addMessage(
            state.user.id,
            '0',
            'tile',
            '${pTile.id}${floresSeparator}${pTile.type.index}${floresSeparator}${pTile.cardId}${floresSeparator}${pTile.content}',
            true,
            '');
      } on PlatformException {
        print('Flores: Failed addMessage');
      } catch (e, s) {
        print('Exception details:\n $e');
        print('Stack trace:\n $s');
      }

    final updatedTiles = state.tiles;
    print('posttile: $pTile ${pTile.card}');
    if (pTile != null) {
      state.tiles.removeWhere((t) => t.id == pTile.id);
      state.tiles.insert(0, pTile);
    }

    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        commentMap: state.commentMap,
        activityMap: state.activityMap,
        tiles: updatedTiles,
        userMap: state.userMap,
        drawings: state.drawings,
        templates: state.templates);
  }
}
