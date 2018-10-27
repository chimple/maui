import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/repos/collection_repo.dart';

class MainCollection extends StatefulWidget {
  @override
  MainCollectionState createState() {
    return new MainCollectionState();
  }
}

class MainCollectionState extends State<MainCollection> {
  bool _isLoading = true;
  List<QuackCard> _cards;
  List<List<QuackCard>> _conceptCards = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    print('mainCollection: initData');
    _cards = await CollectionRepo()
        .getCardsInCollectionByType('main', CardType.concept);
    await Future.forEach(
        _cards,
        (c) async => _conceptCards.add(await CollectionRepo()
            .getCardsInCollectionByType(c.id, CardType.concept)));
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print('mainCollection: build');
    final media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    int i = 0;
    return ListView(
        primary: true,
        itemExtent: media.size.width / 3.5,
        children: _conceptCards
            .map(
              (c) => CollectionGrid(
                    cardId: _cards[i++].id,
                    cards: c,
                    cardType: CardType.concept,
                  ),
            )
            .toList(growable: false));
  }
}
