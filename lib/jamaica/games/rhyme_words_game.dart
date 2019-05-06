import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
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
  final OnGameUpdate onGameUpdate;

  const RhymeWordsGame(
      {Key key, this.questions, this.answers, this.onGameUpdate})
      : super(key: key);

  @override
  _RhymeWordsGameState createState() => _RhymeWordsGameState();
}

class _RhymeWordsGameState extends State<RhymeWordsGame> {
  List<_ChoiceDetail> choiceDetails;
  var _score = 0;
  int complete = 0;
  int _count = 0;
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
                      return true;
                    },
                    onAccept: (data) {
                      setState(() {
                        int currentIndex = choiceDetails
                            .indexWhere((ch) => ch.choice == c.choice);
                        int dataIndex =
                            widget.answers.indexWhere((a) => a == data);
                        if (dataIndex == currentIndex) {
                          _score += 2;
                          if (--complete == 0)
                            widget.onGameUpdate(
                                score: _score,
                                max: 8,
                                gameOver: true,
                                star: true);
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
                                        () => setState(() =>
                                            widget.onGameUpdate(
                                                score: _score,
                                                max: 8,
                                                gameOver: false,
                                                star: false)));
                                  } else {
                                    _score--;
                                    widget.onGameUpdate(
                                        score: _score,
                                        max: 8,
                                        gameOver: false,
                                        star: false);
                                    _endList = [];
                                  }
                                }),
                          );
                        } else {
                          _score--;
                          _count++;
                          if (_count >= 2) {
                            // print('You lose');
                            widget.onGameUpdate(
                                score: _score,
                                max: 8,
                                gameOver: true,
                                star: false);
                          } else {
                            widget.onGameUpdate(
                                score: _score,
                                max: 8,
                                gameOver: false,
                                star: false);
                          }
                        }
                        // print('score iz : $_score');
                      });
                    }),
              ))
          .toList(growable: false),
    );
  }
}
