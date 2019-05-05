import 'dart:async';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  _Type type;
  bool solved;

  _ChoiceDetail({
    this.choice,
    this.type = _Type.choice,
    this.reaction = Reaction.success,
    this.solved = false,
  });
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, type: $type, solved: $solved, reaction: $reaction)';
}

enum _Type { choice, question }

class JumbledWordsGame extends StatefulWidget {
  final String answer;
  final BuiltList<String> choices;
  final OnGameUpdate onGameUpdate;

  const JumbledWordsGame(
      {Key key, this.answer, this.choices, this.onGameUpdate})
      : super(key: key);

  @override
  _JumbledWordsGameState createState() => _JumbledWordsGameState();
}

class _JumbledWordsGameState extends State<JumbledWordsGame> {
  List<_ChoiceDetail> choiceDetails;
  bool thisSolved = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> frontChildren;
    if (thisSolved) {
      frontChildren = choiceDetails
          .where((c) => c.solved == true)
          .map((c) => CuteButton(
                key: Key(c.choice),
                child: Center(child: Text(c.choice)),
              ) as Widget)
          .toList();
      frontChildren.add(Center(key: Key('answer'), child: Text(widget.answer)));
    }

    return BentoBox(
      dragConfig: DragConfig.draggableBounceBack,
      frontChildren: frontChildren,
      qRows: 1,
      qCols: 1,
      qChildren: thisSolved
          ? <Widget>[Container()]
          : <Widget>[
              DragTarget<String>(
                key: Key('answer'),
                builder: (context, candidateData, rejectedData) =>
                    Center(child: Text(widget.answer)),
                onWillAccept: (data) => true,
                onAccept: (data) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => setState(() {
                            choiceDetails
                                .firstWhere((c) => c.choice == data)
                                .solved = true;
                            thisSolved = true;
                            score = score + 2;
                            Future.delayed(
                                const Duration(milliseconds: 700),
                                () => setState(() {
                                      widget.onGameUpdate(
                                          score: score,
                                          max: 2,
                                          gameOver: true,
                                          star: true);
                                      print("object");
                                    }));
                          }));
                },
              )
            ],
      rows: 4,
      cols: choiceDetails.length,
      children: choiceDetails
          .map((c) => c.solved
              ? Container()
              : CuteButton(
                  key: Key(c.choice),
                  child: Center(child: Text(c.choice)),
                ))
          .toList(growable: false),
      calculateLayout: calculateCustomizedLayout,
    );
  }

  static calculateCustomizedLayout(
      {int cols,
      int rows,
      List<Widget> children,
      int qCols,
      int qRows,
      List<Widget> qChildren,
      Map<Key, BentoChildDetail> childrenMap,
      Size size}) {
    final allRows = rows + qRows;
    final allCols = max(cols, qCols);
    final childWidth = size.width / allCols;
    final childHeight = size.height / allRows;
    final centerWidth = size.width / (qRows * 3);
    final centerHeight = size.height / (qRows * 3);
    print(
        "this my new width ${size.width} and new height ${size.height} and child width is $childWidth and $childHeight and rows $allRows colmun $allCols");
    int i = 0;

    Offset center = Offset(centerWidth, centerHeight);
    i = 0;
    (qChildren ?? []).forEach((c) => childrenMap[c.key] = BentoChildDetail(
          child: c,
          offset: center,
        ));
    print("the circle Size $center and rows $qRows");
    double j = 0;
    children.forEach((f) {
      double k = (2 * pi / children.length);
      print("this is my children length ${children.length}");
      childrenMap[f.key] = BentoChildDetail(
        child: f,
        offset: Offset((center.dx + childWidth * (cos(j))),
            (center.dy + childHeight * (sin(j)))),
      );
      j = j + k;
    });
  }
}
