import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

// enum _Type { choice, question, answer }

class _ChoiceDetail {
  Reaction reaction;
  String choice;
  bool appear;
  _ChoiceDetail({this.reaction = Reaction.success, this.choice, this.appear});
  @override
  String toString() =>
      '_ChoiceDetail(choice $choice, appear: $appear , reaction: $reaction)';
}

class MultipleChoiceGame extends StatefulWidget {
  final String question;
  final BuiltList<String> choices;
  final BuiltList<String> answers;
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
  List<String> choices = [];
  var _dataLength = 0, _complete = 0, _score = 0, _count = 0;
  @override
  void initState() {
    super.initState();
    choices.addAll(widget.answers?.asList());
    choices.addAll(widget.choices?.asList());
    choices.shuffle();
    choiceDetails = choices
        .map((c) =>
            _ChoiceDetail(choice: c, appear: false, reaction: Reaction.success))
        .toList();
    _complete = widget.answers.length;
    _dataLength = widget.choices.length;
    _dataLength = (_dataLength / 2).ceil();
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
                cols: _dataLength,
                rows: _dataLength,
                dragConfig: DragConfig.fixed,
                qChildren: <Widget>[],
                children: choiceDetails.map((c) {
                  return CuteButton(
                    key: UniqueKey(),
                    child: Text(c.choice),
                    reaction: c.reaction,
                    onPressed: () {
                      if (widget.answers.contains(c.choice)) {
                        _score = _score + 2;
                        print('correct');
                        choiceDetails[choices.indexOf(c.choice)] =
                            _ChoiceDetail(
                                appear: true,
                                choice: c.choice,
                                reaction: Reaction.success);
                        choiceDetails.forEach((c) {
                          if (c.appear) {
                            _count++;
                            print('game over');
                            if (_count == _complete) {
                              widget.onGameUpdate(
                                  max: choices.length,
                                  score: _score,
                                  gameOver: true,
                                  star: true);
                            }
                          }
                        });
                        widget.onGameUpdate(
                            max: choices.length,
                            score: _score,
                            gameOver: false,
                            star: true);
                        return Reaction.success;
                      } else {
                        print('wrong');
                        _score--;
                        if (_score <= 0) {
                          _score = 0;
                        }
                        widget.onGameUpdate(
                            max: choices.length,
                            score: _score,
                            gameOver: false,
                            star: false);
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

  @override
  void dispose() {
    super.dispose();
  }
}
