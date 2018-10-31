import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/db/entity/quack_card.dart';
import 'package:maui/models/root_state.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CollectionProgressIndicator extends StatelessWidget {
  final QuackCard card;

  const CollectionProgressIndicator({Key key, this.card}) : super(key: key);

  int hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      print(
          "Collection_Progress_Indicator Layout Builder: Width:${constraints.maxWidth} Height:${constraints.maxHeight}");
      return Connect<RootState, double>(
        convert: (state) => state.progressMap[card.id],
        where: (prev, next) => next != prev,
        builder: (progress) {
          return LinearPercentIndicator(
            width: constraints.maxWidth * 0.9805,
            lineHeight: constraints.maxWidth * 0.0743,
            percent: progress ?? 0.0,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: Color(hexStringToHexInt(card.option)),
            backgroundColor: Colors.grey,
          );
        },
        nullable: true,
      );
    });
  }
}
