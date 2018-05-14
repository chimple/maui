import 'package:flutter/material.dart';

class ProgressCircle extends StatefulWidget {
  double progress;
  int time;
  Function onEnd;
  double strokeWidth;

  ProgressCircle(
      {this.progress, this.time, this.onEnd, this.strokeWidth = 8.0});

  @override
  _ProgressCircleState createState() {
    return new _ProgressCircleState();
  }
}

class _ProgressCircleState extends State<ProgressCircle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.time != null) {
      _controller = new AnimationController(
          duration: new Duration(milliseconds: widget.time), vsync: this);
      _animation = new Tween(begin: 1.0, end: 0.0).animate(_controller)
        ..addListener(() {
          setState(() {
            print('setState');
            // call state
          });
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.onEnd();
          }
        });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new CircularProgressIndicator(
      valueColor:
          new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
      strokeWidth: widget.strokeWidth,
      value: _animation != null ? _animation.value : widget.progress,
    );
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
