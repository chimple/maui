import 'package:flutter/material.dart';

enum Status { notSelected, correct, incorrect, disabled }

class QuizButton extends StatelessWidget {
  final String text;
  final Status buttonStatus;
  final Function onPress;

  const QuizButton(
      {Key key,
      @required this.text,
      @required this.buttonStatus,
      @required this.onPress})
      : super(key: key);

  Widget build(BuildContext context) {
    print("QuizButton.build");

    return new RaisedButton(
        onPressed: onPress(),
        color: buttonStatus == Status.notSelected
            ? Color(0xFFffffff)
            : buttonStatus == Status.disabled
                ? Colors.grey
                : buttonStatus == Status.correct
                    ? Colors.greenAccent
                    : Colors.redAccent,
        shape: new RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
        child: text.endsWith(".png")
            ? new Center(child: new Image.asset("assets/${text}"))
            : new Center(
                child: new Text(text,
                    key: new Key("${key}"),
                    style: new TextStyle(color: Colors.black))));
  }
}
