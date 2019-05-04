import 'package:built_collection/built_collection.dart';
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

class SequenceAlphabetGame extends StatefulWidget {
  final BuiltList<String> answers;
  final OnGameUpdate onGameUpdate;

  const SequenceAlphabetGame({Key key, this.answers, this.onGameUpdate})
      : super(key: key);

  @override
  _SequenceAlphabetGameState createState() => _SequenceAlphabetGameState();
}

class _SequenceAlphabetGameState extends State<SequenceAlphabetGame> {
  List<_ChoiceDetail> choiceDetails;
  var score = 0;
  int complete;
  int count = 0;
  List<String> _endList = [];
  int maxScore;
  int attempt = 0;
  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, index: i++))
        .toList()
          ..shuffle();
    //       i=0;
    // widget.answers.forEach((f) {
    //   if (f != choiceDetails[i++].choice) count++;
    // });
    // i=0;
    //  _endList.addAll(choiceDetails[i++].choice);
    print("this is my count $_endList");
    maxScore = 2 * widget.answers.length;
    // for (int i = 0; i < choiceDetails.length; i++) {
    //   if (choiceDetails[i].choice != widget.answers[i]) {
    //     maxScore = maxScore + 2;
    //   }
    // }

    complete = count;
    print("this is my object ${widget.answers}");
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      axis: Axis.horizontal,
      dragConfig: DragConfig.draggableBounceBack,
      cols: choiceDetails.length,
      rows: 1,
      children: choiceDetails
          .map((c) => CuteButton(
                key: Key(c.index.toString()),
                child: DragTarget<String>(
                  builder: (context, candidateData, rejectedData) =>
                      Center(child: Text(c.choice)),
                  onWillAccept: (data) {
                    return true;
                  },
                  onAccept: (data) {
                    setState(() {
                      attempt = attempt + 1;
                      print("attempt is......$attempt");
                      // score = score + 2;
                      // if (score > maxScore) {
                      //   setState(() => widget.onGameUpdate(
                      //       score: score - 10,
                      //       max: maxScore,
                      //       gameOver: true,
                      //       star: false));
                      // }
                      print("this my score$score");
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          setState(() {
                            print("data is...");
                            int currentIndex = choiceDetails.indexWhere((ch) =>
                                ch.index.toString() == c.index.toString());
                            int droppedIndex = choiceDetails.indexWhere(
                                (ch) => ch.index.toString() == data);
                            final droppedChoice = choiceDetails[droppedIndex];
                            choiceDetails.removeAt(droppedIndex);
                            choiceDetails.insert(currentIndex, droppedChoice);
                            choiceDetails.forEach((d) {
                              print(".......${d.choice}");
                              _endList.add(d.choice);
                            });
                            int scoreBasedOnPosition = 0;
                            if (attempt <= 10) {
                              for (int i = 0; i < widget.answers.length; i++) {
                                if (choiceDetails[i].choice ==
                                    widget.answers[i]) {
                                  scoreBasedOnPosition =
                                      scoreBasedOnPosition + 2;
                                }
                              }
                              setState(() => widget.onGameUpdate(
                                  score: score,
                                  max: maxScore,
                                  gameOver: false,
                                  star: false));
                            } else {
                              for (int i = 0; i < widget.answers.length; i++) {
                                if (choiceDetails[i].choice ==
                                    widget.answers[i]) {
                                  scoreBasedOnPosition =
                                      scoreBasedOnPosition + 2;
                                }
                              }
                              setState(() => widget.onGameUpdate(
                                  score: score,
                                  max: maxScore,
                                  gameOver: false,
                                  star: true));
                            }

                            // score = scoreBasedOnPosition;
                            // setState(() => widget.onGameUpdate(
                            //     score: score,
                            //     max: maxScore,
                            //     gameOver: false,
                            //     star: false));
                            print("this is my new game $_endList");

                            if (_endList.join() == widget.answers.join()) {
                              score = 2 * widget.answers.length - attempt;
                              print("success....");
                              new Future.delayed(
                                  const Duration(milliseconds: 500), () {
                                setState(() => widget.onGameUpdate(
                                    score: score,
                                    max: maxScore,
                                    gameOver: true,
                                    star: true));
                              });
                            } else {
                              score--;
                              _endList = [];
                            }
                          }));
                    });
                  },
                ),
              ))
          .toList(growable: false),
    );
  }
}
