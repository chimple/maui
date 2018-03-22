import 'dart:async';

import 'package:flutter/material.dart';

class Abacus extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Abacus({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _AbacusState();
}

class _AbacusState extends State<Abacus> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
