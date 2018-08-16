import 'package:flutter/material.dart';

enum Status{ notSelected, correct, incorrect, disabled }

class QuizButton extends StatefulWidget {
  final String text;
  Status buttonStatus;
  final Function onPress;

  QuizButton(
      {Key key,
      @required this.text,
      @required this.buttonStatus,
      @required this.onPress})
      : super(key: key);
  
  @override
  QuizButtonState createState() => new QuizButtonState();
}

class QuizButtonState extends State<QuizButton>{  
  Status currentButtonState;

  initState() {
    super.initState();
    print("QuizButtonState.initState: ${widget.text}");
    currentButtonState =Status.notSelected;
  }

  @override
  Widget build(BuildContext context) {
    print("QuizButtonState.build");

    return new RaisedButton(
                   onPressed: () { setState(() { currentButtonState = widget.buttonStatus; });
                     widget.onPress();},
                   color: currentButtonState == Status.notSelected ?  Color(0xFFffffff) : currentButtonState == Status.disabled ? Colors.grey : currentButtonState == Status.correct ? Colors.greenAccent : Colors.redAccent,
                   shape: new RoundedRectangleBorder(
                       borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                   child: widget.text.endsWith(".png")? new Center(child: new Image.asset("assets/${widget.text}")) : new Center(
                         child: new Text(widget.text,
                       key: new Key("${widget.key}"),
                       style: new TextStyle(color: Colors.black)))
      );
  }
}
