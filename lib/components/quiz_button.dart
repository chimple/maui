import 'package:flutter/material.dart';

class QuizButton extends StatelessWidget {
  final String text;
  var color;
  final bool buttonRightorWrong;
  final Function onPress;

  QuizButton(
      {Key key,
      this.text,
      this.color,
      this.buttonRightorWrong,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("QuizButton.build");

    return new ButtonTheme(
                    child: new RaisedButton(
                   onPressed: () => this.onPress(),
                   color: this.color,
                   shape: new RoundedRectangleBorder(
                       borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                   child: this.text.endsWith(".png")? new Center(child: new Image.asset("assets/$text")) : new Center(
                         child: new Text(text,
                       key: new Key("${this.key}"),
                       style: new TextStyle(color: Colors.black)))
      ));
  }
}
