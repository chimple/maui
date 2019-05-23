import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/models/display_item.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';

// enum _Type { choice, question, answer }

class _ChoiceDetail {
  Reaction reaction;
  DisplayItem choice;
  bool appear;
  int index = 0;
  _ChoiceDetail(
      {this.reaction = Reaction.success, this.choice, this.appear, this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice $choice, appear: $appear , reaction: $reaction)';
}

class MultipleChoiceGame extends StatefulWidget {
  final DisplayItem question;
  final BuiltList<DisplayItem> choices;
  final BuiltList<DisplayItem> answers;
  final OnGameUpdate onGameUpdate;
  MultipleChoiceGame(
      {Key key, this.answers, this.choices, this.question, this.onGameUpdate})
      : super(key: key);
  @override
  _MultipleChoiceGameState createState() => new _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends State<MultipleChoiceGame> {
  List<_ChoiceDetail> choiceDetails;
  // List<_ChoiceDetail> answerDetails;
  List<DisplayItem> choices = [];
  var _dataLength = 0, _complete = 0, _score = 0, _max = 0;
  int flag = 0;
  @override
  void initState() {
    int i = 0;
    super.initState();
    // choices.addAll(widget.answers?.asList());
    // choices.addAll(widget.choices?.asList());
    Set<DisplayItem> ch = Set<DisplayItem>();
    ch.addAll(widget.answers);
    ch.addAll(widget.choices);
    choices.addAll(ch);
    choices.shuffle();
    choiceDetails = choices
        .map((c) => _ChoiceDetail(
            choice: c, appear: false, reaction: Reaction.success, index: i++))
        .toList();
    _complete = widget.answers.length;
    _dataLength = widget.choices.length;
    _max = widget.choices.length;
    _dataLength = (_dataLength / 2).ceil();
    print('choiceDetails:: $choiceDetails, length $_dataLength');
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      calculateLayout: BentoBox.calculateVerticalLayout,
      axis: Axis.vertical,
      cols: _dataLength != 1 ? _dataLength : 2,
      rows: _dataLength,
      dragConfig: DragConfig.fixed,
      qChildren: <Widget>[
        CuteButton(
          key: Key('question'),
          displayItem: widget.question,
          cuteButtonType: CuteButtonType.text,
        )
      ],
      qRows: 1,
      qCols: 1,
      children: choiceDetails.map((c) {
        return CuteButton(
          key: Key('${c.choice}_${c.index}'),
          displayItem: c.choice,
          reaction: c.reaction,
          onPressed: () {
            if (widget.answers.contains(c.choice)) {
              _score = _score + 2;
              print('correct');
              choiceDetails[choices.indexOf(c.choice)] = _ChoiceDetail(
                  appear: true, choice: c.choice, reaction: Reaction.success);

              int count = 0;
              choiceDetails.forEach((c) {
                if (c.appear) {
                  count++;
                  print('game over');
                  if (count == _complete) {
                    widget.onGameUpdate(
                        max: _max * 2,
                        score: _score,
                        gameOver: true,
                        star: true);
                    setState(() {});
                  }
                }
              });
              widget.onGameUpdate(
                  max: _max * 2, score: _score, gameOver: false, star: true);
              return Reaction.success;
            } else {
              print('wrong');
              _score--;
              if (_score <= 0) {
                _score = 0;
              }
              widget.onGameUpdate(
                  max: _max * 2, score: _score, gameOver: false, star: false);
              return Reaction.failure;
            }
          },
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
