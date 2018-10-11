import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/activity_card.dart';
import 'package:maui/quack/concept_card.dart';
import 'package:maui/quack/knowledge_card.dart';

final cardTypeColors = {
  CardType.knowledge: Colors.greenAccent,
  CardType.concept: Colors.lightBlueAccent,
  CardType.activity: Colors.amberAccent,
  CardType.question: Colors.limeAccent
};

class CardSummary extends StatelessWidget {
  final QuackCard card;
  final int index;
  final String parentCardId;

  CardSummary(
      {Key key, @required this.card, @required this.index, this.parentCardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardTypeColors[card.type],
      margin: EdgeInsets.all(8.0),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    switch (card.type) {
      case CardType.concept:
        return ConceptCard(
          card: card,
        );
        break;
      case CardType.activity:
        return ActivityCard(
          card: card,
        );
        break;
      case CardType.knowledge:
        return KnowledgeCard(
          card: card,
          parentCardId: parentCardId,
          index: index,
        );
        break;
      case CardType.question:
        return Container();
        break;
    }
  }
}
