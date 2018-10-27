import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';

class MainCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('mainCollection: build');
    final media = MediaQuery.of(context);
    return Connect<RootState, List<String>>(
      convert: (state) => state.collectionMap['main'],
      where: (prev, next) => next != prev,
      builder: (cardIdList) {
        return ListView(
            primary: true,
            itemExtent: media.size.width / 3.5,
            children: cardIdList
                .map(
                  (c) => CollectionGrid(
                        cardId: c,
                        cardType: CardType.concept,
                      ),
                )
                .toList(growable: false));
      },
    );
  }
}
