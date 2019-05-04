import 'package:flutter/material.dart';
import 'package:maui/data/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

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

    print("object $choice");
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
                        onWillAccept: (data) => data == a.number.toString(),
                        onAccept: (data) {
                          setState(() => a.solved = true);
                          widget.onGameUpdate(
                              score: 1, max: 1, gameOver: true, star: true);
                        },
                      ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
