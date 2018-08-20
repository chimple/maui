import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';

const Map<String, dynamic> testMap = {
  'image': 'stickers/giraffe/giraffe.png',
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
  var clicked = [];
  var choice = [], clickedChoices = [];
  List<bool> rightOrWrong = [];
  int j = 0, count = 0;

  @override
  void initState() {
    super.initState();
    _initboard();
  }

  void _initboard() {

    // Array for storing choices from input
    for (var i = 0; i < widget.input['order'].length; i++) {
      choice.add(widget.input['order'][i]);
    }
    // choice = choice.map((a) => widget.input['order'][a]).toList(growable: false);
    ans = widget.input['image'];
    print("Choices at initializtion -$choice");
    
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
                      clickedChoices.add(text); // storing the sequence in which the choices are clicked
                      count++; // counter to check if the sequence is completed
                    });

            if(count == 4){
              new Future.delayed(const Duration(milliseconds: 300), () {
              for(var i = 0;i < 4;i++)
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
                widget.onEnd();
                setState(() {
                                  choice = clicked.map((e) => "").toList(growable: false);
                                  clicked = choice.map((e) => "false").toList(growable: false);
                                  rightOrWrong = choice.map((i) => false).toList(growable: false);
                                });            
              });
            }
          
        });
  }

  @override
  Widget build(BuildContext context) {
    int k=0;

    double ht = MediaQuery.of(context).size.height;
    double wd = MediaQuery.of(context).size.width;    

    
    List<Widget> cells = choice.cast<String>().map((e) => new Padding(
                padding: EdgeInsets.all(10.0),
                child: _buildItem(j++, e, k++),
              ))
          .toList(growable: false);

    return new LayoutBuilder(
      builder: (context, constraints) {
        return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SingleChildScrollView(
                  child: new Container(
                height: ht * 0.48,
                width: wd * 0.7,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(20.0),
                  color: Colors.white,
                  border: new Border.all(
                    width: 6.0,
                    color: Colors.grey,
                  ),
                ),
                child: new Column(children: <Widget>[
                  //Image's Container
                  new Container(
                    height: ht * 0.4,
                    width: wd * 0.4,
                    child: new Image(
                      image: new AssetImage("assets/${widget.input['image']}"),
                    ),
                  ),

                  // Question's Container
                  new Container(
                    height: ht * 0.07,
                    decoration: new BoxDecoration(
                        // borderRadius: new BorderRadius.circular(20.0),
                        color: const Color(0xFFC0C0C0),
                        border: const Border(
                          bottom:
                              const BorderSide(width: 10.0, color: Colors.grey),
                        )),
                    child: new Text(
                      "${widget.input['question']}",
                      style: new TextStyle(
                          fontSize: ht * 0.03, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              )),
            ],
          ),
          new Expanded(
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
      });
  }
}
