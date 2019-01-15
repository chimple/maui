import 'package:maui/actions/comment_actions.dart';
import 'package:maui/actions/tile_actions.dart';
import 'package:maui/actions/card_actions.dart';
import 'package:redux/redux.dart';

final loadingReducer = combineReducers<Map<String, bool>>([
  TypedReducer<Map<String, bool>, CommentsLoadedAction>(_setCommentsLoaded),
  TypedReducer<Map<String, bool>, CommentsNotLoadedAction>(_setCommentsLoaded),
  TypedReducer<Map<String, bool>, TilesLoadedAction>(_setTilesLoaded),
  TypedReducer<Map<String, bool>, TilesNotLoadedAction>(_setTilesLoaded),
  TypedReducer<Map<String, bool>, CardsLoadedAction>(_setCardsLoaded),
  TypedReducer<Map<String, bool>, CardsNotLoadedAction>(_setCardsLoaded),
]);

Map<String, bool> _setCommentsLoaded(Map<String, bool> state, action) {
  return Map.from(state)
    ..update('comments', (_) => false, ifAbsent: () => false);
}

Map<String, bool> _setTilesLoaded(Map<String, bool> state, action) {
  return Map.from(state)..update('tiles', (_) => false, ifAbsent: () => false);
}

Map<String, bool> _setCardsLoaded(Map<String, bool> state, action) {
  return Map.from(state)..update('cards', (_) => false, ifAbsent: () => false);
}
