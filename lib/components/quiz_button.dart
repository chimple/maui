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
  Animation<Color> blinkAnimation;
  Animation<double> resizeAnimation, noAnimation;
  AnimationController controller, _controller;
  bool isBlinking = true;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          setState(() {
            isBlinking = false;
          });
        }
      });

    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    blinkAnimation =
        ColorTween(begin: Colors.red, end: Colors.white).animate(curve);

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });

    resizeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    noAnimation = Tween<double>(
      begin: 1.0,
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
    print(
        "oldWidget ButtonStatus: ${oldWidget.buttonStatus}  widget ButtonStatus: ${widget.buttonStatus}");
    if (oldWidget.buttonStatus == Status.disabled &&
        widget.buttonStatus == Status.incorrect) {
      controller.forward();
    }

    if (oldWidget.buttonStatus == Status.disabled &&
        widget.buttonStatus == Status.correct) {
      _controller.forward();
    }

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

    return ScaleTransition(
      scale:
          widget.buttonStatus == Status.correct ? resizeAnimation : noAnimation,
      child: new RaisedButton(
          onPressed:
              widget.buttonStatus == Status.notSelected ? widget.onPress : null,
          color: Colors.amber,
          disabledColor: widget.buttonStatus == Status.disabled
              ? Colors.grey
              : widget.buttonStatus == Status.correct
                  ? Colors.green
                  : isBlinking == true ? blinkAnimation.value : Colors.red,
          shape: new RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(16.0))),
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
