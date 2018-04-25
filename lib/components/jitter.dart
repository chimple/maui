import 'dart:math';

import 'package:flutter/material.dart';

class Jitter extends AnimatedWidget {
  const Jitter({
    Key key,
    Animation<double> animation,
    this.child,
  }) : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable;
  double get translateX {
    final double t = animation.value;
    return cos(t * 4 * pi);
  }

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: child,
    );
  }
}
