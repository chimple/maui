import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  _ChoiceDetail({this.choice, this.reaction});
}

class SequenceTheNumberGame extends StatefulWidget {
  final BuiltList<int> sequence;
  final BuiltList<int> choices;
  final int blankPosition;
  final OnGameUpdate onGameUpdate;

  const SequenceTheNumberGame(
      {Key key,
      this.sequence,
      this.choices,
      this.blankPosition,
      this.onGameUpdate})
      : super(key: key);

  @override
  _SequenceTheNumberGameState createState() => _SequenceTheNumberGameState();
}

class _SequenceTheNumberGameState extends State<SequenceTheNumberGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> questionDetails;
  bool solved;
  int answerPosition;
  var score = 0;

  @override
  void initState() {
    super.initState();
    solved = false;
    answerPosition = widget.choices
        .indexWhere((c) => c == widget.sequence[widget.blankPosition]);
    questionDetails = widget.sequence
        .map((s) => _ChoiceDetail(
              choice: s.toString(),
              reaction: Reaction.success,
            ))
        .toList(growable: false);
    questionDetails[widget.blankPosition].choice = '?';
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(
              choice: c.toString(),
              reaction: Reaction.success,
            ))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final qChildren = questionDetails
        .map((c) => CuteButton(
              key: Key(c.choice),
              child: Center(
                child: Text(c.choice),
              ),
            ))
        .toList(growable: false);
    final children = choiceDetails
        .map((c) => CuteButton(
              key: Key(c.choice),
              child: Center(
                child: Text(c.choice),
              ),
              reaction: c.reaction,
              onPressed: () {
                setState(() {
                  if (c.choice ==
                      widget.sequence[widget.blankPosition].toString()) {
                    score++;
                    c.reaction = Reaction.success;
                    Future.delayed(
                        const Duration(milliseconds: 500),
                        () => setState(() {
                              solved = true;
                              widget.onGameUpdate(
                                  score: score,
                                  max: score,
                                  gameOver: true,
                                  star: true);
                            }));
                  } else {
                    score--;
                    c.reaction = Reaction.failure;
                  }
                });
              },
            ) as Widget)
        .toList(growable: false);
    if (solved) {
      qChildren[widget.blankPosition] = children[answerPosition];
      children[answerPosition] = Container();
    }
    return BentoBox(
      qRows: 1,
      qCols: questionDetails.length,
      qChildren: qChildren,
      rows: 1,
      cols: choiceDetails.length,
      children: children,
    );
  }
}
