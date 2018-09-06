import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/components/quiz_button.dart';
import 'package:maui/components/quiz_question.dart';
//
//const Map<String, dynamic> quizMap = {
//  'image': 'Animals',
//  'question': 'Match the following according to the habitat of each animal',
//  'bool': true
//};

class TrueOrFalse extends StatefulWidget {
  Map<String, dynamic> input;
  Function onEnd;

  TrueOrFalse({Key key, this.input, this.onEnd}) : super(key: key);
  @override
  _TrueOrFalseState createState() {
    // TODO: implement createState
    return new _TrueOrFalseState();
  }
}

enum Statuses { Active, Visible, Reform, Wrong }

class _TrueOrFalseState extends State<TrueOrFalse> {
  List<String> TrueorFalse = ["true", "false"];
  var val;
  bool showans = false;
  List<Statuses> _statuses = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _statuses = TrueorFalse.map((a) => Statuses.Active).toList(growable: false);
    print("true or false come first...");
  }

  @override
  Widget build(BuildContext context) {
    List<String> TrueorFalse = ["true", "false"];
    // TODO: implement build
    print(
        "this is my data from json  ${"assets/${widget.input['image']}.png"}");
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    List<TableRow> rows = new List<TableRow>();
    var k = 0;
    List<Widget> cells = TrueorFalse
        .map((element) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildItem(k, element, TrueorFalse, _statuses[k++],
                  widget.input['bool'], size.height),
            ))
        .toList(growable: false);
    rows.add(new TableRow(children: cells));

    return (widget.input['answer'] == null)
        ? new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(10.0)),
              new SingleChildScrollView(
                child: new Container(
//                  decoration: BoxDecoration(
//                      border: new Border.all(color: Colors.black, width: 2.0)),
                  height: size.height / 2,
//                  color: Colors.amber,
                  child: new QuizQuestion(
                    text: widget.input['question'],
                    image: "assets/${widget.input['image']}.png",
                  ),
                ),
              ),
              new Padding(padding: EdgeInsets.all(30.0)),
              Expanded(
                child: new Table(children: rows),
              ),
            ],
          )
        : new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(10.0)),
              new Container(
//                  decoration: BoxDecoration(
//                      border: new Border.all(color: Colors.black, width: 2.0)),
                height: 30.0,
//                  color: Colors.amber,
                child: new QuizQuestion(
                  text: widget.input['question'],
                  image: (widget.input['answer'] == null
                      ? "assets/${widget.input['image']}.png"
                      : null),
                ),
              ),
              new Padding(padding: EdgeInsets.all(30.0)),
              new Table(children: rows)
            ],
          );
  }

  Widget _buildItem(int index, String element, List<String> TrueorFalse,
      Statuses status, input, double size) {
    if (widget.input['correct'] == null) {
      return Container(
        height: size / 8.0,
        child: new QuizButton(
            text: element,
            buttonStatus: status == Statuses.Active
                ? Status.notSelected
                : status == Statuses.Reform ? Status.correct : Status.incorrect,
            onPress: () {
              print("after i press $element");
              print("after i fds ${widget.input['bool']}");
              if (widget.input['answer'] == null) {
                if (!showans) {
                  if (element.toString() == widget.input['bool'].toString()) {
                    setState(() {
                      showans = true;
                      print("correct one is...clicked here$element");

                      _statuses[index] = Statuses.Reform;
                      new Future.delayed(const Duration(milliseconds: 1000),
                          () {
                        widget.onEnd({
                          'answer': element.toString(),
                          'correct': 1,
                          'total': 2
                        });
                      });
                    });
                  } else {
                    setState(() {
                      showans = true;
                      _statuses[index] = Statuses.Wrong;
                      print(
                          "this. is when we clicked wrong choice in quize is.....;::$_statuses");

                      new Future.delayed(const Duration(milliseconds: 1000),
                          () {
                        TrueorFalse.forEach((element) {
                          if (element.toString() ==
                              widget.input['bool'].toString()) {
                            print(
                                "after some delay  in quize is.....;::$_statuses");
                            var i = TrueorFalse.indexOf(element.toString());
                            setState(() {
                              _statuses[i] = Statuses.Reform;
                            });
                          }
                        });
                      });
                      new Future.delayed(const Duration(milliseconds: 1500),
                          () {
                        widget.onEnd({
                          'answer': element.toString(),
                          'correct': 1,
                          'total': 2
                        });
                      });
                    });
                  }
                }
              }
            }),
      );
    } else {
      print("ffsahfhsafkjdsafdkhfdfd ${widget.input['answer']}");
      print("YYYYYYYYYYYYYYYYY ${widget.input['bool']}");
      print("inputfom    $input");
      print("element from dcree $element");
      return Container(
        height: size / 8.0,
        child: new QuizButton(
            text: element,
            buttonStatus:
                input.toString() == widget.input['answer'].toString() &&
                        widget.input['answer'].toString() == element.toString()
                    ? Status.correct
                    : element.toString() == widget.input['answer'].toString()
                        ? Status.incorrect
                        : element.toString() == input.toString()
                            ? Status.correct
                            : Status.notSelected,
            onPress: () {}),
      );
    }
  }
}
