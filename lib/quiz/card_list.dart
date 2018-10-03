import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';

enum OptionCategory { oneAtATime, many, pair }

enum ClickedStatus { no, yes, done, correct, incorrect, untouched }

class CardList extends StatefulWidget {
  final Map<String, dynamic> input;
  final OptionCategory optionsType;
  final Function onEnd;
  Function onPress;

  CardList({Key key, this.input, this.optionsType, this.onPress, this.onEnd})
      : super(key: key);

  @override
  State createState() => new CardListState();
}

class CardListState extends State<CardList> {
  List<String> choice = [], clickedChoices = [], shuffledChoices = [];
  List<ClickedStatus> clicked = [];
  List<bool> rightOrWrong = [];

  int correctChoices = 0;
  bool displayResults, displayIcon;

  @override
  void initState() {
    super.initState();
    print("Card List Initstate");
    _initBoard();
  }

  void _initBoard() async {
    choice = [];
    clickedChoices = [];
    shuffledChoices = [];
    clicked = [];
    rightOrWrong = [];

    displayResults = widget.input['correct'] == null ? false : true;
    displayIcon = false;

    // Adding data of choices given by parent class to the choices and shuffledchoices variable

    if (widget.optionsType == OptionCategory.many ||
        widget.optionsType == OptionCategory.pair) {
      for (int i = 0; i < widget.input['answer'].length; i++) {
        choice.add(widget.input['answer'].cast<String>()[i]);
        shuffledChoices.add(widget.input['answer'].cast<String>()[i]);
      }
    }
    if (widget.input['choices'] != null &&
            widget.optionsType == OptionCategory.many ||
        widget.optionsType == OptionCategory.oneAtATime) {
      for (int i = 0; i < widget.input['choices'].length; i++) {
        choice.add(widget.input['choices'].cast<String>()[i]);
        shuffledChoices.add(widget.input['choices'].cast<String>()[i]);
      }
    }

    // Shuffling choices
    shuffledChoices.shuffle();

    // Array to keep track if a choice is clicked or not
    clicked = choice.map((e) => ClickedStatus.no).toList(growable: false);

    // Array to keep track if choice is correct or incorrect
    if (displayResults == false) {
      rightOrWrong = choice.map((i) => false).toList(growable: false);
    } else {
      for (var i = 0; i < widget.input['choicesRightOrWrong'].length; i++) {
        rightOrWrong.add(widget.input['choicesRightOrWrong'][i]);
      }
    }
  }

  @override
  void didUpdateWidget(CardList oldWidget) {
    print(oldWidget);
    print(widget.input);
    if (widget.input != oldWidget.input) {
      _initBoard();
    }
  }

  Widget _buildItem(String text, int k, double ht) {
    // Universal Button for mapping keys, text/image to be shown, Button's present status and a function to perform desired actions
    return new Container(
        height: ht / 8.0,
        child: QuizButton(
            key: new ValueKey<int>(k),
            text: text,
            buttonStatus: (displayResults == false
                ? (clicked[k] == ClickedStatus.no
                    ? Status.notSelected
                    : clicked[k] == ClickedStatus.yes
                        ? Status.disabled
                        : widget.optionsType == OptionCategory.oneAtATime ? clicked[k] == ClickedStatus.correct ? Status.correct : clicked[k] == ClickedStatus.incorrect ? Status.incorrect: Status.notSelected :rightOrWrong[k] ? Status.correct : Status.incorrect)
                : rightOrWrong[k] == true ? Status.correct : Status.incorrect),
            onPress: () {
              // changing value of clicked array to yes when button is clicked
              if (displayResults == false) {
                if (widget.optionsType == OptionCategory.many) {
                  setState(() {
                    clicked[k] = ClickedStatus.yes;
                    if ((clickedChoices.contains(text)) == false) {
                      clickedChoices.add(
                          text); // storing the sequence in which the choices are clicked
                    }
                  });

                  if (clickedChoices.length == choice.length &&
                      widget.input['choices'] == null) {
                    new Future.delayed(const Duration(milliseconds: 300), () {
                      for (int i = 0; i < choice.length; i++) {
                        setState(() {
                          clicked[i] = ClickedStatus.done;
                        });

                        // checking if the element at choice and clicked choice array are same and mapping rightOrWrong array to true for performing the desired action
                        if (choice[i] == clickedChoices[i]) {
                          setState(() {
                            rightOrWrong[i] = true;
                          });
                        }
                      }
                    });
                    new Future.delayed(const Duration(milliseconds: 800), () {
                      var onedata = {
                        'correct': correctChoices,
                        'total': choice.length,
                        'choices': "${widget.input['choices']}",
                        'answer': "${widget.input['answer']}",
                        'choicesRightOrWrong': rightOrWrong
                      };
                      widget.onPress(onedata, displayIcon = true);
                    });
                  } else if (clickedChoices.length ==
                          widget.input['answer'].length &&
                      widget.input['choices'] != null) {
                    new Future.delayed(const Duration(milliseconds: 300), () {
                      for (int i = 0; i < choice.length; i++) {
                        setState(() {
                          clicked[i] = ClickedStatus.done;
                        });
                      }

                      for (int i = 0; i < clickedChoices.length; i++) {
                        if ((widget.input['answer'])
                            .contains(clickedChoices[i])) {
                          int index =
                              shuffledChoices.indexOf(clickedChoices[i]);
                          setState(() {
                            rightOrWrong[index] = true;
                            correctChoices++;
                          });
                        }
                      }
                      for (int i = 0; i < (shuffledChoices).length; i++) {
                        if (((widget.input['answer'])
                                .contains(shuffledChoices[i])) ==
                            false) {
                          setState(() {
                            rightOrWrong[i] = true;
                            correctChoices++;
                          });
                        }
                      }
                    });
                    new Future.delayed(const Duration(milliseconds: 800), () {
                      var onedata = {
                        'correct': correctChoices,
                        'total': choice.length,
                        'choices': "${widget.input['choices']}",
                        'answer': "${widget.input['answer']}",
                        'choicesRightOrWrong': rightOrWrong
                      };
                      widget.onPress(onedata, displayIcon = true);
                    });
                  }
                } else if (widget.optionsType == OptionCategory.oneAtATime) {
                  if (clicked[k] == ClickedStatus.no) {
                    setState(() {
                      clicked = choice
                          .map((e) => ClickedStatus.yes)
                          .toList(growable: false);
                      clickedChoices.add(text);
                    });

                    new Future.delayed(const Duration(milliseconds: 300), () {
                     
                      setState(() {
                        clicked = choice
                            .map((e) => ClickedStatus.untouched)
                            .toList(growable: false);
                      });

                      if (text == widget.input['answer'].first) {
                        setState(() {
                          clicked[k] = ClickedStatus.correct;
                          correctChoices++;
                        });
                      }
                      else {
                        clicked[k] = ClickedStatus.incorrect;
                        var correctChoiceIndex = shuffledChoices.indexOf(widget.input['answer'].first);
                        clicked[correctChoiceIndex] = ClickedStatus.correct;
                      }
                    });
                    new Future.delayed(const Duration(milliseconds: 800), () {
                      var onedata = {
                        'correct': correctChoices,
                        'total': choice.length,
                        'choices': "${widget.input['choices']}",
                        'answer': "${widget.input['answer']}",
                        'choicesRightOrWrong': rightOrWrong
                      };
                      widget.onPress(onedata, displayIcon = true);
                    });
                  }
                } else if (widget.optionsType == OptionCategory.pair) {
                  if (clicked[k] == ClickedStatus.no) {
                    setState(() {
                      clicked[k] = ClickedStatus.yes;
                      if ((clickedChoices.contains(text)) == false)
                        clickedChoices.add(
                            text); // storing the sequence in which the choices are clicked
                    });

                    if (clickedChoices.length == choice.length) {
                      new Future.delayed(const Duration(milliseconds: 300), () {
                        for (int i = 0; i < clickedChoices.length; i++) {
                          setState(() {
                            clicked[i] = ClickedStatus.done;
                          });

                          int index = choice.indexOf(clickedChoices[i]);
                          if (i % 2 == 0 && index % 2 == 0) {
                            if (clickedChoices[i + 1] == choice[index + 1]) {
                              setState(() {
                                rightOrWrong[i] = true;
                                correctChoices++;
                              });
                            }
                          } else if (i % 2 == 0 && index % 2 == 1) {
                            if (clickedChoices[i + 1] == choice[index - 1]) {
                              setState(() {
                                rightOrWrong[i] = true;
                                correctChoices++;
                              });
                            }
                          } else if (i % 2 == 1 && index % 2 == 0) {
                            if (clickedChoices[i - 1] == choice[index + 1]) {
                              setState(() {
                                rightOrWrong[i] = true;
                                correctChoices++;
                              });
                            }
                          } else if (i % 2 == 1 && index % 2 == 1) {
                            if (clickedChoices[i - 1] == choice[index - 1]) {
                              setState(() {
                                rightOrWrong[i] = true;
                                correctChoices++;
                              });
                            }
                          }
                        }
                      });
                      new Future.delayed(const Duration(milliseconds: 800), () {
                        var onedata = {
                          'correct': correctChoices,
                          'total': choice.length,
                          'choices': "${widget.input['choices']}",
                          'answer': "${widget.input['answer']}",
                          'choicesRightOrWrong': rightOrWrong
                        };
                        widget.onPress(onedata, displayIcon = true);
                      });
                    }
                  }
                }
              } else {
                print("This is the results Display section");
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int k = 0;

    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;

    List<Widget> cells;
    cells = shuffledChoices
        .map((e) => new Padding(
              padding: EdgeInsets.all(10.0),
              child: _buildItem(e, k++, size.height),
            ))
        .toList(growable: false);

    return new Container(
      decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
      child: new Column(children: <Widget>[
        // Row for Displaying the Question text
        new Padding(
          padding: new EdgeInsets.only(top: 10.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(widget.input['question'],
                        style: new TextStyle(
                            fontSize: size.height > size.width
                                ? size.height * 0.04
                                : size.height * 0.04,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ],
          ),
        ),

        // Column for buttons
        new Wrap(children: <Widget>[
          new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: cells)
        ]),

        // Row to display icon to call onEnd Widget
        // displayIcon == true
        //     ? new Center(
        //         child: new Container(
        //             height: 50.0,
        //             width: 50.0,
        //             decoration: new BoxDecoration(
        //               border: new Border.all(
        //                 color: Colors.black,
        //               ),
        //               shape: BoxShape.circle,
        //             ),
        //             child: new IconButton(
        //                 icon: new Icon(Icons.arrow_forward),
        //                 onPressed: () {
        //                   reset();
        //                 })))
        //     : new Container(),
      ]),
    );
  }
}
