import 'package:flutter/material.dart';
class Shake extends AnimatedWidget {
  const Shake({
    Key key,
    Animation<double> animation,
    this.child,
  })
      : super(key: key, listenable: animation);

  final Widget child;

  Animation<double> get animation => listenable;
  double get translateX {
    final double t = animation.value;
//    const double shakeDelta = 2.0;
//     if (t <= 0.25)
//       return -t * shakeDelta;
//     else if (t < 0.75)
//       return (t - 0.5) * shakeDelta;
//     else
//       return (1.0 - t) * 4.0 * shakeDelta;
    return t*1.2;
  }

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: child,
    );
  }
}