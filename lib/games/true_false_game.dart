import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';
import 'package:maui/widgets/game_score.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  int index;

  _ChoiceDetail({this.choice, this.reaction = Reaction.success, this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, reaction: $reaction, index: $index)';
}

class TrueFalseGame extends StatefulWidget {
  final String question;
  final String answer;
  final bool right_or_wrong;
  final OnGameUpdate onGameUpdate;

  const TrueFalseGame(
      {Key key,
      this.question,
      this.answer,
      this.right_or_wrong,
      this.onGameUpdate})
      : super(key: key);

  @override
  _RhymeWordsGameState createState() => _RhymeWordsGameState();
}

class _RhymeWordsGameState extends State<TrueFalseGame> {
  // List<_ChoiceDetail> choiceDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      axis: Axis.vertical,
      qCols: 1,
      qRows: 2,
      qChildren: <Widget>[
        CuteButton(
          key: Key('q_${widget.question}'),
          child: Center(child: Text(widget.question)),
        ),
        CuteButton(
          key: Key('a_${widget.answer}'),
          child: Center(child: Text(widget.answer)),
        )
      ],
      cols: 2,
      rows: 1,
      children: <Widget>[
        CuteButton(
          key: Key('Right'),
          child: Center(
              child: Icon(
            Icons.check,
            color: Colors.green,
          )),
          onPressed: () {
            if (widget.right_or_wrong) {
              widget.onGameUpdate(score: 2, max: 2, gameOver: true, star: true);
            } else {
              widget.onGameUpdate(
                  score: -1, max: 2, gameOver: true, star: false);
              return Reaction.failure;
            }
          },
        ),
        CuteButton(
          key: Key('Wrong'),
          child: Center(
              child: Icon(
            Icons.close,
            color: Colors.red,
          )),
          onPressed: () {
            if (!widget.right_or_wrong) {
              widget.onGameUpdate(score: 2, max: 2, gameOver: true, star: true);
              return Reaction.success;
            } else {
              widget.onGameUpdate(
                  score: -1, max: 2, gameOver: true, star: false);
              return Reaction.failure;
            }
          },
        )
      ],
    );
  }
}
