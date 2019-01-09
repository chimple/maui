import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class LoadCardsAction {}

class CardsNotLoadedAction {}

class CardsLoadedAction {
  final Map<String, List<QuackCard>> cards;

  CardsLoadedAction({this.cards});
}

ThunkAction<RedState> loadCards(
    {String cardId, bool fetchSubCollections = false}) {
  return (Store<RedState> store) async {
    final cards = store.state.cards;
    final cs = await CollectionRepo().getCardsInCollection(cardId);
    cards[cardId] = cs;
    if (fetchSubCollections) {
      await Future.forEach(cs, (subcard) async {
        cards[subcard.id] =
            await CollectionRepo().getCardsInCollection(subcard.id);
      });
    }
    store.dispatch(
      CardsLoadedAction(
        cards: cards,
      ),
    );
  };
}
