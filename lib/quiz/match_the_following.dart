import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_question.dart';

class MatchingGame extends StatefulWidget {
  Map<String, dynamic> gameData;
  Function onEnd;
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
          "6": "string6",
          "7": "string7",
          "8": "string8",
          "9": "string9",
          "10": "string10",
          "11": "string11",
          "12": "string12",
          "13": "string13",
          "14": "string14",
          "15": "string15",
          "16": "string16",
          "17": "string17",
          "18": "string18",
          "19": "string19",
          "20": "string20"
        }
      }})
      : super(key: key);
  @override
  _MatchingGameState createState() => new _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  Map<String, dynamic> _selectedPairs = {};
  String _leftItemSelected;

  List<String> _leftSideItems;
  List<String> _leftSideDisabledItems = [];
  List<String> _rightSideDisabledItems = [];
  List<String> _rightSideItems;
  Status _leftButtonStatus = Status.notSelected ;
  Status _rightButtonStatus = Status.notSelected ;
  @override
  void initState() {
    super.initState();
    _leftSideItems = (widget.gameData["pairs"].keys.toList()..shuffle());
    _rightSideItems = (widget.gameData["pairs"].values.toList()..shuffle());
  }

  bool _checkItem(String buttonItem, bool isItemOnLeft) {
    if (isItemOnLeft == true) {
      return (_leftSideDisabledItems.indexOf(buttonItem) != -1) ? true : false;
    } else {
      return (_rightSideDisabledItems.indexOf(buttonItem) != -1) ? true : false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _leftItemSelected = '';
    if (_rightSideDisabledItems.length == widget.gameData["pairs"].length &&
        _leftSideDisabledItems.length == widget.gameData["pairs"].length) {
      _selectedPairs = new Map.fromIterables(
          _leftSideDisabledItems, _rightSideDisabledItems);
      print(_selectedPairs);
    }
    return new LayoutBuilder(
      builder: (context, constraints) {
        return new Column(
            children: <Widget>[
              new Expanded(
                flex: 1,
                child: new QuizQuestion(
                  text: widget.gameData["question"],
                  // image: widget.gameData["image"],
                ),
                // child: Container(
                //   margin: EdgeInsets.all(10.0),
                //   decoration: new BoxDecoration(
                //       shape: BoxShape.rectangle,
                //       color: Colors.orange,
                //       borderRadius:
                //           new BorderRadius.all(Radius.circular(10.0))),
                //   child: new Center(
                //     child: new Text(
                //       widget.gameData["question"],
                //       style: new TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 20.0),
                //     ),
                //   ),
                // ),
              ),
              new Expanded(
                flex: 7,
                child: new ListView.builder(
                    itemCount: widget.gameData["pairs"].length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                        padding: EdgeInsets.all(5.0),
                        height: (constraints.maxHeight - (constraints.maxHeight/8) )/5,
                        width: constraints.maxWidth,
                                              child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            new Container(
                              child: new QuizButton(
                                buttonStatus: _leftButtonStatus,
                                onPress: _checkItem(_leftSideItems[index], true)
                                    ? null
                                    : () {
                                        _leftItemSelected = _leftSideItems[index];
                                      },
                                text: _leftSideItems[index],
                              ),
                              // child: new RaisedButton(
                              //   onPressed: _checkItem(_leftSideItems[index], true)
                              //       ? null
                              //       : () {
                              //           _leftItemSelected = _leftSideItems[index];
                              //         },
                              //   padding: EdgeInsets.all(20.0),
                              //   child: new Center(
                              //     child: new Text(
                              //       _leftSideItems[index],
                              //       style: new TextStyle(
                              //         fontSize: 20.0,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ),
                            new Container(
                              child: new QuizButton(
                                buttonStatus: _rightButtonStatus,
                                onPress: _checkItem(_rightSideItems[index], false)
                                    ? null
                                    : () {
                                        print("correct");
                                        print(_leftItemSelected == ''
                                            ? "leftNotTapped"
                                            : _leftItemSelected);
                                        print(_rightSideItems[index]);
                                        if (_leftItemSelected != '') {
                                          setState(() {
                                            _leftButtonStatus = Status.disabled;
                                            _rightButtonStatus = Status.disabled;
                                            _leftSideDisabledItems
                                                .add(_leftItemSelected);
                                            print(_leftSideDisabledItems);
                                            _rightSideDisabledItems
                                                .add(_rightSideItems[index]);
                                            print(_rightSideDisabledItems);
                                            print(_selectedPairs);
                                            if (_leftSideDisabledItems.length ==
                                                _leftSideItems.length) {
                                              widget.onEnd();
                                            }
                                          });
                                        }
                                      },
                                text: _rightSideItems[index],
                              ),
                              // child: new RaisedButton(
                              //   onPressed: _checkItem(_rightSideItems[index], false)
                              //       ? null
                              //       : () {
                              //           print("correct");
                              //           print(_leftItemSelected == ''
                              //               ? "leftNotTapped"
                              //               : _leftItemSelected);
                              //           print(_rightSideItems[index]);
                              //           if (_leftItemSelected != '') {
                              //             setState(() {
                              //               _leftSideDisabledItems
                              //                   .add(_leftItemSelected);
                              //               print(_leftSideDisabledItems);
                              //               _rightSideDisabledItems
                              //                   .add(_rightSideItems[index]);
                              //               print(_rightSideDisabledItems);
                              //               print(_selectedPairs);
                              //               if (_leftSideDisabledItems.length ==
                              //                   _leftSideItems.length) {
                              //                 widget.onEnd();
                              //               }
                              //             });
                              //           }
                              //         },
                              //   padding: EdgeInsets.all(20.0),
                              //   child: new Center(
                              //     child: new Text(
                              //       _rightSideItems[index],
                              //       style: new TextStyle(
                              //         fontSize: 20.0,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
