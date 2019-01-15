import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_summary.dart';

class StoryList extends StatelessWidget {
  final List<QuackCard> cards;

  const StoryList({Key key, this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return GridView.count(
      crossAxisCount: (media.size.width / 210.0).ceil(),
      childAspectRatio: 0.75,
      children: cards
          .map(
            (c) => Center(
                  child: SizedBox(
                    height: 240.0,
                    width: 160.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardSummary(card: c),
                    ),
                  ),
                ),
          )
          .toList(growable: false),
    );
  }
}
