import 'package:flutter/services.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/repos/p2p.dart' as p2p;
import 'package:maui/repos/tile_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class LoadTilesAction {}

class TilesNotLoadedAction {}

class TilesLoadedAction {
  final List<Tile> tiles;

  TilesLoadedAction({this.tiles});
}

class AddTileAction {
  final Tile tile;

  AddTileAction({this.tile});
}

ThunkAction<RedState> addTile({Tile tile, String tileId}) {
  return (Store<RedState> store) async {
    Tile pTile;
    if (tileId != null) {
      pTile = await TileRepo().getTile(tileId);
    } else {
      await TileRepo().upsert(tile);
      pTile = await TileRepo().getTile(tile.id);
    }
    if (pTile.type == TileType.dot) {
      pTile = null;
    }
    if (pTile != null &&
        pTile.userId == store.state.user.id &&
        pTile.content.length < 12000)
      try {
        await p2p.addMessage(
            store.state.user.id,
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

    store.dispatch(AddTileAction(tile: tile));
  };
}

ThunkAction<RedState> loadTiles({String parentId, TileType tileType}) {
  return (Store<RedState> store) async {
    TileRepo().getTilesOtherThanDots().then(
      (tiles) {
        store.dispatch(
          TilesLoadedAction(
            tiles: tiles,
          ),
        );
      },
    ).catchError((_) => store.dispatch(TilesNotLoadedAction()));
  };
}
