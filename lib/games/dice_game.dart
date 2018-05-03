import 'package:flutter/material.dart';
class Dice extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  bool isRotated;
  Dice(
      {key,
        this.onScore,
        this.onProgress,
        this.onEnd,
        this.iteration,
        this.function,
        this.gameCategoryId,
        this.isRotated = false})
      : super(key: key);
  @override
  State createState() => new DiceOptions();
}

class DiceOptions extends State<Dice> {
  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}