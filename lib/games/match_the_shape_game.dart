import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/animated_scale.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  String type;
  Reaction reaction;
  _Escape escape;
  _ChoiceDetail(
      {this.choice,
      this.type,
      this.reaction = Reaction.success,
      this.escape = _Escape.no});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, type: $type, reaction: $reaction, escape: $escape)';
}

enum _Escape { no, escaping, escaped }

class MatchTheShapeGame extends StatefulWidget {
  final BuiltList<String> first;
  final BuiltList<String> second;
  final OnGameUpdate onGameUpdate;

  const MatchTheShapeGame({Key key, this.first, this.second, this.onGameUpdate})
      : super(key: key);

  @override
  _MatchTheShapeGameState createState() => _MatchTheShapeGameState();
}

class _MatchTheShapeGameState extends State<MatchTheShapeGame> {
  List<_ChoiceDetail> choiceDetails;
  var score = 0;
  int complete;
  int count = 0;
  int maxScore;

  @override
  void initState() {
    super.initState();
    choiceDetails = widget.first
        .map((c) => _ChoiceDetail(choice: c, type: 'first'))
        .toList();
    complete = choiceDetails.length;
    choiceDetails.addAll(
        widget.second.map((c) => _ChoiceDetail(choice: c, type: 'second')));
    maxScore = widget.first.length * 2;
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      calculateLayout: BentoBox.calculateRandomizedLayout,
      dragConfig: DragConfig.draggableNoBounceBack,
      rows: 3,
      cols: widget.first.length,
      children: choiceDetails
          .map((c) => c.escape == _Escape.no
              ? CuteButton(
                  onPressed: () => Reaction.success,
                  key: Key('${c.choice}_${c.type}'),
                  child: DragTarget<String>(
                    builder: (context, candidateData, rejectedData) => Center(
                          child: Text(c.choice),
                        ),
                    onAccept: (data) => setState(() {
                          if (data.split('_').first == c.choice) {
                            score += 2;
                            print("this is my data ${data.length}");
                            print("this is my score in match $score");
                            if (--complete == 0)
                              widget.onGameUpdate(
                                  score: score,
                                  max: maxScore,
                                  gameOver: true,
                                  star: true);

                            choiceDetails
                                .where((choice) => c.choice == choice.choice)
                                .forEach((choice) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) => setState(() {
                                        choice.escape = _Escape.escaping;

                                        print(
                                            "this is my length in match ${data.length}");
                                      }));
                              Future.delayed(
                                  Duration(milliseconds: 1000),
                                  () => setState(
                                      () => choice.escape = _Escape.escaped));
                            });
                          } else {
                            score--;
                            count++;
                            if (count > (widget.first.length ~/ 2)) {
                              // game lose
                              widget.onGameUpdate(
                                  score: score,
                                  max: maxScore,
                                  gameOver: true,
                                  star: false);
                            } else {
                              widget.onGameUpdate(
                                  score: score,
                                  max: maxScore,
                                  gameOver: false,
                                  star: false);
                            }
                          }
                        }),
                  ),
                )
              : Container())
          .toList(growable: false),
      frontChildren: choiceDetails
          .where((c) => c.escape == _Escape.escaping)
          .map((c) => CuteButton(
                key: Key('${c.choice}_${c.type}'),
                child: Center(
                  child: Text(c.choice),
                ),
                onPressed: () => Reaction.success,
              ))
          .toList(growable: false),
    );
  }
}
