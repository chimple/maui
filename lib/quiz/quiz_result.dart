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
                  Text(q['question']),
                  Text(q['result'] ?? '')
                ],
              ))
          .toList(growable: false),
    );
  }
}
