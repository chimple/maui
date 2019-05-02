import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

enum _Type { choice, question, answer }

class _ChoiceDetail {
  int number;
  Reaction reaction;
  String choice;
  String answer;
  _Type type;
  int index;
  bool appear;
  _ChoiceDetail(
      {this.number,
      this.type = _Type.choice,
      this.reaction = Reaction.success,
      this.index,
      this.choice,
      this.answer,
      this.appear});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, answer: $answer, appear: $appear , type: $type, index: $index, reaction: $reaction)';
}

class MultipleChoiceGame extends StatefulWidget {
  final String question;
  final BuiltList<String> choices;
  final BuiltList<String> answers;
  final OnGameOver onGameOver;
  MultipleChoiceGame(
      {Key key, this.answers, this.choices, this.question, this.onGameOver})
      : super(key: key);
  @override
  _MultipleChoiceGameState createState() => new _MultipleChoiceGameState();
}

class _MultipleChoiceGameState extends State<MultipleChoiceGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;
  var _dataLen = 0, _complete = 0, _count=0;
  @override
  void initState() {
    super.initState();
    int i = 0;
    int j = 0;
    choiceDetails = widget.choices
        .map((c) =>
            _ChoiceDetail(choice: c, index: i++, reaction: Reaction.success))
        .toList();
    widget.answers.map((c) {
      choiceDetails.add(_ChoiceDetail(choice: c, index: i++));
    }).toList();
    // answerDetails = widget.answers
    //     .map((a) => _ChoiceDetail(choice: a, appear: false, index: j++))
    //     .toList(growable: false);
    _complete = widget.answers.length;
    _dataLen = widget.answers.length + widget.choices.length;
    _dataLen = (_dataLen / 2).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Center(
              child: Text(
                widget.question,
                style: Theme.of(context).textTheme.display1,
              ),
            ),
          ),
          Expanded(
              flex: 7,
              child: BentoBox(
                calculateLayout: BentoBox.calculateVerticalLayout,
                axis: Axis.vertical,
                cols: _dataLen,
                rows: _dataLen,
                dragConfig: DragConfig.fixed,
                qChildren: <Widget>[],
                children: choiceDetails.map((c) {
                  return CuteButton(
                    key: UniqueKey(),
                    child: Text(c.choice),
                    reaction: c.reaction,
                    onPressed: () {
                      if (_count++ == _complete) {
                          widget.onGameOver(_count);
                        }
                      if (widget.answers.contains(c.choice)) {
                        return Reaction.success;
                      } else {
                        return Reaction.failure;
                      }
                       
                    },
                  );
                }).toList(),
              ))
        ],
      ),
    );
  }
}
