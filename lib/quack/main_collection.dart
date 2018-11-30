import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';
import 'package:maui/loca.dart';
// import 'package:maui/components/animations.dart';
// import 'package:nima/nima_actor.dart';

class MainCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Loca.of(context).topics),
      ),
      body: Connect<RootState, List<QuackCard>>(
        convert: (state) => state.collectionMap['main']
            .map((cardId) => state.cardMap[cardId])
            .toList(growable: false),
        where: (prev, next) => next != prev,
        builder: (cards) {
          List<Widget> widgets = [];
          cards.forEach((c) {
            widgets.add(SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  c.title,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ));
            widgets.add(SliverToBoxAdapter(
              child: CollectionGrid(
                cardId: c.id,
                cardType: CardType.concept,
              ),
            ));
            widgets.add(SliverToBoxAdapter(
              child: Divider(),
            ));
          });
          return cards == null
              ? Container()
              : CustomScrollView(
                  primary: true,
//                itemExtent: media.size.width / 2.0,
                  slivers: widgets);
        },
      ),
    );
  }
}
