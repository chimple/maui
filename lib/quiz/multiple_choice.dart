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
  bool showans = false;
  List<Statuses> _statuses = [];

  @override
  void initState() {
    super.initState();
    List<String> choices = widget.input['choices'].cast<String>();
    _statuses = choices.map((a) => Statuses.Active).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);

    var size = media.size;
    List<String> choices = widget.input['choices'].cast<String>();
    var k = 0;
    List<TableRow> rows = new List<TableRow>();

    for (var i = 0; i < 2; ++i) {
      List<Widget> cells = choices
          .skip(i * 2)
          .take(2)
          .map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildItem(k, e, choices, _statuses[k++],
                    widget.input['answer'], size.height),
              ))
          .toList();
      rows.add(new TableRow(children: cells));
    }

    return (widget.input['userChoice'] == null)
        ? new Container(
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
                  child: new Table(children: rows),
                ),
              ],
            ),
          )
        : new Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[
                new SingleChildScrollView(
                  child: Container(
                    height: size.height / 8,
                    color: Colors.amber,
                    child: QuizQuestion(
                      text: widget.input['question'],
                      image: null,
                    ),
                  ),
                ),
                new Table(children: rows)
              ],
            ),
          );
  }

  Widget _buildItem(int index, String element, List<String> choices,
      Statuses status, input, size) {
    if (widget.input['correct'] == null) {
      return Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: size * 0.15,
          child: new QuizButton(
              text: element,
              buttonStatus: status == Statuses.Active
                  ? Status.notSelected
                  : status == Statuses.Disappear
                      ? Status.correct
                      : Status.incorrect,
              onPress: () {
                if (!showans) {
                  if (element == widget.input['answer']) {
                    setState(() {
                      showans = true;
                      print("correct one is...clicked here$element");
                      _statuses[index] = Statuses.Disappear;

                      new Future.delayed(const Duration(milliseconds: 2000),
                          () {
                        widget.onEnd(
                            {'userChoice': element, 'correct': 1, 'total': 1});
                      });
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
                            print(
                                "after some delay  in quize is.....;::$_statuses");
                            var i = choices.indexOf(element);
                            setState(() {
                              _statuses[i] = Statuses.Disappear;
                            });
                          }
                        });
                      });
                      new Future.delayed(const Duration(milliseconds: 2000),
                          () {
                        widget.onEnd(
                            {'userChoice': element, 'correct': 0, 'total': 1});
                      });
                    });
                  }
                }
              }),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: size / 8,
          child: new QuizButton(
              text: element,
              buttonStatus: input == widget.input["userChoice"] &&
                      widget.input["userChoice"] == element
                  ? Status.correct
                  : element == widget.input["userChoice"]
                      ? Status.incorrect
                      : element == input ? Status.correct : Status.notSelected,
              onPress: () {}),
        ),
      );
    }
  }
}
