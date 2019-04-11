import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';

class _ChoiceDetail {
  int number;
  Reaction reaction;
  _Type type;
  int index;

  _ChoiceDetail({
    this.number,
    this.type = _Type.choice,
    this.reaction = Reaction.success,
    this.index,
  });
  @override
  String toString() =>
      '_ChoiceDetail(choice: $number, type: $type, index: $index, reaction: $reaction)';
}

enum _Type { choice, question, answer }

class NumberBalanceGame extends StatefulWidget {
  final int question;
  final int answerPosition;
  final BuiltList<int> choices;
  final OnGameOver onGameOver;
  const NumberBalanceGame(
      {Key key,
      this.question,
      this.answerPosition,
      this.choices,
      this.onGameOver})
      : super(key: key);
  @override
  _NumberBalanceGameState createState() => new _NumberBalanceGameState();
}

class _NumberBalanceGameState extends State<NumberBalanceGame> {
  List<_ChoiceDetail> choiceDetails;
  List<_ChoiceDetail> answerDetails;

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c, index: i++))
        .toList(growable: false);
    answerDetails = [
      _ChoiceDetail(number: widget.question, index: 99, type: _Type.question),
      choiceDetails[widget.answerPosition],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 250.0,
                decoration: new BoxDecoration(
                  color: Colors.orange[200],
                  border: new Border.all(color: Colors.redAccent, width: 5.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: BentoBox(
                  rows: 1,
                  cols: 1,
                  children: <Widget>[
                    CuteButton(
                      key: Key("unique"),
                      cuteButtonType: CuteButtonType.cuteButton,
                      child: Text(
                        "${widget.question}",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "=",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 100.0,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100.0,
                width: 250.0,
                decoration: new BoxDecoration(
                  color: Colors.orange[200],
                  border: new Border.all(color: Colors.redAccent, width: 5.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: BentoBox(
                  rows: 1,
                  cols: 3,
                  children: <Widget>[
                    CuteButton(
                        key: Key("10"),
                        cuteButtonType: CuteButtonType.cuteButton,
                        child: DragTarget(
                          builder: (context, candidateData, rejectedData) {
                            return Text(
                              "?",
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                          //  onWillAccept: (data) => data[0] == a.choice,
                          onAccept: (data) => setState(() {
                                // score++;
                                // if (--complete == 0) widget.onGameOver(score);
                                // int index = int.parse(data.substring(1));
                                // print(
                                //     "${data.substring(1)}......${choiceDetails[index]}");
                                // addToBox[a.index].add(a.choice);
                                // a.appear = true;
                                // choiceDetails[index].appear = false;
                              }),
                        )),
                    Text(
                      " +",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold),
                    ),
                    CuteButton(
                      key: Key("20"),
                      cuteButtonType: CuteButtonType.cuteButton,
                      child: Text(
                        "?",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            height: 100.0,
            width: 500.0,
            child: BentoBox(
              dragConfig: DragConfig.draggableNoBounceBack,
              rows: 1,
              cols: choiceDetails.length,
              children: choiceDetails
                  .map((c) => c.type == _Type.choice
                      ? CuteButton(
                          key: Key(c.index.toString()),
                          child: Text(
                            "${c.number}",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container())
                  .toList(growable: false),
            ),
          ),
        ),
      ],
    );
  }
}
