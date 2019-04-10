import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_summary.dart';

class CollectionGrid extends StatelessWidget {
  final List<QuackCard> cards;

  CollectionGrid({key, @required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return SizedBox(
      height: 220.0,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: cards
            .map((c) => SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints.tightFor(width: 160.0),
                    padding: const EdgeInsets.all(8.0),
                    child: CardSummary(
                      card: c,
                      index: index++,
                    ),
                  ),
                ))
            .toList(growable: false),
      ),
    );
  }
}
