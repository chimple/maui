import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_question.dart';

const Map<String, dynamic> testMap = {
  'image': 'assets/stickers/giraffe/giraffe.png',
  'question': 'Match the following according to the habitat of each animal',
  'order': ["abc", "def", "stickers/giraffe/giraffe.png", "lmn"],
  'correct': null,
  'total': null,
  'correctSequenceChoices': null,
  'choicesRightOrWrong': null
};

class SequenceQuiz extends StatefulWidget {
  final Map<String, dynamic> input;
  final Function onEnd;

  const SequenceQuiz({Key key, this.input = testMap, this.onEnd})
      : super(key: key);

  @override
  State createState() => new SequenceQuizState();
}

class SequenceQuizState extends State<SequenceQuiz> {
  int score = 0;
  List<String> clicked = [], shuffledChoices = [];
  List<String> choice = [];
  List<String> clickedChoices = [];
  List<bool> rightOrWrong = [];
  int count = 0, correctChoices = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    // Arrays for storing choices from input
    for (var i = 0; i < widget.input['order'].length; i++) {
      choice.add(widget.input['order'].cast<String>()[i]);
      shuffledChoices.add(widget.input['order'].cast<String>()[i]);
    }
  
    // Shuffled Choices
    shuffledChoices.shuffle();
    print("Shuffled Choices - $shuffledChoices");

    // Array to track the choices clicked
    clicked = choice.map((e) => "false").toList(growable: false);
    // Array to check if the choices are clicked in the correct sequence
    if(widget.input['correct'] == null)
    {
      rightOrWrong = choice.map((i) => false).toList(growable: false);
    }
    else {
      for (var i = 0; i < widget.input['choicesRightOrWrong'].length; i++) {
      rightOrWrong.add(widget.input['choicesRightOrWrong'][i]);
    }
    }
  }

  Widget _buildItem(int index, String text, int k, double ht) {

    // Universal Button for mapping keys, text/image to be shown, Button's present status and a function to perform desired actions
    return new  Container(
        height: ht / 8.0,
        child: QuizButton(
        key: new ValueKey<int>(index),
        text: text,
        buttonStatus: (widget.input['correct'] == null ? (clicked[k] == "false"
            ? Status.notSelected
            : clicked[k] == "true"
                ? Status.disabled
                : rightOrWrong[k] ? Status.correct : Status.incorrect) : rightOrWrong[k] == true ? Status.correct : Status.incorrect),
        onPress: () {
          print("Score before onPress - $score");
          // changing value of clicked button to true when button is clicked

          if(widget.input['correct'] == null){
          setState(() {
            clicked[k] = "true";
            if (clickedChoices.contains(text)) {
            } else {
              clickedChoices.add(text); // storing the sequence in which the choices are clicked
              count++; // counter to check if the sequence is completed
            }
          });

          if (count == choice.length) {
            new Future.delayed(const Duration(milliseconds: 300), () {
              for (var i = 0; i < clicked.length; i++) {
                setState(() {
                  clicked[i] = "completed";
                });

                // checking if the element at choice and clicked choice array are same and mapping rightOrWrong array to true for performing the desired action
                if (choice[i] == clickedChoices[i]) {
                  setState(() {
                    rightOrWrong[i] = true;
                    correctChoices++;
                  });
                }
              }
            });

            // Calling the parent class for an end and to switch on to the next game
            new Future.delayed(const Duration(milliseconds: 2000), () {
              //TODO: Call this when all the items have been chosen
              widget.onEnd({'correct': correctChoices, 'total': choice.length, 'correctSequenceChoices': "$choice", 'choicesRightOrWrong': rightOrWrong});
            });
          } 
          } 
          else {
            print("This is the else section");
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    int k = 0 , j = 0;
     MediaQueryData media = MediaQuery.of(context);    
    var size = media.size;
    print("Welconme to Widget Build Sequence Game");
    List<Widget> cells;
    cells = (widget.input['correct'] == null ? shuffledChoices : choice)
        .map((e) => new Padding(
              padding: EdgeInsets.all(10.0),
              child: _buildItem(j++, e, k++, size.height),
            ))
        .toList(growable: false);
  
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        widget.input['correct'] == null ? new Container(
            height: size.height * 0.53,
            child:
                // Common class for printing question and associated image
                new QuizQuestion(
              text: widget.input['question'],
              image: widget.input['image'],
            )) : new Container(
              decoration: new BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
                color: Colors.white
              ),
              child: new Center(
                child: new Text("The following is the correct Sequence -> ", style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),)
            )),

            widget.input['correct'] == null ? new Expanded(
          flex: 1,
          child: new GridView.count(
              primary: false,
              padding: const EdgeInsets.all(40.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              children: cells),
        ) : new Container(),

        widget.input['correct'] == null ? new Container() : new Container(
          width: size.width * 0.7,
          child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: cells)),
      ]);
  }
}
