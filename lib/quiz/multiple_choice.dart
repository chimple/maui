import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'dart:async';
import '../components/quiz_question.dart';

const Map<String, dynamic> _homework = {
  'image': 'lion',
  'question': "This animal is a carnivorous reptile.",
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

enum Statuses { Active, Visible, Disappear, Wrong }

class MultiplechoiceState extends State<Multiplechoice> {
  var val;
  bool showans = false;
  List<Statuses> _statuses = [];

  @override
  void initState() {
    super.initState();
    List<String> choices = widget.input['choices'].cast<String>();
    _statuses = choices.map((a) => Statuses.Active).toList(growable: false);
    print("hello this should come first...");
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    List<String> choices = widget.input['choices'].cast<String>();
    var j = 0;

    return new Container(
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.topCenter,
      child: new Column(
        children: <Widget>[
          new SingleChildScrollView(
            child: Container(
              height: size.height / 2,
              color: Colors.amber,
              child: QuizQuestion(
                text: widget.input['question'],
                image: 'assets/Animals.png',
              ),
            ),
          ),
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
          if (!showans) {
            if (element == widget.input['answer']) {
              setState(() {
                showans = true;
                print("correct one is...clicked here$element");
                _statuses[index] = Statuses.Disappear;
                widget.onEnd();
              });
            } else {
              setState(() {
                showans = true;
                _statuses[index] = Statuses.Wrong;
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
                new Future.delayed(const Duration(milliseconds: 1500), () {
                  widget.onEnd();
                });
              });
            }
          }
        });
  }
}
