import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class Nima extends StatefulWidget {
  final String name;
  final int score;
  final String tag;
  Nima({this.name, this.score, this.tag});

  @override
  _NimaState createState() {
    return new _NimaState();
  }
}

class _NimaState extends State<Nima> with TickerProviderStateMixin {
  int _prevScore;
  String _name;
  String _emotion = 'blinking';

  @override
  void initState() {
    super.initState();
    _name = widget.name;
    _prevScore = widget.score;
  }

  @override
  Widget build(BuildContext context) {
    if (_emotion == 'blinking') {
      if (_prevScore < widget.score) {
        _emotion = 'happy';
      } else if (_prevScore > widget.score) {
        _emotion = 'sad';
      }
    }
    print('emotion: $_emotion');
    _prevScore = widget.score;
    return NimaActor("assets/solo",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: '${_name}_$_emotion', completed: (String animationName) {
      setState(() {
        _emotion = 'blinking';
      });
    });
  }
}
