import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
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

class OrderItGame extends StatefulWidget {
  final List<String> answers;
  final OnGameUpdate onGameUpdate;

  const OrderItGame({Key key, this.onGameUpdate, this.answers})
      : super(key: key);

  @override
  _OrderItGameState createState() => _OrderItGameState();
}

class _OrderItGameState extends State<OrderItGame> {
  List<_ChoiceDetail> choiceDetails;
  var _score = 0;
  int complete;
  int _count = 0;
  int maxScore;
  List<String> _endList = [];

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, index: i++))
        .toList()
          ..shuffle();
    complete = choiceDetails.length;
    maxScore = 2 * widget.answers.length;
  }

  @override
  Widget build(BuildContext context) {
    return BentoBox(
      calculateLayout: BentoBox.calculateVerticalLayout,
      axis: Axis.vertical,
      dragConfig: DragConfig.draggableBounceBack,
      cols: 1,
      rows: choiceDetails.length,
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
                      _count = _count + 1;
                      // score = score + 2;
                      // if (score > maxScore) {
                      //   setState(() => widget.onGameUpdate(
                      //       score: score - 10,
                      //       max: maxScore,
                      //       gameOver: true,
                      //       star: false));
                      // }
                      print("this my score$_score");
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
                            if (_count <= 10) {
                              for (int i = 0; i < choiceDetails.length; i++) {
                                if (choiceDetails[i].choice ==
                                    widget.answers[i]) {
                                  scoreBasedOnPosition =
                                      scoreBasedOnPosition + 2;
                                }
                              }
                              setState(() => widget.onGameUpdate(
                                  score: _score,
                                  max: maxScore,
                                  gameOver: true,
                                  star: false));
                            } else {
                              for (int i = 0; i < choiceDetails.length; i++) {
                                if (choiceDetails[i].choice ==
                                    widget.answers[i]) {
                                  scoreBasedOnPosition =
                                      scoreBasedOnPosition + 2;
                                }
                              }
                            }

                            _score = scoreBasedOnPosition;
                            setState(() => widget.onGameUpdate(
                                score: _score,
                                max: maxScore,
                                gameOver: false,
                                star: false));
                            print("this is my new game $_endList");

                            if (_endList.join() == widget.answers.join()) {
                              _score = 2 * widget.answers.length - _count;
                              print("success....");
                              setState(() => widget.onGameUpdate(
                                  score: _score,
                                  max: maxScore,
                                  gameOver: true,
                                  star: true));
                            } else {
                              _score--;
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
