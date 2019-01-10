import 'package:maui/actions/drawing_actions.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:redux/redux.dart';

final drawingReducer = combineReducers<List<Tile>>([
  TypedReducer<List<Tile>, AddDrawingAction>(_addDrawing),
]);

List<Tile> _addDrawing(List<Tile> tiles, AddDrawingAction action) {
  return List.from(tiles)
    ..removeWhere((t) => t.id == action.tile.id)
    ..insert(0, action.tile);
}
