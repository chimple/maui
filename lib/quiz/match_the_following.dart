import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_question.dart';

class MatchingGame extends StatefulWidget {
  final Map<String, dynamic> gameData;
  final Function onEnd;
  MatchingGame(
      {key,
      this.onEnd,
      this.gameData = const {
        "image":
            "https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg",
        "question": "what is this game about?",
        "pairs": {
          "1": "string1",
          "2": "string2",
          "3": "string3",
          "4": "string4",
          "5": "string5",
          "6": "string6"
        },
        "correct": null,
        "total": null,
        "leftSelectedItems": null,
        "rightSelectedItems": null,
      }})
      : super(key: key);
  @override
  _MatchingGameState createState() => new _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  Map<String, dynamic> _selectedPairs = {};
  String _leftItemSelected;
  int numberOfCorrectChoices = 0;

  List<String> _leftSideItems;
  List<String> _leftSideDisabledItems = [];
  List<String> _rightSideDisabledItems = [];
  List<String> _rightSideItems;
  @override
  void initState() {
    super.initState();
    _leftSideItems =
        (widget.gameData["pairs"].keys.toList().cast<String>()..shuffle());
    _rightSideItems =
        (widget.gameData["pairs"].values.toList().cast<String>()..shuffle());
  }

  List<Widget> _buildExpandedQuizWithCorrectAnswers(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    List<Widget> correctPairs = [];
    correctPairs.add(
      new Container(
        height: (mediaQueryData.size.height - 300.0) / 6,
        child: new QuizQuestion(
          key: new Key("question"),
          text: widget.gameData["question"],
          // image: widget.gameData["image"],
        ),
      ),
    );
    widget.gameData["pairs"].forEach((k, v) {
      correctPairs.add(new Container(
        padding: new EdgeInsets.all(5.0),
        height: (mediaQueryData.size.height - 300.0) / 6,
        width: mediaQueryData.size.width,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              width: mediaQueryData.size.width / 3,
              child: new QuizButton(
                key: new Key(k),
                onPress: null,
                text: k,
                buttonStatus: (_selectedPairs[k] == widget.gameData["pairs"][k])
                    ? Status.correct
                    : Status.incorrect,
              ),
            ),
            new Container(
              width: mediaQueryData.size.width / 3,
              child: new QuizButton(
                key: new Key(v),
                onPress: null,
                text: v,
                buttonStatus: _checkForRightSideItemCorrectness(v)
                    ? Status.correct
                    : Status.incorrect,
              ),
            ),
          ],
        ),
      ));
    });
    return correctPairs;
  }

  bool _checkForRightSideItemCorrectness(String rightSideItem) {
    bool isCorrect;
    _selectedPairs.forEach((k, v) {
      if (v == rightSideItem) {
        if (widget.gameData["pairs"][k] == rightSideItem) {
          if (widget.gameData["correct"] == null) {
            numberOfCorrectChoices += 1;
          }

          isCorrect = true;
        } else {
          isCorrect = false;
        }
      }
    });
    return isCorrect;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameData["correct"] == null) {
      _leftItemSelected = '';
      if (_rightSideDisabledItems.length == widget.gameData["pairs"].length &&
          _leftSideDisabledItems.length == widget.gameData["pairs"].length) {
        _selectedPairs = new Map.fromIterables(
            _leftSideDisabledItems, _rightSideDisabledItems);
        print(_selectedPairs);
      }
    } else {
      _leftSideDisabledItems = widget.gameData["leftSelectedItems"];
      print(_leftSideDisabledItems);
      _rightSideDisabledItems = widget.gameData["rightSelectedItems"];
      print(_rightSideDisabledItems);
      _selectedPairs = new Map.fromIterables(
          _leftSideDisabledItems, _rightSideDisabledItems);
      print(_selectedPairs);
    }
    return (widget.gameData["correct"] != null)
        ? new Column(
            children: _buildExpandedQuizWithCorrectAnswers(context),
          )
        : new LayoutBuilder(
            builder: (context, constraints) {
              return new Column(
                children: <Widget>[
                  new Expanded(
                    flex: 1,
                    child: new QuizQuestion(
                      key: new Key("question"),
                      text: widget.gameData["question"],
                      // image: widget.gameData["image"],
                    ),
                  ),
                  new Expanded(
                    flex: 7,
                    child: new ListView.builder(
                      itemCount: widget.gameData["pairs"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container(
                          padding: EdgeInsets.all(5.0),
                          height: (constraints.maxHeight -
                                  (constraints.maxHeight / 8)) /
                              5,
                          width: constraints.maxWidth,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Container(
                                width: constraints.maxWidth / 3,
                                child: new QuizButton(
                                  key: new Key(_leftSideItems[index]),
                                  buttonStatus: (_rightSideDisabledItems
                                                  .length ==
                                              widget.gameData["pairs"].length &&
                                          _leftSideDisabledItems.length ==
                                              widget.gameData["pairs"].length)
                                      ? (widget.gameData["pairs"]
                                                  [_leftSideItems[index]] ==
                                              _selectedPairs[
                                                  _leftSideItems[index]]
                                          ? Status.correct
                                          : Status.incorrect)
                                      : (_leftSideDisabledItems.indexOf(
                                                  _leftSideItems[index]) ==
                                              -1
                                          ? Status.notSelected
                                          : Status.disabled),
                                  onPress: () {
                                    _leftItemSelected = _leftSideItems[index];
                                  },
                                  text: _leftSideItems[index],
                                ),
                              ),
                              new Container(
                                width: constraints.maxWidth / 3,
                                child: new QuizButton(
                                  key: new Key(_rightSideItems[index]) ,
                                  buttonStatus: (_rightSideDisabledItems
                                                  .length ==
                                              widget.gameData["pairs"].length &&
                                          _leftSideDisabledItems.length ==
                                              widget.gameData["pairs"].length)
                                      ? (_checkForRightSideItemCorrectness(
                                              _rightSideItems[index])
                                          ? Status.correct
                                          : Status.incorrect)
                                      : (_rightSideDisabledItems.indexOf(
                                                  _rightSideItems[index]) ==
                                              -1
                                          ? Status.notSelected
                                          : Status.disabled),
                                  onPress: () {
                                    print(_leftItemSelected == ''
                                        ? "leftNotTapped"
                                        : _leftItemSelected);
                                    print(_rightSideItems[index]);
                                    if (_leftItemSelected != '' &&
                                        _leftSideDisabledItems
                                                .indexOf(_leftItemSelected) ==
                                            -1) {
                                      print(
                                          "<><><><><><><><><><><><><><><><><><><><><><><><><><<>");
                                      setState(() {
                                        _leftSideDisabledItems
                                            .add(_leftItemSelected);
                                        print(_leftSideDisabledItems);
                                        _rightSideDisabledItems
                                            .add(_rightSideItems[index]);
                                        print(_rightSideDisabledItems);
                                        print(_selectedPairs);
                                        if (_leftSideDisabledItems.length ==
                                            _leftSideItems.length) {
                                          new Future.delayed(
                                              const Duration(seconds: 2), () {
                                            widget.onEnd({
                                              'correct': numberOfCorrectChoices,
                                              'total': widget
                                                  .gameData["pairs"].length,
                                              "leftSelectedItems":
                                                  _leftSideDisabledItems,
                                              "rightSelectedItems":
                                                  _rightSideDisabledItems
                                            });
                                          });
                                        }
                                      });
                                    }
                                  },
                                  text: _rightSideItems[index],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
  }
}
