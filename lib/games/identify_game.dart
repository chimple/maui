import 'dart:async';

import 'package:flutter/material.dart';

class IdentifyGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  IdentifyGame({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _IdentifyGameState();
}

class _IdentifyGameState extends State<IdentifyGame> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
