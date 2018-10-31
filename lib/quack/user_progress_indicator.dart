import 'package:flutter/material.dart';
import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:maui/models/root_state.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UserProgressIndicator extends StatelessWidget {
  final String collectionId;

  const UserProgressIndicator({Key key, this.collectionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
     return new LayoutBuilder(builder: (context, constraints) {
      print("Rajesh patil Width:${constraints.maxWidth} Height:${constraints.maxHeight}");
    return Connect<RootState, double>(
      convert: (state) => state.progressMap[collectionId],
      where: (prev, next) => next != prev,
      builder: (progress) {
        return LinearPercentIndicator(
          width: constraints.maxWidth * 0.870,
          lineHeight: constraints.maxWidth * 0.064,
          percent:  progress ?? 0.0,
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.greenAccent,
          backgroundColor: Colors.grey,   
        );
      },
      nullable: true,
    );
    });
  }
}
