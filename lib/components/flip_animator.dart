import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FlipAnimator extends StatefulWidget {
  final Widget front;
  final Widget back;
  final AnimationController controller;
  FlipAnimator({Key key, @required this.front, @required this.back, @required this.controller});

  FlipAnimatorState createState() => new FlipAnimatorState();
}

class FlipAnimatorState extends State<FlipAnimator> with TickerProviderStateMixin {
  Animation<double> _frontScale;
  Animation<double> _backScale;

  @override
  void initState() {
    super.initState();
    _frontScale = new Tween(begin: 1.0 , end: 0.0).animate(new CurvedAnimation(parent: widget.controller , curve: new Interval(0.0, 0.5, curve: Curves.easeIn)));
    _backScale = new CurvedAnimation(parent: widget.controller , curve: new Interval(0.5, 1.0, curve: Curves.easeOut));
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
          //fit: StackFit.expand,
          children: <Widget>[
            new AnimatedBuilder(
              child: widget.front,
              animation: _backScale,
              builder: (BuildContext context, Widget child) {
                final Matrix4 transform = new Matrix4.identity()
                  ..scale(_backScale.value, 1.0, 1.0);
                return new Transform(
                  transform: transform,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              },
            ),
            new AnimatedBuilder(
              child: widget.back,
              animation: _frontScale,
              builder: (BuildContext context, Widget child) {
                final Matrix4 transform = new Matrix4.identity()
                  ..scale(_frontScale.value, 1.0, 1.0);
                return new Transform(
                  transform: transform,
                  alignment: FractionalOffset.center,
                  child: child,
                );
              },
            ),
          ],
        );
  }
}