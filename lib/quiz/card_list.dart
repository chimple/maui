import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';

enum OptionCategory { oneAtATime, many, pair }

const Map<String, dynamic> testMap = {
  'image': 'assets/stickers/giraffe/giraffe.png',
  'question': 'Match the following according to the habitat of each animal',
  'order': ["abc", "def", "stickers/giraffe/giraffe.png", "lmn"],
  'correct': null,
  'total': null,
  'correctSequenceChoices': null,
  'choicesRightOrWrong': null
};

class CardList extends StatefulWidget {
  final Map<String,dynamic> input;
  final OptionCategory optionsType;
  final Function onEnd;

  const CardList ({
    Key key,
    this.input = testMap,
    @required this.optionsType,
    this.onEnd
  }) : super(key: key);


@override
  State createState() => new CardListState();
}

class CardListState extends State<CardList> {
  List<String> clicked = [], choice = [], clickedChoices = [], shuffledChoices = [];
  List<bool> rightOrWrong = [];
  int count = 0, correctChoices = 0, len;

  @override
  void initState() {
    super.initState();
    print("Card List Initstate");
    print("Choices List - ${widget.input['order']}");
    print("Choices Length - ${widget.input['order'].length}");
    len = widget.input['order'].length;
    _initBoard();
  }

  void _initBoard() {
    
    for(int i = 0; i < len; i++) {
    choice.add(widget.input['order'].cast<String>()[i]);
    shuffledChoices.add(widget.input['order'].cast<String>()[i]);
  }

  print("Values added to choices array - $choice");
  print("Values added to Shuffled Choices - $shuffledChoices");

  shuffledChoices.shuffle();

  clicked = choice.map((e) => "no").toList(growable: false);
  print("Value of Clicked array - $clicked");
  print("Value of len - $len");

  
  if(widget.input['correct'] == null)
    {
      rightOrWrong = choice.map((i) => false).toList(growable: false);
    }
    else {
      for (var i = 0; i < widget.input['choicesRightOrWrong'].length; i++) {
      rightOrWrong.add(widget.input['choicesRightOrWrong'][i]);
    }
    }
  print("Value of RightOrWrong Array after getting values - $rightOrWrong");

  }

  Widget _buildItem(int index, String text, int k, double ht) {

    // Universal Button for mapping keys, text/image to be shown, Button's present status and a function to perform desired actions
    return new  Container(
        height: ht / 8.0,
        child: QuizButton(
        key: new ValueKey<int>(index),
        text: text,
        buttonStatus: (widget.input['correct'] == null ? (clicked[k] == "no"
            ? Status.notSelected
            : clicked[k] == "yes"
                ? Status.disabled
                : rightOrWrong[k] ? Status.correct : Status.incorrect) : rightOrWrong[k] == true ? Status.correct : Status.incorrect),
        onPress: () {

          // changing value of clicked variable to yes when button is clicked
          if(widget.input['correct'] == null){
          if(widget.optionsType == OptionCategory.many) {
              setState(() {
                clicked[k] = "yes";
                if (clickedChoices.contains(text)) {
                } else {
                  clickedChoices.add(text); // storing the sequence in which the choices are clicked
                  count++; // counter to check if the sequence is completed
                }
              });

              if (count == choice.length) {
                new Future.delayed(const Duration(milliseconds: 300), () {
                  for (int i = 0; i < clicked.length; i++) {
                    setState(() {
                      clicked[i] = "done";
                    });

                    // checking if the element at choice and clicked choice array are same and mapping rightOrWrong array to true for performing the desired action
                    if (choice[i] == clickedChoices[i]) {                  
                        correctChoices++;
                    }
                  }
                });

                // Calling the parent class for an end and to switch on to the next game
                new Future.delayed(const Duration(milliseconds: 2000), () {
                  //TODO: Call this when all the items have been chosen
                  widget.onEnd({'correct': correctChoices, 'total': choice.length, 'correctSequenceChoices': "$choice", 'choicesRightOrWrong': rightOrWrong});
                });
              } 
            } else if (widget.optionsType == OptionCategory.oneAtATime){
              setState(() {
                              clicked[k] = "yes";
                              clickedChoices.add(text);
                            });
            }
          }
          else {
            print("This is the results Display section");
          }
        }
        ));
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int k = 0, j = 0;

    MediaQueryData media = MediaQuery.of(context);    
    var size = media.size;

    List<Widget> cells;
    cells = choice
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
        children:cells
      ),
    );
  }

}