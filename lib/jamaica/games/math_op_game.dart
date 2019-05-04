import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;
  bool solved;
  int index;

  _ChoiceDetail(
      {this.number,
      this.solved = false,
      this.reaction = Reaction.success,
      this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, solved: $solved, index: $index, reaction: $reaction)';
}

class MathOpGame extends StatefulWidget {
  final int first;
  final int second;
  final String op;
  final int answer;
  final OnGameUpdate onGameUpdate;

  const MathOpGame(
      {Key key,
      this.first,
      this.second,
      this.op,
      this.answer,
      this.onGameUpdate})
      : super(key: key);

  @override
  _MathOpGameState createState() => _MathOpGameState();
}

class _MathOpGameState extends State<MathOpGame> {
  List<_ChoiceDetail> answers = [];
  var score = 0;
  int complete;
  int maxScore;
  int wrongAttempt = 0;
  @override
  void initState() {
    super.initState();
    int value = widget.answer;
    int i = 0;
    maxScore = widget.answer;
    maxScore = maxScore.toString().length;
    while (value > 0) {
      answers.insert(
          0,
          _ChoiceDetail(
            number: value % 10,
            index: i++,
          ));
      value ~/= 10;
    }
    complete = value;
  }

  @override
  Widget build(BuildContext context) {
    print(answers);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: BentoBox(
            rows: 1,
            cols: 3,
            children: <Widget>[
              CuteButton(
                key: Key('first'),
                child: DotNumber(
                  number: widget.first,
                  showNumber: true,
                ),
              ),
              Center(
                child: Text(
                  widget.op,
                  key: Key('first'),
                ),
              ),
              CuteButton(
                key: Key('second'),
                child: DotNumber(
                  number: widget.second,
                  showNumber: true,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: BentoBox(
            dragConfig: DragConfig.draggableMultiPack,
            rows: 2,
            cols: 5,
            children: List<Widget>.generate(
              10,
              (i) => CuteButton(
                    key: Key((i + 1).toString()),
                    child: Center(child: Text((i + 1).toString())),
                  ),
            ),
            qRows: 1,
            qCols: answers.length,
            qChildren: answers
                .map((a) => a.solved
                    ? CuteButton(
                        key: Key('answer_${a.index}'),
                        child: Center(child: Text(a.number.toString())),
                      )
                    : DragTarget<String>(
                        key: Key('answer_${a.index}'),
                        builder: (context, candidateData, rejectedData) =>
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                            ),
                        // onWillAccept: (data) {
                        //   print(data);
                        //   return data == a.number.toString();
                        // },
                        onAccept: (data) {
                          setState(() {
                            if (data == a.number.toString()) {
                              score = score + 2;
                              print("this my score$score");
                              if (--complete == 0) a.solved = true;
                              widget.onGameUpdate(
                                  score: score,
                                  max: maxScore,
                                  gameOver: true,
                                  star: true);
                            } else {
                              wrongAttempt = wrongAttempt + 1;
                              if (wrongAttempt <= 2) {
                                widget.onGameUpdate(
                                    score: score - 1,
                                    max: maxScore,
                                    gameOver: false,
                                    star: false);
                              } else {
                                widget.onGameUpdate(
                                    score: score - 1,
                                    max: maxScore,
                                    gameOver: true,
                                    star: false);
                              }
                              print("this my decrement score $score");
                            }
                          });
                        },
                      ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
