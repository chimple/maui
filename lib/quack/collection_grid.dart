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

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return SizedBox(
      height: media.size.width / 3.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CardSummary(
              card: cards[index],
              index: index,
              parentCardId: cardId,
            ),
        itemCount: cards.length,
        itemExtent: media.size.width / 3.5,
      ),
    );
  }
}
