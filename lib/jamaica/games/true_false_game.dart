import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

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
  final OnGameOver onGameOver;

  const TrueFalseGame(
      {Key key,
      this.question,
      this.answer,
      this.right_or_wrong,
      this.onGameOver})
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
          key: Key(widget.question),
          child: Center(child: Text(widget.question)),
        ),
        CuteButton(
          key: Key(widget.answer),
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
              //  Reaction.success;
              widget.onGameOver(1);
            } else {
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
              widget.onGameOver(1);
              // return Reaction.success;
            } else {
              return Reaction.failure;
            }
          },
        )
      ],
    );
  }
}
