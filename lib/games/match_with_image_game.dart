import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/models/display_item.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';
import 'package:maui/widgets/drop_box.dart';

class _ChoiceDetail {
  DisplayItem choice;
  Reaction reaction;
  bool appear;

  _ChoiceDetail(
      {this.choice, this.appear = true, this.reaction = Reaction.success});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear, reaction: $reaction)';
}

class MatchWithImageGame extends StatefulWidget {
  final BuiltList<DisplayItem> answers;
  final BuiltList<DisplayItem> choices;
  final OnGameUpdate onGameUpdate;

  const MatchWithImageGame(
      {Key key, this.answers, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _MatchWithImageGameState createState() => _MatchWithImageGameState();
}

class _MatchWithImageGameState extends State<MatchWithImageGame> {
  List<_ChoiceDetail> answerDetails;
  List<_ChoiceDetail> choiceDetails;
  var score = 0, tries = 0;
  int complete = 0;
  final int wrongAttempts = 2;

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
                  key: Key(c.choice.item),
                  displayItem: c.choice,
                )
              : Container())
          .toList(growable: false),
      qRows: 2,
      qCols: answerDetails.length,
      qChildren: widget.answers
          .map((a) => CuteButton(
                key: Key("q${a.item}"),
                displayItem: a,
              ) as Widget)
          .toList()
            ..addAll(answerDetails.map((a) => a.appear
                ? CuteButton(
                    key: Key((i++).toString()),
                    child: Center(child: Text(a.choice.item)),
                  )
                : DropBox(
                    key: Key((i++).toString()),
                    // onWillAccept: (data) => data == a.choice,
                    onAccept: (data) => setState(() {
                          if (data == a.choice) {
                            score += 2;
                            tries = 0;
                            a.appear = true;
                            choiceDetails
                                .firstWhere((c) => c.choice == a.choice)
                                .appear = false;
                            if (--complete == 0)
                              widget.onGameUpdate(
                                  score: score,
                                  max: choiceDetails.length * 2,
                                  gameOver: true,
                                  star: true);
                          } else {
                            score--;
                            if (++tries == wrongAttempts)
                              widget.onGameUpdate(
                                  score: score,
                                  max: choiceDetails.length * 2,
                                  gameOver: true,
                                  star: false);
                          }
                        }),
                  ))),
      dragConfig: DragConfig.draggableBounceBack,
    );
  }
}
