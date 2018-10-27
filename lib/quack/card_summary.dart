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

  static final cardTypeAspectRatio = {
    CardType.knowledge: 1.0,
    CardType.concept: 1.0,
    CardType.activity: 1.0,
    CardType.question: 1.0
  };

  CardSummary({Key key, @required this.card, this.index, this.parentCardId})
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
          parentCardId: parentCardId,
        );
        break;
      case CardType.activity:
        return ActivityCard(
          card: card,
          parentCardId: parentCardId,
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
