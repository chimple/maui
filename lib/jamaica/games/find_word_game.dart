import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

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
  final OnGameOver onGameOver;

  const FindWordGame(
      {Key key, this.image, this.answer, this.choices, this.onGameOver})
      : super(key: key);

  @override
  _FindWordGameState createState() => _FindWordGameState();
}

class _FindWordGameState extends State<FindWordGame> {
  List<_ChoiceDetail> choiceDetails;
  List<String> word = [];
  int score = 0;

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
                        widget.onGameOver(1);
                        if (c.letter == widget.answer[word.length]) {
                          setState(() {
                            score++;
                            c.reaction = Reaction.success;
                            word.add(c.letter);
                            if (word.length == widget.answer.length)
                              widget.onGameOver(score);
                          });
                        } else {
                          if (score > 0) score--;
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
