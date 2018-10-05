import 'package:flutter/material.dart';

enum Status { notSelected, correct, incorrect, disabled }

class QuizButton extends StatefulWidget {
  final String text;
  final Function onPress;
  final Status buttonStatus;

  const QuizButton(
      {Key key,
      @required this.text,
      @required this.onPress,
      @required this.buttonStatus})
      : super(key: key);

  @override
  QuizButtonState createState() {
    return new QuizButtonState();
  }
}

class QuizButtonState extends State<QuizButton> with TickerProviderStateMixin {
  Animation<Color> animation;
  AnimationController controller;
  AnimationController _controller;
  Animation<double> transitionTween;

    initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation = ColorTween(begin: Colors.redAccent, end: Colors.red).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
      //  controller.forward();
      }
    });

    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          //_controller.forward();
        }
      });

    transitionTween = Tween<double>(
      begin: .80,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

   @override
  void didUpdateWidget(QuizButton oldWidget) {
    if (widget.buttonStatus == Status.correct) controller.forward();
    if (widget.buttonStatus == Status.incorrect) _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

   @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    print("QuizButton.build");
    print("ButtonStatus - ${widget.buttonStatus}");

    return ScaleTransition(
      scale: transitionTween,
          child: new RaisedButton(
          onPressed: widget.buttonStatus == Status.notSelected ? widget.onPress : null,
          color: Colors.amber,
         disabledColor: widget.buttonStatus == Status.incorrect
                ? animation.value
                : widget.buttonStatus == Status.correct
                    ? Colors.green
                    : Colors.grey,
          shape: new RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(16.0))),
          child: widget.text.endsWith(".png")
              ? new Center(child: new Image.asset("assets/${widget.text}"))
              : new Center(
                  child: new Text(widget.text,
                      key: new Key("${widget.key}"),
                      style: new TextStyle(
                          fontSize: size.height * 0.02, color: Colors.black)))),
    );
  }
}
