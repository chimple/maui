import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CollectionProgressIndicator extends StatelessWidget {
  final double width;
  final double progress;
  final Color color;
  final LinearStrokeCap strokeCap;
  const CollectionProgressIndicator(
      {Key key, this.width, this.progress, this.color, this.strokeCap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      return LinearPercentIndicator(
        padding: EdgeInsets.all(0.0),
        animation: true,
        width: width,
        lineHeight: 18,
        percent: min(progress ?? 0.0, 1.0),
        linearStrokeCap: strokeCap,
        progressColor: color,
        backgroundColor: Colors.white,
      );
    });
  }
}
