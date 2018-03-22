import 'dart:async';

import 'package:flutter/material.dart';

class Casino extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Casino({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _CasinoState();
}

class _CasinoState extends State<Casino> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
