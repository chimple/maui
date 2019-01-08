import 'dart:async';
import 'dart:convert';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/actions/fetch_initial_data.dart';
import 'package:maui/db/entity/card_progress.dart';
import 'package:maui/db/entity/like.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/repos/card_progress_repo.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/like_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:uuid/uuid.dart';

class SaveDrawing implements AsyncAction<RootState> {
  final String cardId;
  final Map<String, dynamic> jsonMap;

  TileRepo tileRepo;
  CardRepo cardRepo;

  SaveDrawing({this.cardId, this.jsonMap});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(tileRepo != null, 'tileRepo not injected');
    assert(cardRepo != null, 'cardRepo not injected');

    final card = await cardRepo.getCard(cardId);
    final tileId = jsonMap['id'];
    final tile = Tile(
        id: tileId,
        cardId: cardId,
        type: TileType.drawing,
        content: json.encode(jsonMap),
        updatedAt: DateTime.now(),
        userId: state.user.id,
        card: card,
        user: state.user);

    final updatedTile = await tileRepo.upsert(tile);
    final updatedDrawings = state.drawings ?? [];
    final index = updatedDrawings.indexWhere((t) => t.id == tileId);
    if (index >= 0) {
      updatedDrawings[index] = updatedTile;
    } else {
      updatedDrawings.add(updatedTile);
    }

//    final updatedTiles = state.tiles;
//    final tileIndex = updatedTiles.indexWhere((t) => t.id == tileId);
//    if (tileIndex >= 0) {
//      updatedTiles[index] = updatedTile;
//    } else {
//      updatedTiles.insert(0, updatedTile);
//    }

    return (RootState state) => RootState(
        frontMap: state.frontMap,
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        activityMap: state.activityMap,
        commentMap: state.commentMap,
        tiles: state.tiles,
        userMap: state.userMap,
        drawings: updatedDrawings,
        templates: state.templates);
  }
}
