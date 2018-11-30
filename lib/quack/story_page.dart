import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/card_summary.dart';
import 'package:maui/loca.dart';
import 'package:maui/quack/collection_grid.dart';
import 'package:maui/repos/collection_repo.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';

class StoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Loca.of(context).stories),
      ),
      body: Connect<RootState, List<QuackCard>>(
        convert: (state) => state.collectionMap['story']
            .map((cardId) => state.cardMap[cardId])
            .toList(growable: false),
        where: (prev, next) => next != prev,
        builder: (cards) {
          return GridView.count(
              crossAxisCount: (media.size.width / 210.0).ceil(),
              childAspectRatio: 0.75,
              children: cards
                  .map((c) => Center(
                        child: SizedBox(
                          height: 240.0,
                          width: 160.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CardSummary(card: c),
                          ),
                        ),
                      ))
                  .toList(growable: false));
        },
      ),
    );
  }
}
