import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
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
  final String cardId;
  final int index;
  final String parentCardId;

  static final cardTypeAspectRatio = {
    CardType.knowledge: 1.0,
    CardType.concept: 1.0,
    CardType.activity: 1.0,
    CardType.question: 1.0
  };

  CardSummary({Key key, @required this.cardId, this.index, this.parentCardId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Connect<RootState, QuackCard>(
      convert: (state) => state.cardMap[cardId],
      where: (prev, next) => next != prev,
      builder: (card) {
        return Card(
          color: cardTypeColors[card.type],
          margin: EdgeInsets.all(8.0),
          child: _buildCard(card),
        );
      },
    );
  }

  Widget _buildCard(QuackCard card) {
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
