import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maui/actions/card_actions.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/tile.dart';
import 'package:maui/loca.dart';
import 'package:maui/models/red_state.dart';
import 'package:maui/quack/story_list.dart';
import 'package:maui/quack/tile_list.dart';
import 'package:redux/redux.dart';

class StoriesContainer extends StatelessWidget {
  const StoriesContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Loca.of(context).stories),
      ),
      body: StoreConnector<RedState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          if (vm.isLoading)
            return SliverToBoxAdapter(
              child: Center(
                child: new SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: new CircularProgressIndicator(),
                ),
              ),
            );
          return StoryList(
            cards: vm.cards,
          );
        },
        onInit: (store) => store.dispatch(loadCards(cardId: 'story')),
      ),
    );
  }
}

class _ViewModel {
  final List<QuackCard> cards;
  final bool isLoading;

  _ViewModel({this.cards, this.isLoading});

  static _ViewModel fromStore(Store<RedState> store) {
    return _ViewModel(
      isLoading: store.state.isLoading['cards'],
      cards: store.state.cards != null ? store.state.cards['story'] : null,
    );
  }
}
