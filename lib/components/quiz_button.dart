import 'package:flutter/material.dart';

enum Status { notSelected, correct, incorrect, disabled }

class QuizButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Status buttonStatus;

  const QuizButton(
      {Key key,
      @required this.text,
      @required this.onPress,
      @required this.buttonStatus})
      : super(key: key);

  Widget build(BuildContext context) {
    print("QuizButton.build");
    print("ButtonStatus - $buttonStatus");

    return new RaisedButton(
        onPressed: onPress,
        color: buttonStatus == Status.disabled ? Colors.grey : buttonStatus == Status.correct ? Colors.green : buttonStatus == Status.incorrect ? Colors.red : Colors.white,
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
