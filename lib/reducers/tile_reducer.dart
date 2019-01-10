import 'package:maui/actions/activity_actions.dart';
import 'package:maui/actions/tile_actions.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:redux/redux.dart';

final tileReducer = combineReducers<List<Tile>>([
  TypedReducer<List<Tile>, AddTileAction>(_addTile),
  TypedReducer<List<Tile>, TilesLoadedAction>(_setLoadedTiles),
  TypedReducer<List<Tile>, TilesNotLoadedAction>(_setNoTiles),
  TypedReducer<List<Tile>, AddLikeAction>(_setLikeAdd),
]);

List<Tile> _addTile(List<Tile> tiles, AddTileAction action) {
  return List.from(tiles)
    ..removeWhere((t) => t.id == action.tile.id)
    ..insert(0, action.tile);
}

List<Tile> _setLoadedTiles(List<Tile> tiles, TilesLoadedAction action) {
  return action.tiles;
}

List<Tile> _setNoTiles(List<Tile> tiles, TilesNotLoadedAction action) {
  return [];
}

List<Tile> _setLikeAdd(List<Tile> tiles, AddLikeAction action) {
  final returnTiles = List<Tile>.from(tiles);
  final likeTile = returnTiles.firstWhere((t) => t.id == action.parentId,
      orElse: () => null);
  if (likeTile != null) likeTile.likes = (likeTile.likes ?? 0) + 1;
  return returnTiles;
}
