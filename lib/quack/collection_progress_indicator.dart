import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tinycolor/tinycolor.dart';

class CollectionProgressIndicator extends StatelessWidget {
  final QuackCard card;
  final double width;
  final double progress;

  const CollectionProgressIndicator(
      {Key key, this.card, this.width, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      return LinearPercentIndicator(
        width: width,
        lineHeight: 10,
        percent: min(progress ?? 0.0, 1.0),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.red,
        backgroundColor: Colors.white,
      );
    });
  }
}
