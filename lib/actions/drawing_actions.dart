import 'dart:convert';

import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/repos/card_repo.dart';
import 'package:maui/repos/tile_repo.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class AddDrawingAction {
  final Tile tile;

  AddDrawingAction({this.tile});
}

ThunkAction<RedState> saveDrawing(
    {String cardId, Map<String, dynamic> jsonMap}) {
  return (Store<RedState> store) async {
    final card = await CardRepo().getCard(cardId);
    final tileId = jsonMap['id'];
    final tile = Tile(
        id: tileId,
        cardId: cardId,
        type: TileType.drawing,
        content: json.encode(jsonMap),
        updatedAt: DateTime.now(),
        userId: store.state.user.id,
        card: card,
        user: store.state.user);

    final updatedTile = await TileRepo().upsert(tile);
  };
}
