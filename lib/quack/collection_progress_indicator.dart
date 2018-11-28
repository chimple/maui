import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tinycolor/tinycolor.dart';

class CollectionProgressIndicator extends StatelessWidget {
  final QuackCard card;

  const CollectionProgressIndicator({Key key, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      return Connect<RootState, double>(
        convert: (state) => state.activityMap[card.id]?.progress,
        where: (prev, next) => next != prev,
        builder: (progress) {
          return LinearPercentIndicator(
            width: constraints.maxWidth * 0.9805,
            lineHeight: constraints.maxWidth * 0.0743,
            percent: min(progress ?? 0.0, 1.0),
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: TinyColor(card.backgroundColor).darken(20).color,
            backgroundColor: Colors.white,
          );
        },
        nullable: true,
      );
    });
  }
}
