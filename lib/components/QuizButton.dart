import 'package:flutter/material.dart';

class QuizButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  int keys;

  QuizButton(
      {Key key,
      this.text,
      this.keys,
      this.onPress})
      : super(key: key);
  
  @override
  QuizButtonState createState() => new QuizButtonState();
}

class QuizButtonState extends State<QuizButton>{
  

  initState() {
    super.initState();
    print("QuizButtonState.initState: ${widget.text}");
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    print("QuizButtonState.build");

    double ht = MediaQuery.of(context).size.height;
    double wd = MediaQuery.of(context).size.width;

    return new GestureDetector(
                  child: new ButtonTheme(
                    minWidth: 150.0,
                    height: 150.0,
                    child: new RaisedButton(
                   onPressed: () => widget.onPress(),
                   color: const Color(0xFFffffff),
                   shape: new RoundedRectangleBorder(
                       borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
                   child: widget.text.endsWith(".png")? new Image.asset("assets/$widget.text", width: wd * 0.4, height: ht * 0.12,) : new Container(
                     width: wd * 0.4,
                     height: ht * 0.12,
                       child: new Center(
                         child: new Text(widget.text,
                       key: new Key("${widget.keys}"),
                       style: new TextStyle(color: Colors.black, fontSize: ht * 0.1))))
      )),
    );
  }
}
