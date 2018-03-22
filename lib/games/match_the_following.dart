import 'dart:async';

import 'package:flutter/material.dart';

class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  MatchTheFollowing({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

class _MatchTheFollowingState extends State<MatchTheFollowing> {
  @override
  Widget build(BuildContext context) {
    return new Text('test');
  }
}
