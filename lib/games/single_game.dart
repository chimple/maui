import 'package:flutter/material.dart';
import 'package:maui/games/reflex.dart';

class SingleGame extends StatefulWidget {
  String gameName;

  SingleGame(this.gameName);

  @override
  _SingleGameState createState() {
    return new _SingleGameState();
  }
}

class _SingleGameState extends State<SingleGame> {
  int _score = 0;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Icon(Icons.ac_unit),
        actions: <Widget>[
          new Chip(label: new Text('$_score')),
        ],
      ),
      body: new Column(children: <Widget>[
        new LinearProgressIndicator(
          value: _progress,
        ),
        buildSingleGame()
      ]),
    );
  }

  _onScore(int incrementScore) {
    setState(() {
      _score += incrementScore;
    });
  }

  _onProgress(double progress) {
    setState(() {
      _progress = progress;
    });
  }

  Widget buildSingleGame() {
    print(widget.gameName);
    switch (widget.gameName) {
      case 'reflex':
        return new Reflex(onScore: _onScore, onProgress: _onProgress);
    }
    return null;
  }
}

