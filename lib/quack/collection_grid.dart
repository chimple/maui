import 'package:flutter/material.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/db/entity/quack_card.dart';

class CollectionGrid extends StatelessWidget {
  final String cardId;
  final List<QuackCard> cards;
  final CardType cardType;

  CollectionGrid(
      {key,
      @required this.cardId,
      @required this.cardType,
      @required this.cards})
      : super(key: key);

  List<Widget> _buildList() {
    int index = 0;
    return cards
        .map((a) => CardSummary(
              card: a,
              index: index++,
              parentCardId: cardId,
            ))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
        crossAxisCount: cardType == CardType.knowledge ? 2 : 3,
        childAspectRatio: cardType == CardType.knowledge ? 3.0 : 1.0,
        children: _buildList());
  }
}
