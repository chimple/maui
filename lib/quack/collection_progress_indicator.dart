import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tinycolor/tinycolor.dart';

class CollectionProgressIndicator extends StatelessWidget {
  final QuackCard card;
  final double width;
  final double progress;
  final Color color;

  const CollectionProgressIndicator(
      {Key key, this.card, this.width, this.progress,this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: LinearPercentIndicator(
          width: width,
          lineHeight: 10,
          percent: min(progress ?? 0.0, 1.0),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: color,
          backgroundColor: Colors.white,
        ),
      );
    });
  }
}
