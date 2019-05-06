import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;

  _ChoiceDetail({this.number, this.reaction = Reaction.enter});
  @override
  String toString() => '_ChoiceDetail(choice: $number, reaction: $reaction)';
}

class FingerGame extends StatefulWidget {
  final int answer;
  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;

  const FingerGame({Key key, this.answer, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _FingerGameState createState() => _FingerGameState();
}

class _FingerGameState extends State<FingerGame> {
  List<int> fingers;
  List<_ChoiceDetail> choiceDetails;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fingers = widget.answer > 5 ? [5, widget.answer - 5] : [widget.answer];
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Row(
            children:
                fingers.map((f) => Text(f.toString())).toList(growable: false),
          ),
        ),
        Flexible(
          flex: 1,
          child: BentoBox(
            rows: 1,
            cols: choiceDetails.length,
            children: choiceDetails
                .map((c) => CuteButton(
                      key: Key(c.number.toString()),
                      child: DotNumber(
                        number: c.number,
                        showNumber: true,
                      ),
                      reaction: c.reaction,
                      onPressed: () {
                        setState(() {
                          score++;
                          if (c.number == widget.answer) {
                            c.reaction = Reaction.success;
                            widget.onGameUpdate(
                                score: score,
                                max: score,
                                gameOver: true,
                                star: true);
                          } else {
                            if (score > 0) score--;
                            c.reaction = Reaction.failure;
                          }
                        });
                      },
                    ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
