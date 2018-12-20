import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/db/entity/quack_card.dart';

class CollectionGrid extends StatelessWidget {
  final String cardId;
  final CardType cardType;

  CollectionGrid({key, @required this.cardId, @required this.cardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Connect<RootState, List<QuackCard>>(
      convert: (state) => state.collectionMap[cardId]
          .map((id) => state.cardMap[id])
          .where((c) => c.type == cardType)
          .toList(growable: false),
      where: (prev, next) => next != prev,
      builder: (cardList) {
        int index = 0;
        return SizedBox(
          height: 220.0,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: cardList
                .map((c) => SliverToBoxAdapter(
                      child: Container(
                        constraints: BoxConstraints.tightFor(width: 160.0),
                        padding: const EdgeInsets.all(8.0),
                        child: CardSummary(
                          card: c,
                          index: index++,
                          parentCardId: cardId,
                        ),
                      ),
                    ))
                .toList(growable: false),
          ),
        );
      },
    );
  }
}
