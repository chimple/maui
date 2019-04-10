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
  final OnGameOver onGameOver;

  const SequenceAlphabetGame({Key key, this.answers, this.onGameOver})
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
                      score++;
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
                            print("this is my new game $_endList");

                            if (_endList.join() == widget.answers.join()) {
                              print("success....");
                              Future.delayed(
                                  const Duration(milliseconds: 1000),
                                  () =>
                                      setState(() => widget.onGameOver(score)));
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
