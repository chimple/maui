import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/collection_grid.dart';
// import 'package:maui/components/animations.dart';
// import 'package:nima/nima_actor.dart';

class TopicList extends StatelessWidget {
  final Map<String, List<QuackCard>> cards;

  const TopicList({Key key, this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    cards.forEach((k, v) {
      widgets.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            k,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ));
      widgets.add(SliverToBoxAdapter(
        child: CollectionGrid(cards: v),
      ));
      widgets.add(SliverToBoxAdapter(
        child: Divider(),
      ));
    });
    return CustomScrollView(
        primary: true,
//                itemExtent: media.size.width / 2.0,
        slivers: widgets);
  }
}
