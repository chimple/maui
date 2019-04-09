import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/drop_box.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  bool appear;

  _ChoiceDetail(
      {this.choice, this.appear = true, this.reaction = Reaction.success});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear, reaction: $reaction)';
}

class MatchWithImageGame extends StatefulWidget {
  final BuiltList<String> images;
  final BuiltList<String> answers;
  final BuiltList<String> choices;
  final OnGameOver onGameOver;

  const MatchWithImageGame(
      {Key key, this.images, this.answers, this.choices, this.onGameOver})
      : super(key: key);

  @override
  _MatchWithImageGameState createState() => _MatchWithImageGameState();
}

class _MatchWithImageGameState extends State<MatchWithImageGame> {
  List<_ChoiceDetail> answerDetails;
  List<_ChoiceDetail> choiceDetails;
  var score = 0;
  int complete;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c))
        .toList(growable: false);
    complete = choiceDetails.length;
    answerDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, appear: false))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return BentoBox(
      rows: 1,
      cols: choiceDetails.length,
      children: choiceDetails
          .map((c) => c.appear
              ? CuteButton(
                  key: Key(c.choice),
                  child: Center(child: Text(c.choice)),
                )
              : Container())
          .toList(growable: false),
      qRows: 2,
      qCols: answerDetails.length,
      qChildren: widget.images
          .map((img) => Image.asset(
                img,
                key: Key(img),
              ) as Widget)
          .toList()
            ..addAll(answerDetails.map((a) => a.appear
                ? CuteButton(
                    key: Key((i++).toString()),
                    child: Center(child: Text(a.choice)),
                  )
                : DropBox(
                    key: Key((i++).toString()),
                    // onWillAccept: (data) => data == a.choice,
                    onAccept: (data) => setState(() {
                          if (data == a.choice) {
                            score++;
                            print("this is my data ${data.length}");
                            print("this is my score in match $score");
                            a.appear = true;
                            choiceDetails
                                .firstWhere((c) => c.choice == a.choice)
                                .appear = false;
                            if (--complete == 0) widget.onGameOver(score);
                          } else
                            score--;
                        }),
                  ))),
      dragConfig: DragConfig.draggableBounceBack,
    );
  }
}
