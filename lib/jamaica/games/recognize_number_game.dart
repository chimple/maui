import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/audio_widget.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;

  _ChoiceDetail({this.number, this.reaction = Reaction.success});
  @override
  String toString() => '_ChoiceDetail(choice: $number, reaction: $reaction)';
}

class RecognizeNumberGame extends StatefulWidget {
  final int answer;
  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;

  const RecognizeNumberGame(
      {Key key, this.answer, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _RecognizeNumberGameState createState() => _RecognizeNumberGameState();
}

class _RecognizeNumberGameState extends State<RecognizeNumberGame> {
  List<_ChoiceDetail> choiceDetails;
  var score = 0;
  int complete = 1;
  int count = 0;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      qRows: 1,
      qCols: 1,
      qChildren: <Widget>[
        AudioWidget(
          word: widget.answer.toString(),
          play: true,
        )
      ],
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
                    if ((c.number == widget.answer)) {
                      score = score + 2;
                      c.reaction = Reaction.success;
                      widget.onGameUpdate(
                          score: score, max: 2, gameOver: true, star: true);
                    } else {
                      score = score - 1;
                      c.reaction = Reaction.failure;
                      count++;
                      if (count == 2) {
                        print("object is new reduced score");
                        widget.onGameUpdate(
                            score: score, max: 2, gameOver: true, star: false);
                      }
                    }
                  });
                },
              ))
          .toList(growable: false),
    );
  }
}
