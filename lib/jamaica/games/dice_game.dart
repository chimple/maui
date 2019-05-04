import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/jamaica/widgets/bento_box.dart';
import 'package:maui/jamaica/widgets/cute_button.dart';
import 'package:maui/jamaica/widgets/dot_number.dart';

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

class DiceGame extends StatefulWidget {
  final BuiltList<int> choices;
  final OnGameUpdate onGameUpdate;

  const DiceGame({Key key, this.choices, this.onGameUpdate}) : super(key: key);

  @override
  _DiceGameState createState() => _DiceGameState();
}

class _DiceGameState extends State<DiceGame>
    with SingleTickerProviderStateMixin {
  List<_ChoiceDetail> choiceDetails;
  String _counter = '';
  List<int> diceTries = [];
  List<int> originalDice = [];
  String _myCounter = " ";
  int count = 0;
  bool gameEnd = false;
  AnimationController animation;

  @override
  void initState() {
    super.initState();
    int i = 0;
    choiceDetails = widget.choices
        .map((c) => _ChoiceDetail(number: c, index: i++))
        .toList(growable: false);
    animation = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 400),
    );
    animation.addListener(() {
      this.setState(() {});
    });
  }

  displayLabel(String dElement) {
    _myCounter = dElement;
    _counter = '';
    for (int i = 0; i < diceTries.length; i++) {
      _counter = _counter + diceTries[i].toString();
    }
  }

  void _randomVal() {
    setState(() async {
      animation.forward(from: 0.0);
      if (count <= 1) {
        count = count + 1;
        String dElement = randomLogic(choiceDetails);
        var randval = int.parse(dElement);
        if (diceTries.length < 2) diceTries.add(randval);
        await new Future.delayed(const Duration(milliseconds: 200));
        displayLabel(dElement);

        print("dice data $_counter ");
        if (diceTries.length == 2) {
          var sum = diceTries[0] + diceTries[1];
          var sub = diceTries[0] - diceTries[1];
          if (sub < 0) sub = -sub;
          var matched = false;
          for (int i = 0; i < choiceDetails.length; i++) {
            if (choiceDetails[i].number != null) if (choiceDetails[i].number ==
                    sum ||
                choiceDetails[i].number == sub) {
              matched = true;
            }
          }
          if (matched != true) {
            // This is condition for change player and bad luck
            popup();
            await new Future.delayed(const Duration(seconds: 1));
            setState(() {
              _myCounter = " ";
              resetDice();
            });
          }
        }
      }
    });
  }

  popup() {
    MediaQueryData media = MediaQuery.of(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: Container(
            height: media.size.height * .2,
            width: media.size.width * .2,
            child: new Image(
                image: new AssetImage(
              'assets/hoodie/dice_sad.png',
            )),
          ),
        );
      },
    );
  }

  void resetDice() {
    count = 0;
    diceTries.clear();
    originalDice.clear();
    _counter = '';
    _myCounter = " ";
  }

  List<_ChoiceDetail> getExistingDataInInt(List<_ChoiceDetail> data) {
    List<_ChoiceDetail> existingData = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i].number != null) existingData.add(data[i]);
    }
    return existingData;
  }

  String randomLogic(List<_ChoiceDetail> data) {
    List<_ChoiceDetail> existingData = getExistingDataInInt(data);
    _ChoiceDetail randomExistingValue =
        existingData[new Random().nextInt(existingData.length)];
    String dElement = '';
    if (diceTries.length == 0) {
      int fValue, sValue;
      while (true) {
        fValue = new Random().nextInt(6) + 1;
        sValue = new Random().nextInt(6) + 1;
        int sum = (fValue + sValue), sub = (fValue - sValue);
        if (sub < 0) {
          sub *= -1;
        }
        if (sum == randomExistingValue.number ||
            sub == randomExistingValue.number) {
          if ((new Random().nextInt(100)) % 2 == 0) {
            originalDice = [
              new Random().nextInt(6) + 1,
              new Random().nextInt(6) + 1
            ];
          } else {
            originalDice = [fValue, sValue];
          }
          print({"the final new data is : ": originalDice});
          return fValue.toString();
        }
      }
    } else if (diceTries.length == 1) {
      return originalDice[1].toString();
    }
    return dElement;
  }

  getExistingDataForScore(List<_ChoiceDetail> choiceDetail) {
    List<int> existingData1 = [];
    for (int i = 0; i < choiceDetail.length; i++) {
      if (choiceDetail[i].number != null)
        existingData1.add(choiceDetail[i].number);
    }
    if (existingData1.length <= 1) {
      widget.onGameUpdate(score: 2, max: 2, gameOver: true, star: true);
      print("game over");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var dval;
    if (_myCounter != " ") {
      dval = _myCounter + '.png';
    } else {
      dval = "tapto_play.gif";
    }
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: BentoBox(
            rows: 2,
            cols: choiceDetails.length ~/ 2,
            children: choiceDetails
                .map((c) => c.number != null
                    ? CuteButton(
                        key: Key(c.index.toString()),
                        child: Center(
                          child: Text(c.number.toString()),
                        ),
                        onPressed: () {
                          setState(() {
                            var btnVal = -1, sum = 0, sub = 0;
                            if (c.number != null && diceTries.length == 2) {
                              btnVal = c.number;
                              sum = diceTries[0] + diceTries[1];
                              sub = diceTries[0] - diceTries[1];
                            }
                            if (sub < 0) {
                              sub = -sub;
                            }
                            if (btnVal == sum || btnVal == sub) {
                              getExistingDataForScore(choiceDetails);
                              resetDice();
                              sum = 0;
                              sub = 0;
                              setState(() {
                                c.number = null;
                              });
                            }
                            if (gameEnd) {
                              setState(() {
                                widget.onGameUpdate(
                                    score: 2,
                                    max: 2,
                                    gameOver: true,
                                    star: true);
                              });
                            }
                          });
                        },
                      )
                    : Container())
                .toList(growable: false),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * .1,
              width: size.width * .15,
              child: new Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      shape: BoxShape.rectangle,
                      border: new Border.all(color: Colors.black, width: 2.0)),
                  child: new Center(
                      child: _counter != ''
                          ? Text(_counter[0],
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0))
                          : Container())),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            SizedBox(
              height: size.height * .1,
              width: size.width * .15,
              child: new Container(
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      shape: BoxShape.rectangle,
                      border: new Border.all(color: Colors.black, width: 2.0)),
                  child: new Center(
                      child: _counter != ''
                          ? Text(_counter.substring(1),
                              style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0))
                          : Container())),
            ),
          ],
        ),
        Flexible(
          flex: 1,
          child: new InkWell(
              onTap: _randomVal,
              child: new Container(
                child: new Image(
                    image: new AssetImage(
                  animation.isAnimating
                      ? 'assets/dice_game/dice_play.gif'
                      : 'assets/dice_game/$dval',
                )),
              )),
        )
      ],
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}
