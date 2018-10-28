import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/quack/quiz_card_detail.dart';

class QuizSelection extends StatefulWidget {
  final Quiz quiz;
  final List<QuizItem> quizItems;
  final bool resultMode;
  final CanProceed canProceed;

  const QuizSelection(
      {Key key, this.quiz, this.quizItems, this.resultMode, this.canProceed})
      : super(key: key);

  @override
  QuizSelectionState createState() {
    return new QuizSelectionState();
  }
}

class QuizSelectionState extends State<QuizSelection> {
  int _selectCount = 0;
  QuizItem _prevQuizItem;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.quizItems
            .map((s) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(s.text),
                    onPressed: (!widget.resultMode &&
                            s.status == QuizItemStatus.selectable)
                        ? () => _onPressed(s)
                        : null,
                    disabledColor:
                        widget.resultMode ? _disabledColor(s) : Colors.grey,
                  ),
                ))
            .toList(growable: false));
  }

  Color _disabledColor(QuizItem quizItem) {
    switch (quizItem.status) {
      case QuizItemStatus.correct:
        return Colors.green;
        break;
      case QuizItemStatus.incorrect:
        return Colors.red;
        break;
      case QuizItemStatus.unselectable:
        if (quizItem.isAnswer) {
          return Colors.red;
        } else {
          return Colors.white;
        }
        break;
      case QuizItemStatus.selectable:
        if (quizItem.isAnswer) {
          return Colors.red;
        } else {
          return Colors.white;
        }
        break;
    }
  }

  void _onPressed(QuizItem quizItem) {
    setState(() {
      switch (widget.quiz.type) {
        case QuizType.oneAtATime:
          widget.quizItems
              .where((q) => q.status != QuizItemStatus.selectable)
              .forEach((q) => q.status = QuizItemStatus.selectable);
          if (quizItem.isAnswer) {
            quizItem.status = QuizItemStatus.correct;
          } else {
            quizItem.status = QuizItemStatus.incorrect;
          }
          widget.canProceed(widget.quizItems);
          break;
        case QuizType.many:
          if (quizItem.isAnswer &&
              (widget.quiz.choices.length != 0 ||
                  _selectCount == quizItem.index)) {
            quizItem.status = QuizItemStatus.correct;
          } else {
            quizItem.status = QuizItemStatus.incorrect;
          }
          _selectCount++;
          if (widget.quiz.choices.length != 0 ||
              _selectCount >= widget.quiz.answers.length) {
//            _quizItems
//                .where((q) => q.status == QuizItemStatus.selectable)
//                .forEach((q) => q.status = QuizItemStatus.incorrect);
            widget.canProceed(widget.quizItems);
          }
          break;
        case QuizType.pair:
          if ((_selectCount % 2) == 0) {
            _prevQuizItem = quizItem;
            _prevQuizItem.status = QuizItemStatus.unselectable;
          } else {
            int minIndex = min(_prevQuizItem.index, quizItem.index);
            int maxIndex = max(_prevQuizItem.index, quizItem.index);
            if ((maxIndex - minIndex) == 1 && (minIndex % 2) == 0) {
              _prevQuizItem.status = QuizItemStatus.correct;
              quizItem.status = QuizItemStatus.correct;
            } else {
              _prevQuizItem.status = QuizItemStatus.incorrect;
              quizItem.status = QuizItemStatus.incorrect;
            }
          }
          _selectCount++;
          if (_selectCount >= widget.quizItems.length) {
            widget.canProceed(widget.quizItems);
          }
          break;
      }
    });
  }
}
