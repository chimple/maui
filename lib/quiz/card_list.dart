import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';

enum OptionCategory { oneAtATime, many, pair }

const Map<String, dynamic> testMap = {
  'question': 'Match the following according to the habitat of each animal',
  'choices': ["abc", "def", "stickers/giraffe/giraffe.png", "lmn"],
  'answer': ['a', 'b', 'c', 'd'],
  'correct': null,
  'total': null,
  'correctSequenceChoices': null,
  'choicesRightOrWrong': null
};

class CardList extends StatefulWidget {
  final Map<String, dynamic> input;
  final OptionCategory optionsType;
  final Function onEnd;

  const CardList(
      {Key key,
      this.input = testMap,
      this.optionsType = OptionCategory.many,
      this.onEnd})
      : super(key: key);

  @override
  State createState() => new CardListState();
}

class CardListState extends State<CardList> {
  List<String> clicked = [],
      choice = [],
      clickedChoices = [],
      shuffledChoices = [];
  List<bool> rightOrWrong = [];
  bool displayIcon = false;
  int count = 0, correctChoices = 0;

  @override
  void initState() {
    super.initState();
    print("Card List Initstate");
    _initBoard();
  }

  void _initBoard() {
    // Adding data of choices given by parent class to the choices and shuffledchoices variable
    if (widget.optionsType == OptionCategory.many) {
      for (int i = 0; i < widget.input['answer'].length; i++) {
        choice.add(widget.input['answer'].cast<String>()[i]);
        shuffledChoices.add(widget.input['answer'].cast<String>()[i]);
      }
      if (widget.input['choices'] != null) {
        for (int i = 0; i < widget.input['choices'].length; i++) {
          choice.add(widget.input['choices'].cast<String>()[i]);
          shuffledChoices.add(widget.input['choices'].cast<String>()[i]);
        }
      }
    } else if (widget.optionsType == OptionCategory.oneAtATime) {
      choice = shuffledChoices = widget.input['answer'];
      for (int i = 0; i < widget.input['choices'].length; i++) {
        choice.add(widget.input['choices']);
        shuffledChoices.add(widget.input['choices']);
      }
    } else if (widget.optionsType == OptionCategory.pair) {
      for (int i = 0; i < widget.input['choices'].length; i++) {
        choice.add(widget.input['choices'].cast<String>()[i]);
        shuffledChoices.add(widget.input['choices'].cast<String>()[i]);
      }
    }

    // Shuffling choices
    shuffledChoices.shuffle();

    // Array to keep track if a choice is clicked or not
    clicked = choice.map((e) => "no").toList(growable: false);

    // Array to keep track if choice is correct or incorrect
    if (widget.input['correct'] == null) {
      rightOrWrong = choice.map((i) => false).toList(growable: false);
    } else {
      for (var i = 0; i < widget.input['choicesRightOrWrong'].length; i++) {
        rightOrWrong.add(widget.input['choicesRightOrWrong'][i]);
      }
    }
    print("Value of RightOrWrong Array after getting values - $rightOrWrong");
  }

  Widget _buildItem(int index, String text, int k, double ht) {
    // Universal Button for mapping keys, text/image to be shown, Button's present status and a function to perform desired actions
    return new Container(
        height: ht / 8.0,
        child: QuizButton(
            key: new ValueKey<int>(index),
            text: text,
            buttonStatus: (widget.input['correct'] == null
                ? (clicked[k] == "no"
                    ? Status.notSelected
                    : clicked[k] == "yes"
                        ? Status.disabled
                        : rightOrWrong[k] ? Status.correct : Status.incorrect)
                : rightOrWrong[k] == true ? Status.correct : Status.incorrect),
            onPress: () {
              // changing value of clicked array to yes when button is clicked
              if (widget.input['correct'] == null) {
                if (widget.optionsType == OptionCategory.many) {
                  setState(() {
                    clicked[k] = "yes";
                    if (clickedChoices.contains(text)) {
                    } else {
                      clickedChoices.add(
                          text); // storing the sequence in which the choices are clicked
                      count++; // counter to check if the sequence is completed
                    }
                  });

                  if (count == choice.length &&
                      widget.input['choices'] == null) {
                    new Future.delayed(const Duration(milliseconds: 300), () {
                      for (int i = 0; i < clicked.length; i++) {
                        setState(() {
                          clicked[i] = "done";
                          displayIcon = true;
                        });

                        // checking if the element at choice and clicked choice array are same and mapping rightOrWrong array to true for performing the desired action
                        if (choice[i] == clickedChoices[i]) {
                          setState(() {
                            rightOrWrong[k] = true;
                          });
                        }
                      }
                       setState(() {
                          displayIcon = true;                                              
                        });
                    });

                    // Calling the parent class for an end and to switch on to the next game
                    new Future.delayed(const Duration(milliseconds: 2000), () {
                      //TODO: Call this when all the items have been chosen
                      widget.onEnd({
                        'correct': correctChoices,
                        'total': choice.length,
                        'correctSequenceChoices': "$choice",
                        'choicesRightOrWrong': rightOrWrong
                      });
                    });
                  } else if (count == widget.input['answer'].length &&
                      widget.input['choices'] != null) {
                    new Future.delayed(const Duration(milliseconds: 300), () {
                      for (int i = 0; i < clicked.length; i++) {
                        setState(() {
                          clicked[i] = "done";
                        });

                        if (choice.contains(clickedChoices[i])) {
                          setState(() {
                            rightOrWrong[k] = true;
                            correctChoices++;
                          });
                        }
                      }
                      setState(() {
                          displayIcon = true;                                              
                        });
                    });

                    // Calling the parent class for an end and to switch on to the next game
                    new Future.delayed(const Duration(milliseconds: 2000), () {                      
                      //TODO: Call this when all the items have been chosen
                      widget.onEnd({
                        'correct': correctChoices,
                        'total': choice.length,
                        'correctChoices': "${widget.input['answer']}",
                        'incorrectChoices': "${widget.input['choices']}",
                        'choicesRightOrWrong': rightOrWrong
                      });
                    });
                  }
                } else if (widget.optionsType == OptionCategory.oneAtATime) {
                  if (clicked[k] == "no") {
                    setState(() {
                      clicked =
                          choice.map((e) => "yes").toList(growable: false);
                      clickedChoices.add(text);
                    });

                    new Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        clicked =
                          choice.map((e) => "done").toList(growable: false);                          
                      displayIcon = true;                                              
                      });                      

                      if (text == widget.input['answer']) {
                        correctChoices++;
                      }
                    });

                    // Calling the parent class for an end and to switch on to the next game
                    new Future.delayed(const Duration(milliseconds: 2000), () {
                      //TODO: Call this when all the items have been chosen
                      widget.onEnd({
                        'correct': correctChoices,
                        'total': choice.length,
                        'choicesRightOrWrong': rightOrWrong
                      });
                    });
                  } else {}
                } else if (widget.optionsType == OptionCategory.pair) {
                  if (clicked[k] == "no") {
                    setState(() {
                      clicked[k] = "yes";
                      if (clickedChoices.contains(text)) {
                      } else {
                        clickedChoices.add(
                            text); // storing the sequence in which the choices are clicked
                        count++; // counter to check if the sequence is completed
                      }
                    });

                    if (count == choice.length) {
                      new Future.delayed(const Duration(milliseconds: 300), () {
                        for (int i = 0; i < clickedChoices.length; i++) {
                          setState(() {
                            clicked[i] = "done";
                          });

                          int k = choice.indexOf(clickedChoices[i]);
                          if (k % 2 == 0) {
                            if (clickedChoices[i + 1] == choice[k + 1]) {
                              setState(() {
                                rightOrWrong[k] = true;
                                correctChoices++;
                              });
                            }
                          } else if (k % 2 == 1) {
                            if (clickedChoices[i - 1] == choice[k - 1]) {
                              setState(() {
                                rightOrWrong[k] = true;
                                correctChoices++;
                              });
                            }
                          }
                        }
                         setState(() {
                          displayIcon = true;                                              
                        });
                      });

                      // Calling the parent class for an end and to switch on to the next game
                    new Future.delayed(const Duration(milliseconds: 2000), () {                      
                      //TODO: Call this when all the items have been chosen
                      widget.onEnd({
                        'correct': correctChoices,
                        'total': choice.length,
                        'choices': choice,
                        'choicesRightOrWrong': rightOrWrong
                      });
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
    int k = 0, j = 0;

    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;

    List<Widget> cells;
    cells = shuffledChoices
        .map((e) => new Padding(
              padding: EdgeInsets.all(10.0),
              child: _buildItem(j++, e, k++, size.height),
            ))
        .toList(growable: false);

    return new Container(
      decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: cells),
    );
  }
}
