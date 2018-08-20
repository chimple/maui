import 'package:flutter/material.dart';

enum Status { notSelected, correct, incorrect }

class QuizButton extends StatefulWidget {
  final String text;
  Status buttonStatus;

  final Function onPress;

  QuizButton({Key key, this.text, this.buttonStatus, this.onPress})
      : super(key: key);

  @override
  QuizButtonState createState() => new QuizButtonState();
}

class QuizButtonState extends State<QuizButton> {
  Status currentButtonState;
  bool _isLoading = true;
  initState() {
    super.initState();
    print("QuizButtonState.initState: ${widget.text}");

    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    currentButtonState = Status.notSelected;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    print("QuizButtonState.build");
    var color;
    setState(() {
      currentButtonState = widget.buttonStatus;
    });

    print("hello bosssss clicking color iss......${widget.buttonStatus}");

    return new ButtonTheme(
        child: new RaisedButton(
            onPressed: () {
              setState(() {
                widget.onPress();

                print(
                    "in onpress button in quize button...::$currentButtonState");
              });
            },
            color: currentButtonState == Status.notSelected
                ? Color(0xFFffffff)
                : currentButtonState == Status.correct
                    ? Colors.greenAccent
                    : Colors.redAccent,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(16.0))),
            child: widget.text.endsWith(".png")
                ? new Center(child: new Image.asset("assets/${widget.text}"))
                : new Center(
                    child: new Text(widget.text,
                        key: new Key("${widget.key}"),
                        style: new TextStyle(color: Colors.black)))));
  }
}
