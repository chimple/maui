import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/quack/quiz_card_detail.dart';

class QuizOpenDetail extends StatelessWidget {
  final QuackCard card;

  const QuizOpenDetail({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuizCardDetail(
        card: card,
        canProceed: (
                {List<QuizItem> quizItems,
                List<QuizItem> answers,
                List<QuizItem> startChoices,
                List<QuizItem> endChoices}) =>
            Navigator.of(context).pop(),
      ),
    );
  }
}
