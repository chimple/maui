import 'package:flutter/material.dart';

class QuizResult extends StatefulWidget {
  List<Map<String, dynamic>> quizInputs;

  QuizResult({Key key, this.quizInputs}) : super(key: key);

  @override
  QuizResultState createState() {
    return new QuizResultState();
  }
}

class QuizResultState extends State<QuizResult> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.quizInputs
          .map((q) => Row(
                children: <Widget>[
                  new Expanded(
                    flex: 4,
                    child: new Container(
                      child: new Center(
                        child: Text(q['question'], overflow: TextOverflow.ellipsis ,),
                      ),
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Container(
                      child: new Center(
                        child: Text('${q['correct']} / ${q['total']})'),
                      ),
                    ),
                  ),
                ],
              ))
          .toList(growable: false),
    );
  }
}
