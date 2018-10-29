import 'dart:async';
import 'dart:convert';
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

class SaveDrawing implements AsyncAction<RootState> {
  final String cardId;
  final Map<String, dynamic> jsonMap;

  TileRepo tileRepo;

  SaveDrawing({this.cardId, this.jsonMap});

  @override
  Future<Computation<RootState>> reduce(RootState state) async {
    assert(tileRepo != null, 'tileRepo not injected');
    final tileId = jsonMap['id'];
    final tile = Tile(
        id: tileId,
        cardId: cardId,
        type: TileType.drawing,
        content: json.encode(jsonMap),
        updatedAt: DateTime.now(),
        userId: state.user.id);

    final updatedTile = await tileRepo.upsert(tile);
    final updatedTiles = state.tiles;
    final index = updatedTiles.indexWhere((t) => t.id == tileId);
    if (index >= 0) {
      print('save_drawing: saving index $index');
      updatedTiles[index] = updatedTile;
    } else {
      updatedTiles.add(updatedTile);
    }

    return (RootState state) => RootState(
        user: state.user,
        collectionMap: state.collectionMap,
        cardMap: state.cardMap,
        likeMap: state.likeMap,
        commentMap: state.commentMap,
        tiles: updatedTiles,
        templates: state.templates,
        progressMap: state.progressMap);
  }
}
