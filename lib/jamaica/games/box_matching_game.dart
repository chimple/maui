import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  String choice;
  Reaction reaction;
  int index;
  bool appear;

  _ChoiceDetail({this.choice, this.appear = true, this.index});
  @override
  String toString() =>
      '_ChoiceDetail(choice: $choice, appear: $appear,index: $index, )';
}

class BoxMatchingGame extends StatefulWidget {
  final BuiltList<String> choices;
  final BuiltList<String> answers;
  final OnGameUpdate onGameUpdate;

  const BoxMatchingGame({
    Key key,
    this.choices,
    this.answers,
    this.onGameUpdate,
  }) : super(key: key);

  @override
  _BoxMatchingGameState createState() => _BoxMatchingGameState();
}

class _BoxMatchingGameState extends State<BoxMatchingGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;
  List<List<String>> addToBox = [];
  int score = 0;
  int complete, maxScore, wrongAttempt = 0;
  @override
  void initState() {
    super.initState();
    int i = 0;
    int j = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(choice: c, index: i++))
        .toList(growable: false)
          ..shuffle();
    complete = choiceDetails.length;
    maxScore = choiceDetails.length * 2;
    answerDetails = widget.answers
        .map((a) => _ChoiceDetail(choice: a, appear: false, index: j++))
        .toList(growable: false);
    for (int k = 0; k < answerDetails.length; k++) {
      addToBox.add([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    int k = 0;
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: BentoBox(
              rows: 1,
              cols: answerDetails.length,
              children: answerDetails
                  .map(
                    (a) => CuteButton(
                        key: Key(a.choice),
                        child: DragTarget<String>(
                          builder: (context, candidateData, rejectedData) =>
                              LayoutBuilder(builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Container(
                                    height: constraints.maxHeight,
                                    width: constraints.maxWidth,
                                    decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      border: new Border.all(
                                          color: Colors.black, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: a.appear
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: addToBox[a.index]
                                                .map((f) => Container(
                                                      padding:
                                                          EdgeInsets.all(3.0),
                                                      height: constraints
                                                              .maxHeight *
                                                          .3,
                                                      width:
                                                          constraints.maxWidth *
                                                              .5,
                                                      child: Center(
                                                          child:
                                                              Text(a.choice)),
                                                    ))
                                                .toList(growable: false))
                                        : Container());
                              }),
                          onWillAccept: (data) => data[0] == a.choice,
                          onAccept: (data) => setState(() {
                                if (data[0] == a.choice) {
                                  int index = int.parse(data.substring(1));
                                  print("${data.substring(1)}......${choiceDetails[index]}");
                                  addToBox[a.index].add(a.choice);
                                  a.appear = true;
                                  choiceDetails[index].appear = false;
                                  score = score + 2;
                                  if (--complete == 0)
                                    widget.onGameUpdate(
                                        score: score,
                                        max: choiceDetails.length,
                                        gameOver: true,
                                        star: true);
                                } else if (wrongAttempt < 2) {
                                  score = score - 1;
                                  wrongAttempt = wrongAttempt + 1;
                                  widget.onGameUpdate(
                                      score: score,
                                      max: maxScore,
                                      gameOver: false,
                                      star: false);
                                } else {
                                  widget.onGameUpdate(
                                      score: score,
                                      max: 2,
                                      gameOver: true,
                                      star: false);
                                }
                              }),
                        ) as Widget),
                  )
                  .toList()),
        ),
        Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.answers
                  .map((t) => Text(
                        t,
                        style: TextStyle(fontSize: 46.0),
                        key: Key(t),
                      ))
                  .toList(growable: false),
            )),
        Flexible(
          flex: 2,
          child: BentoBox(
            calculateLayout: BentoBox.calculateOrderlyRandomizedLayout,
            dragConfig: DragConfig.draggableBounceBack,
            rows: 2,
            cols: 5,
            children: choiceDetails
                .map((c) => c.appear
                    ? CuteButton(
                        key: Key("${(c.choice + (k++).toString())}"),
                        child: LayoutBuilder(builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return Container(
                            height: constraints.maxHeight * .6,
                            width: constraints.maxWidth * .8,
                            child: Center(child: Text(c.choice)),
                          );
                        }),
                      )
                    : Container(
                        key: Key("${(k++).toString()}"),
                      ))
                .toList(growable: false),
          ),
        )
      ],
    );
  }
}
