import 'dart:async';

import 'package:flutter/material.dart';

class Crossword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Crossword({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CrosswordState();
}

class _CrosswordState extends State<Crossword> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
