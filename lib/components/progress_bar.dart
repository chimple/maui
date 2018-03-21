import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  double progress;
  int time;
  Function onEnd;

  ProgressBar({this.progress, this.time, this.onEnd});

  @override
  _ProgressBarState createState() {
    return new _ProgressBarState();
  }
}

class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if(widget.time != null) {
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
    return new LinearProgressIndicator(
      value: _animation != null ? _animation.value : widget.progress,
    );
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }
}