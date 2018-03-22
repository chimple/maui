import 'dart:async';

import 'package:flutter/material.dart';

class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Bingo({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _BingoState();
}

class _BingoState extends State<Bingo> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
