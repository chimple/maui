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
  final BuiltList<int> choices;
  final OnGameOver onGameOver;
  const NumberBalanceGame(
      {Key key, this.question, this.choices, this.onGameOver})
      : super(key: key);
  @override
  _NumberBalanceGameState createState() => new _NumberBalanceGameState();
}

class _NumberBalanceGameState extends State<NumberBalanceGame> {
  List<_ChoiceDetail> choiceDetails;
  int _operand1;
  int _operand2;
  int _answer;
  var _leftAlignment = Alignment.center;
  var _rightAlignment = Alignment.center;
  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c, index: i++))
        .toList(growable: false);
  }

  _calculateAnswer() {
    if (_operand1 != null && _operand2 != null) {
      _answer = _operand1 + _operand2;
      if (_answer == widget.question) {
        _leftAlignment = Alignment.center;
        _rightAlignment = Alignment.center;
      } else if (widget.question < _answer) {
        setState(() {
          _leftAlignment = Alignment.topCenter;
          _rightAlignment = Alignment.bottomCenter;
        });
      } else {
        setState(() {
          _leftAlignment = Alignment.bottomCenter;
          _rightAlignment = Alignment.topCenter;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _calculateAnswer();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.brown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  alignment: _leftAlignment,
                  child: Container(
                    height: 100.0,
                    width: 250.0,
                    decoration: new BoxDecoration(
                      color: Colors.orange[200],
                      border:
                          new Border.all(color: Colors.redAccent, width: 5.0),
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
                                color: Colors.white,
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "=",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 100.0,
                      fontWeight: FontWeight.bold),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  alignment: _rightAlignment,
                  child: Container(
                    height: 100.0,
                    width: 250.0,
                    decoration: new BoxDecoration(
                      color: Colors.orange[200],
                      border:
                          new Border.all(color: Colors.redAccent, width: 5.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        DragTarget<String>(
                          key: Key('box1'),
                          builder: (context, candidateData, rejectedData) =>
                              Container(
                                height: 70.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                                child: Center(
                                  child: Text(
                                    _operand1 == null ? "?" : "$_operand1",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          onWillAccept: (data) => true,
                          onAccept: (data) => setState(() {
                                _operand1 = int.parse(data);
                              }),
                        ),
                        Text(
                          "+",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold),
                        ),
                        DragTarget<String>(
                            key: Key('box2'),
                            builder: (context, candidateData, rejectedData) =>
                                Container(
                                  height: 70.0,
                                  width: 70.0,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  child: Center(
                                    child: Text(
                                      _operand2 == null ? "?" : "$_operand2",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            onWillAccept: (data) => true,
                            onAccept: (data) {
                              setState(() {
                                _operand2 = int.parse(data);
                              });

                              // WidgetsBinding.instance
                              //     .addPostFrameCallback((_) => setState(
                              //           () => choiceDetails[1].type = _Type._answer,
                              //         ));
                              // widget.onGameOver(1);
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 4,
          child: Container(
            color: Colors.tealAccent,
            child: SizedBox(
              height: 100.0,
              width: 500.0,
              child: BentoBox(
                dragConfig: DragConfig.draggableMultiPack,
                rows: 1,
                cols: choiceDetails.length,
                children: choiceDetails.map((c) {
                  return c.type == _Type.choice
                      ? CuteButton(
                          key: Key(c.number.toString()),
                          child: Text(
                            "${c.number}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50.0,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(
                          key: Key(c.number.toString()),
                        );
                }).toList(growable: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
