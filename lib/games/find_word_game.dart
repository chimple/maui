import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';

class _ChoiceDetail {
  String letter;
  Reaction reaction;

  _ChoiceDetail({this.letter, this.reaction = Reaction.success});
  @override
  String toString() => '_ChoiceDetail(choice: $letter, reaction: $reaction)';
}

class FindWordGame extends StatefulWidget {
  final String image;
  final BuiltList<String> answer;
  final BuiltList<String> choices;
  final OnGameUpdate onGameUpdate;

  const FindWordGame(
      {Key key, this.image, this.answer, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _FindWordGameState createState() => _FindWordGameState();
}

class _FindWordGameState extends State<FindWordGame> {
  List<_ChoiceDetail> choiceDetails;
  List<String> word = [];
  int score = 0, tries = 0;
  final int wrongAttempts = 2;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(letter: c))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Image.asset(widget.image),
        ),
        Flexible(
          flex: 1,
          child: Text(word.join()),
        ),
        Flexible(
          flex: 1,
          child: BentoBox(
            rows: 2,
            cols: choiceDetails.length ~/ 2,
            children: choiceDetails
                .map((c) => CuteButton(
                      key: Key(c.letter),
                      reaction: c.reaction,
                      child: Center(child: Text(c.letter)),
                      onPressed: () {
                        if (c.letter == widget.answer[word.length]) {
                          setState(() {
                            score += 2;
                            c.reaction = Reaction.success;
                            tries = 0;
                            word.add(c.letter);
                            if (word.length == widget.answer.length)
                              widget.onGameUpdate(
                                  score: score,
                                  max: widget.answer.length * 2,
                                  gameOver: true,
                                  star: true);
                          });
                        } else {
                          score--;
                          if (++tries == wrongAttempts)
                            widget.onGameUpdate(
                                score: score,
                                max: widget.answer.length * 2,
                                gameOver: true,
                                star: false);
                          c.reaction = Reaction.failure;
                        }
                      },
                    ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
