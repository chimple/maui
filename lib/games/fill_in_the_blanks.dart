import 'dart:async';

import 'package:flutter/material.dart';

class FillInTheBlanks extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  FillInTheBlanks({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _FillInTheBlanksState();
}

class _FillInTheBlanksState extends State<FillInTheBlanks> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
