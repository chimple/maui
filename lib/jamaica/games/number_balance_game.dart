import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:tuple/tuple.dart';

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
enum Equation { lefthandside, righthandside }

class NumberBalanceGame extends StatefulWidget {
  final Tuple3<String, String, String> leftExpression;
  final Tuple3<String, String, String> rightExpression;
  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;
  const NumberBalanceGame(
      {Key key,
      this.leftExpression,
      this.rightExpression,
      this.choices,
      this.onGameUpdate})
      : super(key: key);
  @override
  _NumberBalanceGameState createState() => new _NumberBalanceGameState();
}

class _NumberBalanceGameState extends State<NumberBalanceGame> {
  List<_ChoiceDetail> choiceDetails;
  String _leftOperand1;
  String _leftOperand2;
  String _rightOperand1;
  String _rightOperand2;
  int _leftHandAnswer;
  int _rightHandAnswer;
  bool _correct = false;
  var _leftAlignment = Alignment.center;
  var _rightAlignment = Alignment.center;
  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c, index: i++))
        .toList(growable: false);
    _leftOperand1 = widget.leftExpression.item1;
    _leftOperand2 = widget.leftExpression.item3;
    _rightOperand1 = widget.rightExpression.item1;
    _rightOperand2 = widget.rightExpression.item3;
  }

  _solveEquation() {
    if (_leftOperand1 != '?' &&
        _leftOperand2 != '?' &&
        _leftOperand1 != null &&
        _leftOperand2 != null) {
      if (widget.leftExpression.item2 == '+') {
        _leftHandAnswer = int.parse(_leftOperand1) + int.parse(_leftOperand2);
      } else
        _leftHandAnswer = int.parse(_leftOperand1) - int.parse(_leftOperand2);
    } else if (widget.leftExpression.item2 == null) {
      _leftHandAnswer = int.parse(_leftOperand1);
    }

    if (_rightOperand1 != '?' &&
        _rightOperand2 != '?' &&
        _rightOperand1 != null &&
        _rightOperand2 != null) {
      if (widget.rightExpression.item2 == '+') {
        _rightHandAnswer =
            int.parse(_rightOperand1) + int.parse(_rightOperand2);
      } else
        _rightHandAnswer =
            int.parse(_rightOperand1) - int.parse(_rightOperand2);
    } else if (widget.rightExpression.item2 == null) {
      _rightHandAnswer = int.parse(_rightOperand1);
    }

    if (_leftHandAnswer != null && _rightHandAnswer != null) {
      if (_leftHandAnswer == _rightHandAnswer) {
        _correct = true;
        _leftAlignment = Alignment.center;
        _rightAlignment = Alignment.center;
      } else if (_leftHandAnswer > _rightHandAnswer) {
        setState(() {
          _leftAlignment = Alignment.bottomCenter;
          _rightAlignment = Alignment.topCenter;
        });
      } else {
        setState(() {
          _leftAlignment = Alignment.topCenter;
          _rightAlignment = Alignment.bottomCenter;
        });
      }
    }
  }

  Widget _equationLayout(
      String operand1, String op, String operand2, Equation equation) {
    return Container(
        height: 100.0,
        width: 250.0,
        decoration: new BoxDecoration(
          color: Colors.orange[200],
          border: new Border.all(color: Colors.redAccent, width: 5.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: op == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceAround,
          children: <Widget>[
            operand1 != null
                ? DragTarget<String>(
                    key: Key('lbox1'),
                    builder: (context, candidateData, rejectedData) =>
                        Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Center(
                            child: Text(
                              "$operand1",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    onWillAccept: (data) => true,
                    onAccept: (data) => setState(() {
                          if (equation == Equation.lefthandside) {
                            _leftOperand1 = data;
                          } else
                            _rightOperand1 = data;
                        }),
                  )
                : Container(),
            op != null
                ? Text(
                    "$op",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 50.0,
                        fontWeight: FontWeight.bold),
                  )
                : Container(),
            operand2 != null
                ? DragTarget<String>(
                    key: Key('rbox2'),
                    builder: (context, candidateData, rejectedData) =>
                        Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: Center(
                            child: Text(
                              "$operand2",
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
                        if (equation == Equation.lefthandside) {
                          _leftOperand2 = data;
                        } else
                          _rightOperand2 = data;
                      });
                    })
                : Container(),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _solveEquation();
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
                  curve: Curves.decelerate,
                  child: _equationLayout(
                      _leftOperand1,
                      widget.leftExpression.item2,
                      _leftOperand2,
                      Equation.lefthandside),
                ),
                Text(
                  "=",
                  style: TextStyle(
                      color: _correct ? Colors.green : Colors.grey,
                      fontSize: 100.0,
                      fontWeight: FontWeight.bold),
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  alignment: _rightAlignment,
                  curve: Curves.decelerate,
                  child: _equationLayout(
                      _rightOperand1,
                      widget.rightExpression.item2,
                      _rightOperand2,
                      Equation.righthandside),
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
