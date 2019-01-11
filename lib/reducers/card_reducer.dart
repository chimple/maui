import 'package:maui/actions/card_actions.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:redux/redux.dart';

final cardReducer = combineReducers<Map<String, List<QuackCard>>>([
  TypedReducer<Map<String, List<QuackCard>>, CardsLoadedAction>(
      _setLoadedCards),
  TypedReducer<Map<String, List<QuackCard>>, CardsNotLoadedAction>(_setNoCards),
]);

Map<String, List<QuackCard>> _setLoadedCards(
    Map<String, List<QuackCard>> cards, CardsLoadedAction action) {
  return action.cards;
}

Map<String, List<QuackCard>> _setNoCards(
    Map<String, List<QuackCard>> cards, CardsNotLoadedAction action) {
  return {};
}
