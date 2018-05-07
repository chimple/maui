import 'package:flutter/material.dart';
import 'package:maui/components/jitter.dart';

class Nima extends StatefulWidget {
  int score;
  Nima(this.score);

  @override
  _NimaState createState() {
    return new _NimaState();
  }
}

class _NimaState extends State<Nima> with TickerProviderStateMixin {
  int _prevScore;
  String _emotion;
  AnimationController shakeController, scaleController;
  Animation<double> shakeAnimation, scaleAnimation;

  @override
  void initState() {
    super.initState();
    _prevScore = widget.score;
    _emotion = 'neutral';
    shakeController = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    shakeAnimation = new Tween(begin: -1.0, end: 1.0).animate(shakeController)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed ||
            state == AnimationStatus.completed) {
          shakeController.reset();
          setState(() {
            _emotion = 'neutral';
          });
        }
      });
    scaleController = new AnimationController(
        value: 1.0,
        lowerBound: 0.7,
        upperBound: 1.0,
        duration: new Duration(milliseconds: 500),
        vsync: this);
    scaleAnimation =
        new CurvedAnimation(parent: scaleController, curve: Curves.bounceIn)
          ..addStatusListener((state) {
            print(state);
            if (state == AnimationStatus.completed) {
//              scaleController.reset();
              setState(() {
                _emotion = 'neutral';
              });
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    if (_prevScore < widget.score) {
      _emotion = 'happy';
      print('emotion: $_emotion');
      scaleController.forward(from: 0.7);
    } else if (_prevScore > widget.score) {
      _emotion = 'sad';
      shakeController.forward();
    }
    print('emotion: $_emotion');
    _prevScore = widget.score;
    return new ScaleTransition(
        scale: scaleAnimation,
        child: new Jitter(
            animation: shakeAnimation,
            child: new Image.asset(
              'assets/hoodie/reflex.png',
              height: 100.0,
            )));
  }

  @override
  void dispose() {
    shakeController.dispose();
    scaleController.dispose();
    super.dispose();
  }
}
