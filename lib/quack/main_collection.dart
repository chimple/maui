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
    return Connect<RootState, List<QuackCard>>(
      convert: (state) => state.collectionMap['main']
          .map((cardId) => state.cardMap[cardId])
          .toList(growable: false),
      where: (prev, next) => next != prev,
      builder: (cards) {
        return cards == null
            ? Container()
            : ListView(
                primary: true,
                itemExtent: media.size.width / 2.0,
                children: cards
                    .map(
                      (c) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  c.title,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.title,
                                ),
                              )),
                              CollectionGrid(
                                cardId: c.id,
                                cardType: CardType.concept,
                              ),
                              Divider()
                            ],
                          ),
                    )
                    .toList(growable: false));
      },
    );
  }
}
