import 'package:flutter/material.dart';

enum Status { Selected, NotSelected }

class QuizButton extends StatefulWidget {
  final String text;
  final bool buttonRightorWrong;
  final VoidCallback onPress;

  QuizButton(
      {Key key,
      this.text,
      this.buttonRightorWrong,
      this.onPress})
      : super(key: key);
  
  @override
  QuizButtonState createState() => new QuizButtonState();
}

class QuizButtonState extends State<QuizButton>{    
  Status buttonstatus;

  initState() {
    super.initState();
    print("QuizButtonState.initState: ${widget.text}");
    buttonstatus = Status.NotSelected;    
  }

  @override
  Widget build(BuildContext context) {
    print("QuizButtonState.build");
    print("My ButtonStatus - $buttonstatus");
    print("Button Right Or Wrong - ${widget.buttonRightorWrong}");


    return new GestureDetector(
                  child: new ButtonTheme(
                    minWidth: 150.0,
                    height: 150.0,
                    child: new RaisedButton(
                   onPressed: () {
                     print("buttonStatus - $buttonstatus");
                     print("buttonRightOrWrong - ${widget.buttonRightorWrong}");
                     setState(() => buttonstatus = Status.Selected);
                     print("ButtonStatus after Press - $buttonstatus");
                     widget.onPress();},
                   color: buttonstatus == Status.NotSelected ? Color(0xFFffffff) : widget.buttonRightorWrong == true ? Colors.green : Colors.red,
                   shape: new RoundedRectangleBorder(
                       borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                   child: widget.text.endsWith(".png")? new Center(child: new Image.asset("assets/$widget.text")) : new Center(
                         child: new Text(widget.text,
                       key: new Key("${widget.key}"),
                       style: new TextStyle(color: Colors.black)))
      )),
    );
  }
}
