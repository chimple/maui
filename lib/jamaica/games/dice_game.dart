import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;
  _Type type;
  int index;

  _ChoiceDetail({
    this.number,
    this.type = _Type.choice,
    this.reaction = Reaction.success,
    this.index,
  });
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, type: $type, index: $index, reaction: $reaction)';
}

enum _Type { choice, question, answer }

class DiceGame extends StatefulWidget {
  final int question;
  final int answerPosition;
  final BuiltList<int> choices;
  final OnGameOver onGameOver;

  const DiceGame(
      {Key key,
      this.question,
      this.answerPosition,
      this.choices,
      this.onGameOver})
      : super(key: key);

  @override
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c, index: i++))
        .toList(growable: false);
    answerDetails = [
      _ChoiceDetail(number: widget.question, index: 99, type: _Type.question),
      choiceDetails[widget.answerPosition],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      dragConfig: DragConfig.draggableBounceBack,
      rows: 1,
      cols: choiceDetails.length,
      children: choiceDetails
          .map((c) => c.type == _Type.choice
              ? CuteButton(
                  key: Key(c.index.toString()),
                  child: DotNumber(
                    number: c.number,
                    showNumber: false,
                  ),
                )
              : Container())
          .toList(growable: false),
      qCols: 1,
      qRows: 2,
      qChildren: answerDetails.map((a) {
        switch (a.type) {
          case _Type.question:
            return Center(
                key: Key(a.index.toString()),
                child: Text(
                  a.number.toString(),
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ));
            break;
          case _Type.choice:
            return DragTarget<String>(
              key: Key('choice'),
              builder: (context, candidateData, rejectedData) => Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  ),
              onWillAccept: (data) {
                print(data);
                return data == widget.answerPosition.toString();
              },
              onAccept: (data) {
                WidgetsBinding.instance.addPostFrameCallback((_) => setState(
                    () => choiceDetails[widget.answerPosition].type =
                        _Type.answer));
                widget.onGameOver(1);
              },
            );
            break;
          case _Type.answer:
            return CuteButton(
              key: Key('answer'),
              child: DotNumber(
                number: a.number,
                showNumber: false,
              ),
            );
            break;
        }
      }).toList(growable: false),
    );
  }
}
