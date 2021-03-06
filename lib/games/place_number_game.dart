import 'package:flutter/material.dart';
import 'package:maui/util/game_utils.dart';
import 'package:maui/widgets/bento_box.dart';
import 'package:maui/widgets/cute_button.dart';

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

class PlaceTheNumber extends StatefulWidget {
  final int answer;
  final OnGameUpdate onGameUpdate;

  const PlaceTheNumber({Key key, this.answer, this.onGameUpdate})
      : super(key: key);

  @override
  _PlaceTheNumberState createState() => _PlaceTheNumberState();
}

class _PlaceTheNumberState extends State<PlaceTheNumber> {
  List<_ChoiceDetail> answers = [];
  List<int> choice = [];
  int score = 0;
  int attempt = 0;
  @override
  void initState() {
    super.initState();
    int value = widget.answer;
    int j = 1;
    choice = new List.generate(100, (_) => j++);
    int i = 0;
    answers.insert(
        0,
        _ChoiceDetail(
          number: value,
          index: i++,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Place  The  number ${widget.answer} in the box",
            ),
          ]),
        ),
        Flexible(
          flex: 9,
          child: BentoBox(
            grid: true,
            dragConfig: DragConfig.draggableMultiPack,
            rows: 10,
            cols: 10,
            children: choice
                .map((c) => CuteButton(
                      key: Key(c.toString()),
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            "$c",
                          )),
                    ))
                .toList(growable: false),
            qRows: 2,
            qCols: 2,
            qChildren: answers
                .map((a) => a.solved
                    ? Container(
                        color: Colors.green,
                        key: Key('answer_${a.index}'),
                        child: Center(child: Text(a.number.toString())),
                      )
                    : DragTarget<String>(
                        key: Key('answer_${a.index}'),
                        builder: (context, candidateData, rejectedData) =>
                            Container(
                              // height: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0))),
                            ),
                        onWillAccept: (data) => true,
                        onAccept: (data) {
                          setState(() {
                            if (data == a.number.toString()) {
                              score = score + 2;
                              print("this is score $score");
                              a.solved = true;
                              Future.delayed(
                                  const Duration(milliseconds: 1000),
                                  () => setState(() {
                                        print("this is a object");
                                        widget.onGameUpdate(
                                            score: score,
                                            max: 2,
                                            gameOver: true,
                                            star: true);
                                      }));
                            } else {
                              print("this is score else R$score");
                              score = score - 1;
                              attempt++;
                              if (attempt == 2) {
                                widget.onGameUpdate(
                                    score: score,
                                    max: 2,
                                    gameOver: true,
                                    star: false);
                              }
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
