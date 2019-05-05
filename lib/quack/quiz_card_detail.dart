import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/quack/card_header.dart';
import 'package:maui/quack/quiz_open.dart';
import 'package:maui/quack/quiz_selection.dart';

enum QuizItemStatus { selectable, correct, incorrect, unselectable }

typedef CanProceed(
    {List<QuizItem> quizItems,
    List<QuizItem> answers,
    List<QuizItem> startChoices,
    List<QuizItem> endChoices});

class QuizItem {
  int id;
  String text;
  QuizItemStatus status;
  bool isAnswer;
  int index;

  QuizItem({this.id, this.text, this.status, this.isAnswer, this.index});

  @override
  String toString() {
    return 'QuizItem{id: $id, text: $text, status: $status, isAnswer: $isAnswer, index: $index}';
  }
}

class QuizCardDetail extends StatelessWidget {
  final Quiz quiz;
  final List<QuizItem> answers;
  final List<QuizItem> startChoices;
  final List<QuizItem> endChoices;
  final String parentCardId;
  final CanProceed canProceed;
  final bool resultMode;

  const QuizCardDetail(
      {Key key,
      this.quiz,
      this.answers,
      this.startChoices,
      this.endChoices,
      this.parentCardId,
      this.canProceed,
      this.resultMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<QuizItem> quizItems;
    if (quiz.answers.length > 1 && quiz.type == QuizType.oneAtATime) {
      quiz.type = QuizType.many;
    }
    if (answers == null) {
      int id = 0;
      int index = 0;
      quizItems = quiz.choices
          .map((s) => QuizItem(
              id: id++,
              text: s,
              status: QuizItemStatus.selectable,
              isAnswer: false,
              index: index++))
          .toList();
      index = 0;
      quizItems.addAll(quiz.answers.map((s) => QuizItem(
          id: id++,
          text: s,
          status: QuizItemStatus.selectable,
          isAnswer: true,
          index: index++)));
    }

    MediaQueryData media = MediaQuery.of(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: media.size.height / 4,
          child: CardHeader(
            card: QuackCard(
                id: quiz.id, header: quiz.header, type: CardType.question),
            parentCardId: parentCardId,
          ),
        ),
        quiz.question == null
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(quiz.question ?? '',
                    style: Theme.of(context).textTheme.display1),
              ),
        Expanded(
          child: quiz.type == QuizType.open
              ? QuizOpen(
                  quiz: quiz,
                  canProceed: canProceed,
                )
              : QuizSelection(
                  quiz: quiz,
                  quizItems: quizItems,
                  answers: answers,
                  startChoices: startChoices,
                  endChoices: endChoices,
                  canProceed: canProceed,
                  resultMode: resultMode,
                ),
        )
      ],
    );
  }
}
