import 'dart:math';
import 'package:flutter/material.dart';

class ShakeAnimator extends AnimatedWidget {
  const ShakeAnimator({
    Key key,
    Animation<double> animation,
    this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable;
  double get translate {
    final double t = animation.value;
    const double shakeDelta = 2.0;

    if (t <= 1) {
      return pi * t / 45;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Transform.rotate(
      // transform: new Matrix4.rotationY(translateX),
      child: child,
      angle: translate,
    );
  }
}
