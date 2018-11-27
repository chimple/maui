import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class Nima extends StatefulWidget {
  final String name;
  final int score;
  final String tag;
  final bool pageExited;
  Nima({this.name, this.score, this.tag, this.pageExited});

  @override
  _NimaState createState() {
    return new _NimaState();
  }
}

class _NimaState extends State<Nima> with TickerProviderStateMixin {
  int _prevScore;
  String _name;
  String _emotion = 'blinking';
  bool paused = false;
  String _animation;

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _prevScore = widget.score;
  }

  @override
  void didUpdateWidget(Nima oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageExited != widget.pageExited) {
      setState(() {
        paused = true;
        _animation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!paused) {
      if (_emotion == 'blinking') {
        if (_prevScore < widget.score) {
          _emotion = 'happy';
        } else if (_prevScore > widget.score) {
          _emotion = 'sad';
        }
      }
      _animation = '${_name}_$_emotion';
    }
    _prevScore = widget.score;
    return NimaActor("assets/solo",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        paused: paused,
        animation: _animation, completed: (_) {
      setState(() {
        if (!paused) _emotion = 'blinking';
      });
    });
  }
}
