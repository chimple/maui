import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';
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
    return Connect<RootState, List<String>>(
        convert: (state) => state.collectionMap[cardId],
        where: (prev, next) => next != prev,
        builder: (cardIdList) {
          return SizedBox(
            height: media.size.width / 3.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => CardSummary(
                    cardId: cardIdList[index],
                    index: index,
                    parentCardId: cardId,
                  ),
              itemCount: cardIdList.length,
              itemExtent: media.size.width / 3.5,
            ),
          );
        });
  }
}
