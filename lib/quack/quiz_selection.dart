import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/db/entity/quiz.dart';
import 'package:maui/quack/quiz_card_detail.dart';
import 'package:maui/quack/quiz_stack.dart';
import 'package:maui/state/app_state_container.dart';

class QuizSelection extends StatefulWidget {
  final Quiz quiz;
  final List<QuizItem> quizItems;
  final List<QuizItem> answers;
  final List<QuizItem> startChoices;
  final List<QuizItem> endChoices;
  final bool resultMode;
  final CanProceed canProceed;

  const QuizSelection(
      {Key key,
      this.quiz,
      this.quizItems,
      this.answers,
      this.startChoices,
      this.endChoices,
      this.resultMode,
      this.canProceed})
      : super(key: key);

  @override
  QuizSelectionState createState() {
    return new QuizSelectionState();
  }
}

class QuizSelectionState extends State<QuizSelection> {
  int _selectCount = 0;
  QuizItem _prevQuizItem;
  bool _prevOdd;
  List<QuizItem> _answers = [];
  List<QuizItem> _startChoices = [];
  List<QuizItem> _endChoices = [];
  int _numRows;

  @override
  void initState() {
    super.initState();
    var odd = true;
    if (widget.answers == null) {
      if (widget.quiz.type == QuizType.pair) {
        widget.quizItems.forEach((q) {
          if (odd) {
            _startChoices.add(q);
            odd = false;
          } else {
            _endChoices.add(q);
            odd = true;
          }
        });
      } else {
        _answers = List.from(widget.quizItems);
      }
      _startChoices.shuffle();
      _endChoices.shuffle();
      _answers.shuffle();
//      _numRows = widget.quizItems.length ~/ 2 +
//          ((widget.quiz.type == QuizType.pair) ? 0 : 1);
      _numRows = (widget.quizItems.length / 2).ceil();
    } else {
      _answers = widget.answers;
      _startChoices = widget.startChoices;
      _endChoices = widget.endChoices;
      _numRows = (_answers.length / 2).ceil() +
          max(_startChoices.length, _endChoices.length);
    }
  }

//  @override
//  void didUpdateWidget(QuizSelection oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.resultMode && !oldWidget.resultMode) {
//      _answers = [];
//      _endChoices = [];
//      _startChoices = [];
//      widget.quizItems.forEach((q) {
//        if (q.isAnswer) {
//          _answers.add(q);
//        } else {
//          if (_startChoices.length > _endChoices.length)
//            _endChoices.add(q);
//          else
//            _startChoices.add(q);
//        }
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final answersLength = _answers?.length ?? 0;
    final choicesLength =
        max(_startChoices?.length ?? 0, _endChoices?.length ?? 0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth / 2;
        final height = constraints.maxHeight / _numRows;
        List<Widget> widgets = [
          Container(
            constraints: BoxConstraints.expand(),
          )
        ];
        int i = 0;
        for (; i < answersLength; i = i + 2) {
          widgets.add(_quizButton(
              context: context,
              quizItem: _answers[i],
              row: i ~/ 2,
              col: 0,
              width: width,
              height: height));
          if (i + 1 < answersLength)
            widgets.add(_quizButton(
                context: context,
                quizItem: _answers[i + 1],
                row: i ~/ 2,
                col: 1,
                width: width,
                height: height));
        }
//        if (widget.quiz.type == QuizType.many && i == 0) i = 2;
        for (int j = 0; j < choicesLength; j++) {
          if (_startChoices.length > j)
            widgets.add(_quizButton(
                context: context,
                quizItem: _startChoices[j],
                row: _numRows - j - 1,
                col: 0,
                width: width,
                height: height));
          if (_endChoices.length > j)
            widgets.add(_quizButton(
                context: context,
                quizItem: _endChoices[j],
                row: _numRows - j - 1,
                col: 1,
                width: width,
                height: height));
        }
        return Stack(
          children: widgets,
        );
      },
    );
  }

  Widget _quizButton(
      {BuildContext context,
      QuizItem quizItem,
      int row,
      int col,
      double width,
      double height}) {
//    print(
//        '_quizButton: ${quizItem.text} row: $row, col: $col, top: ${row * height}');
    return AnimatedPositioned(
      key: ObjectKey(quizItem),
      duration: Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
      top: row * height,
      left: col * width,
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap:
              !widget.resultMode && quizItem.status == QuizItemStatus.selectable
                  ? () => _onPressed(quizItem, col == 0)
                  : null,
          child: Material(
            elevation: 8.0,
            color: !widget.resultMode &&
                    quizItem.status == QuizItemStatus.selectable
                ? Colors.white
                : _disabledColor(quizItem),
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 0.0,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: (quizItem.text?.endsWith('jpg') ||
                        quizItem.text?.endsWith('JPG') ||
                        quizItem.text?.endsWith('png') ||
                        quizItem.text?.endsWith('jp2') ||
                        quizItem.text?.endsWith('jpeg') ||
                        quizItem.text?.endsWith('gif'))
                    ? AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.file(
                          File(AppStateContainer.of(context).extStorageDir +
                              quizItem.text),
                          fit: BoxFit.cover,
                        ))
                    : Center(
                        child: Text(quizItem.text,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: Theme.of(context).textTheme.headline),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(QuizItem quizItem, bool odd) {
    setState(() {
      switch (widget.quiz.type) {
        case QuizType.oneAtATime:
          if (_prevQuizItem != null) {
            _prevQuizItem.status = QuizItemStatus.selectable;
          }
          if (quizItem.isAnswer) {
            quizItem.status = QuizItemStatus.correct;
          } else {
            quizItem.status = QuizItemStatus.incorrect;
          }
          _prevQuizItem = quizItem;

//          if (odd) {
////            _startChoices.remove(quizItem);
//            if (_prevQuizItem != null) {
//              _prevQuizItem.status = QuizItemStatus.selectable;
//              _answers.remove(_prevQuizItem);
////              _startChoices.add(_prevQuizItem);
//            }
//          } else {
////            _endChoices.remove(quizItem);
//            if (_prevQuizItem != null) {
//              _prevQuizItem.status = QuizItemStatus.selectable;
//              _answers.remove(_prevQuizItem);
////              _endChoices.add(_prevQuizItem);
//            }
//          }
//          if (quizItem.isAnswer) {
//            quizItem.status = QuizItemStatus.correct;
//          } else {
//            quizItem.status = QuizItemStatus.incorrect;
//          }
//          _answers.add(quizItem);
//          _prevQuizItem = quizItem;
          widget.canProceed(
              quizItems: widget.quizItems,
              answers: _answers,
              startChoices: _startChoices,
              endChoices: _endChoices);
          break;
        case QuizType.many:
          if (quizItem.isAnswer &&
              (widget.quiz.choices.length != 0 ||
                  _selectCount == quizItem.index)) {
            quizItem.status = QuizItemStatus.correct;
          } else {
            quizItem.status = QuizItemStatus.incorrect;
          }
          _answers.remove(quizItem);
          _answers.insert(_selectCount, quizItem);

//          if (quizItem.isAnswer &&
//              (widget.quiz.choices.length != 0 ||
//                  _selectCount == quizItem.index)) {
//            quizItem.status = QuizItemStatus.correct;
//          } else {
//            quizItem.status = QuizItemStatus.incorrect;
//          }
//          if (odd) {
//            _startChoices.remove(quizItem);
//            if (_endChoices.length > _startChoices.length + 1)
//              _startChoices.add(_endChoices.removeLast());
//          } else {
//            _endChoices.remove(quizItem);
//            if (_startChoices.length > _endChoices.length + 1)
//              _endChoices.add(_startChoices.removeLast());
//          }
//          _answers.add(quizItem);

          _selectCount++;
          if (widget.quiz.choices.length != 0 ||
              _selectCount >= widget.quiz.answers.length) {
            widget.canProceed(
                quizItems: widget.quizItems,
                answers: _answers,
                startChoices: _startChoices,
                endChoices: _endChoices);
          }
          break;
        case QuizType.pair:
          if ((_selectCount % 2) == 0) {
            _prevQuizItem = quizItem;
            _prevOdd = odd;
            _prevQuizItem.status = QuizItemStatus.unselectable;
          } else if (_prevOdd == odd) {
            _prevQuizItem.status = QuizItemStatus.selectable;
            _prevQuizItem = quizItem;
            _prevOdd = odd;
            _prevQuizItem.status = QuizItemStatus.unselectable;
            _selectCount--;
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
            if (odd) {
              _endChoices.remove(_prevQuizItem);
              _startChoices.remove(quizItem);
              _answers.add(quizItem);
              _answers.add(_prevQuizItem);
            } else {
              _startChoices.remove(_prevQuizItem);
              _endChoices.remove(quizItem);
              _answers.add(_prevQuizItem);
              _answers.add(quizItem);
            }
          }
          _selectCount++;
          if (_selectCount >= widget.quizItems.length) {
            widget.canProceed(
                quizItems: widget.quizItems,
                answers: _answers,
                startChoices: _startChoices,
                endChoices: _endChoices);
          }
          break;
      }
    });
  }

  Widget _indicator(QuizItem quizItem) {
    if (widget.resultMode) {
      switch (quizItem.status) {
        case QuizItemStatus.correct:
          return Icon(
            Icons.check_circle,
            color: Colors.green,
          );
          break;
        case QuizItemStatus.incorrect:
          return Icon(
            Icons.cancel,
            color: Colors.red,
          );
          break;
        case QuizItemStatus.unselectable:
          if (quizItem.isAnswer) {
            return Icon(
              Icons.cancel,
              color: Colors.red,
            );
            ;
          } else {
            return Container();
          }
          break;
        case QuizItemStatus.selectable:
          if (quizItem.isAnswer) {
            return Icon(
              Icons.cancel,
              color: Colors.red,
            );
            ;
          } else {
            return Container();
          }
      }
    } else {
      return Container();
    }
  }

  Color _disabledColor(QuizItem quizItem) {
    if (!widget.resultMode) {
      return Colors.blue;
    }
    switch (quizItem.status) {
      case QuizItemStatus.correct:
        return Colors.green;
        break;
      case QuizItemStatus.incorrect:
        return Colors.red;
        break;
      case QuizItemStatus.unselectable:
        if (quizItem.isAnswer) {
          return Colors.green;
        } else {
          return Colors.white;
        }
        break;
      case QuizItemStatus.selectable:
        if (quizItem.isAnswer) {
          return Colors.green;
        } else {
          return Colors.white;
        }
        break;
    }
  }
}
