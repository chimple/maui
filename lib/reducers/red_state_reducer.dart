import 'package:maui/models/red_state.dart';
import 'package:maui/reducers/loading_reducer.dart';
import 'package:maui/reducers/comment_reducer.dart';
import 'package:maui/reducers/tile_reducer.dart';
import 'package:maui/reducers/drawing_reducer.dart';
import 'package:maui/reducers/card_reducer.dart';
import 'package:maui/reducers/user_reducer.dart';
import 'package:maui/reducers/activity_reducer.dart';

RedState appReducer(RedState state, action) {
  return RedState(
      isLoading: loadingReducer(state.isLoading, action),
      user: userReducer(state.user, action),
      activityMap: activityReducer(state.activityMap, action),
      comments: commentReducer(state.comments, action),
      tiles: tileReducer(state.tiles, action),
      drawings: drawingReducer(state.tiles, action),
      cards: cardReducer(state.cards, action));
}
