import 'package:flutter/material.dart';

enum Status{ notselected, correct, incorrect }

class QuizButton extends StatefulWidget {
  final String text;
  Status buttonstatus;
  final Function onPress;

  QuizButton(
      {Key key,
      this.text,
      this.buttonstatus,
      this.onPress})
      : super(key: key);
  
  @override
  QuizButtonState createState() => new QuizButtonState();
}

class QuizButtonState extends State<QuizButton>{  
  Status currentbuttonstate;

  initState() {
    super.initState();
    print("QuizButtonState.initState: ${widget.text}");
    currentbuttonstate =Status.notselected;
  }

  @override
  Widget build(BuildContext context) {
    print("QuizButtonState.build");

    return new ButtonTheme(
                    child: new RaisedButton(
                   onPressed: () { setState(() { currentbuttonstate = widget.buttonstatus; });
                     widget.onPress();},
                   color: currentbuttonstate == Status.notselected ?  Color(0xFFffffff) : currentbuttonstate == Status.correct ? Colors.greenAccent : Colors.redAccent,
                   shape: new RoundedRectangleBorder(
                       borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                   child: widget.text.endsWith(".png")? new Center(child: new Image.asset("assets/${widget.text}")) : new Center(
                         child: new Text(widget.text,
                       key: new Key("${widget.key}"),
                       style: new TextStyle(color: Colors.black)))
      ));
  }
}
