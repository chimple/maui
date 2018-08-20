import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'dart:async';
import '../components/quiz_question.dart';

const Map<String, dynamic> _homework = {
  'image': 'lion',
  'questions': "#This animal is a carnivorous reptile.",
  'answer': 'lion',
  'choices': ["Cat", "Sheep", "lion", "Cow"],
};

class Multiplechoice extends StatefulWidget {
  final Map<String, dynamic> input;
  Function onEnd;
  Multiplechoice({Key key, this.input = _homework, this.onEnd})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new MultiplechoiceState();
  }
}

// enum Status { notSelected, correct, incorrect }
enum Statuses { Active, Visible, Disappear, Draggable, Dragtarget, First }
enum ShakeCell { Right, InActive, Dance, CurveRow }

class MultiplechoiceState extends State<Multiplechoice> {
  var val;
  bool showans = false;
  List<Statuses> _statuses = [];
  List<ShakeCell> _shakeCells = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("hello this should come first...");
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    List<String> choices = widget.input['choices'];
    _statuses = choices.map((a) => Statuses.Active).toList(growable: false);
    print("hello this shake cell staius is......$_statuses");
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    var size = media.size;
    List<String> choices = widget.input['choices'];
    var j = 0;
    print("hello data is.....::${widget.input['choices']}");
    return new Container(
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: new Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Padding(padding: EdgeInsets.all(10.0)),
          new SingleChildScrollView(
            child: Container(
              height: size.height / 2,
              color: Colors.amber,
              child: QuizQuestion(
                text: widget.input['questions'],
                image: 'assets/Animals.png',
              ),
            ),
          ),
          new Padding(padding: EdgeInsets.all(10.0)),
          Expanded(
            child: Container(
                child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 2.0,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              shrinkWrap: true,
              children: choices.map((element) {
                print("the dataq is.....$element");
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildItem(j, element, choices, _statuses[j++],
                        widget.input['answer'], val));
              }).toList(growable: false),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int index, String element, List<String> choices,
      Statuses status, input, val) {
    return new QuizButton(
        text: element,
        buttonStatus: status == Statuses.Active
            ? Status.notSelected
            : status == Statuses.Disappear ? Status.correct : Status.incorrect,
        onPress: () {
          //  setState(() {
          if (!showans) {
            // showans = true;
            if (element == widget.input['answer']) {
              setState(() {
                showans = true;
                print("coorect one is...clicked here$element");
                _statuses[index] = Statuses.Disappear;
              });
            } else {
              setState(() {
                showans = true;
                _statuses[index] = Statuses.Dragtarget;
                print(
                    "this. is when we clicked wrong choice in quize is.....;::$_statuses");

                new Future.delayed(const Duration(milliseconds: 500), () {
                  choices.forEach((element) {
                    if (element == widget.input['answer']) {
                      print("after some delay  in quize is.....;::$_statuses");
                      var i = choices.indexOf(element);
                      setState(() {
                        _statuses[i] = Statuses.Disappear;
                      });
                    }
                  });
                });
              });
            }
          }
        });

    // });
  }
}
