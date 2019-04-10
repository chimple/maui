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

class RhymeWordsGame extends StatefulWidget {
  final BuiltList<String> questions;
  final BuiltList<String> answers;
  final OnGameOver onGameOver;

  const RhymeWordsGame({Key key, this.questions, this.answers, this.onGameOver})
      : super(key: key);

  @override
  _RhymeWordsGameState createState() => _RhymeWordsGameState();
}

class _RhymeWordsGameState extends State<RhymeWordsGame> {
  List<_ChoiceDetail> choiceDetails;
  var score = 0;
  int complete = 0;
  int count = 0;
  List<String> _endList = [];

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, index: i++))
        .toList(growable: false)
          ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return BentoBox(
      axis: Axis.vertical,
      calculateLayout: BentoBox.calculateHorizontalLayout,
      dragConfig: DragConfig.draggableBounceBack,
      qCols: 2,
      qRows: widget.questions.length,
      qChildren: widget.questions
          .map((q) => CuteButton(
                key: Key(q),
                child: Center(child: Text(q)),
              ) as Widget)
          .toList()
            ..addAll(widget.questions.map((q) => Image.asset(
                  'assets/accessories/join.png',
                  key: UniqueKey(),
                ) as Widget)),
      cols: 1,
      rows: choiceDetails.length,
      children: choiceDetails
          .map((c) => CuteButton(
                key: Key(c.choice),
                child: DragTarget<String>(
                    builder: (context, candidateData, rejectedData) =>
                        Center(child: Text(c.choice)),
                    onWillAccept: (data) {
                      int currentIndex = choiceDetails
                          .indexWhere((ch) => ch.choice == c.choice);
                      int dataIndex =
                          widget.answers.indexWhere((a) => a == data);
                      return dataIndex == currentIndex;
                    },
                    onAccept: (data) {
                      setState(() {
                        int currentIndex = choiceDetails
                            .indexWhere((ch) => ch.choice == c.choice);
                        int dataIndex =
                            widget.answers.indexWhere((a) => a == data);
                        if (dataIndex == currentIndex) {
                          score++;
                          if (--complete == 0) widget.onGameOver(score);
                          print("this is complete $complete");
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) => setState(() {
                                  print(data);
                                  int currentIndex = choiceDetails.indexWhere(
                                      (ch) => ch.choice == c.choice);
                                  int dataIndex = choiceDetails
                                      .indexWhere((a) => a.choice == data);
                                  print('$currentIndex $dataIndex');
                                  final current = choiceDetails[currentIndex];
                                  choiceDetails[currentIndex] =
                                      choiceDetails[dataIndex];
                                  choiceDetails[dataIndex] = current;
                                  choiceDetails.forEach((d) {
                                    print(".......${d.choice}");
                                    _endList.add(d.choice);
                                  });
                                  print("this is my new game $_endList");

                                  if (_endList.join() ==
                                      widget.answers.join()) {
                                    print("success....");
                                    Future.delayed(
                                        const Duration(milliseconds: 1000),
                                        () => setState(
                                            () => widget.onGameOver(score)));
                                  } else {
                                    score--;
                                    _endList = [];
                                  }
                                }),
                          );
                        } else
                          score--;
                      });
                    }),
              ))
          .toList(growable: false),
    );
  }
}
