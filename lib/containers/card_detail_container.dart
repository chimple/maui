import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/actions/card_actions.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/card_detail.dart';
import 'package:redux/redux.dart';

class CardDetailContainer extends StatelessWidget {
  final QuackCard card;
  final String parentCardId;
  final bool showBackButton;

  const CardDetailContainer(
      {Key key, this.card, this.parentCardId, this.showBackButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RedState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store, card.id),
      builder: (context, vm) {
        return CardDetail(
          card: card,
          parentCardId: parentCardId,
          showBackButton: showBackButton,
          childCards: vm.childCards,
        );
      },
      onInit: (store) =>
          store.dispatch(loadCards(cardId: card.id, fetchSubCollections: true)),
      //TODO: add progress is first one
    );
  }
}

class _ViewModel {
  final List<QuackCard> childCards;
  final bool isLoading;

  _ViewModel({this.childCards, this.isLoading});

  static _ViewModel fromStore(Store<RedState> store, String cardId) {
    return _ViewModel(
      isLoading: store.state.isLoading['cards'],
      childCards: store.state.cards[cardId],
    );
  }
}
