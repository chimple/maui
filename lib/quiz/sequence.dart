import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_question.dart';

const Map<String, dynamic> testMap = {
  'image': 'assets/stickers/giraffe/giraffe.png',
  'question': 'Match the following according to the habitat of each animal',
  'order': ["abc", "def", "stickers/giraffe/giraffe.png", "lmn"]
};

class SequenceQuiz extends StatefulWidget {
  final Map<String, dynamic> input;
  final Function onEnd;

  const SequenceQuiz({Key key, this.input = testMap, this.onEnd}) : super(key: key);

  @override
  State createState() => new SequenceQuizState();
}

class SequenceQuizState extends State<SequenceQuiz> {
  String ans;
  int score = 0;
  List<String> clicked = [], shuffledChoices = [];
  List<String> choice = [];
  List<String> clickedChoices = [];
  List<bool> rightOrWrong = [];
  int j = 0, count = 0;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {

    // Array for storing choices from input
    for (var i = 0; i < widget.input['order'].length; i++) {
      choice.add(widget.input['order'].cast<String>()[i]);
      shuffledChoices.add(widget.input['order'].cast<String>()[i]);
    }
    // choice = choice.map((a) => widget.input['order'][a]).toList(growable: false);
    ans = widget.input['image'];
    print("Choices at initializtion -$choice");

    shuffledChoices.shuffle();

    print("Shuffled Choices - $shuffledChoices");

    // shuffledChoices = choice.cast<String>().map((e) => choice.cast<String>()[e]).toList(growable: false);
    
    // Array to track the choices clicked
    clicked = choice.map((e) => "false").toList(growable: false);
    // Array to check if the choices are clicked in the correct sequence
    rightOrWrong = choice.map((i) => false).toList(growable: false);
  }

  Widget _buildItem(int index, String text, int k) {
    
    // Universal Button for mapping keys, text/image to be shown, Button's present status and a function to perform desired actions
    return new QuizButton(
        key: new ValueKey<int>(index),
        text: text,
        buttonStatus: clicked[k] == "false" ? Status.notSelected : clicked[k] == "true" ? Status.disabled : rightOrWrong[k] ? Status.correct : Status.incorrect,
        onPress: () {
          print("Score before onPress - $score");
          // changing value of clicked button to true when button is clicked
          setState(() {
                      clicked[k] = "true";
                      if(clickedChoices.contains(text)){}
                      else {
                      clickedChoices.add(text); // storing the sequence in which the choices are clicked
                      count++; // counter to check if the sequence is completed
                      }
                    });

            if(count == choice.length){
              new Future.delayed(const Duration(milliseconds: 300), () {
              for(var i = 0;i < clicked.length;i++)
              {
                
                setState(() {
                                  clicked[i] = "completed";
                                });                
                
                // checking if the element at choice and clicked choice array are same and mapping rightOrWrong array to true for performing the desired action
                if(choice[i] == clickedChoices[i])
                {
                  setState(() {
                                      rightOrWrong[i] = true;
                                    });                  
                }
              }
              });

              // Calling the parent class for an end and to switch on to the next game
              new Future.delayed(const Duration(milliseconds: 2000), () {
                //TODO: Call this when all the items have been chosen
                widget.onEnd({'correct': 1, 'total': 2});   
              });
            }
          
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    int k=0;
    var size = media.size;

    List<Widget> cells = shuffledChoices.map((e) => new Padding(
                padding: EdgeInsets.all(10.0),
                child: _buildItem(j++, e, k++),
              ))
          .toList(growable: false);

    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: size.height / 2,
            child: 
            new QuizQuestion(
                text: widget.input['question'],
                image: widget.input['image'],
              )),
          new Expanded(
            flex: 1,
            child: new GridView.count(
              primary: false,
              padding: const EdgeInsets.all(40.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              children: cells
            ),
          )
        ],
      );
  }
}
