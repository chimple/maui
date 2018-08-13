import 'package:flutter/material.dart';

class QuizButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;

  QuizButton(
      {Key key,
      this.text,
      this.onPress})
      : super(key: key);
  
  @override
  QuizButtonState createState() => new QuizButtonState();
}

class QuizButtonState extends State<QuizButton>{  

  // initState() {
  //   super.initState();
  //   print("QuizButtonState.initState: ${widget.text}");
  // }

  @override
  Widget build(BuildContext context) {
    print("QuizButtonState.build");

    return new GestureDetector(
                  child: new ButtonTheme(
                    minWidth: 150.0,
                    height: 150.0,
                    child: new RaisedButton(
                   onPressed: () => widget.onPress(),
                   color: const Color(0xFFffffff),
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
