import 'package:flutter/material.dart';
import 'package:maui/games/reflex.dart';
import 'package:maui/games/TrueFalse.dart';
import 'package:maui/components/progress_bar.dart';

enum GameMode { timed, iterations }

class SingleGame extends StatefulWidget {
  final String gameName;
  final int maxIterations;
  final int playTime;
  final GameMode _gameMode;

  SingleGame(this.gameName, {this.maxIterations = 0, this.playTime = 0})
      : _gameMode = maxIterations > 0 ? GameMode.iterations : GameMode.timed;

  @override
  _SingleGameState createState() {
    return new _SingleGameState();
  }
}

class _SingleGameState extends State<SingleGame> {
  int _score = 0;
  double _progress = 0.0;
  int _iteration = 0;

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
        widget._gameMode == GameMode.timed
            ? new ProgressBar(time: widget.playTime, onEnd: _onGameEnd)
            : new ProgressBar(progress: _progress),
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
    if (widget._gameMode == GameMode.iterations) {
      setState(() {
        _progress = (_iteration + progress) / widget.maxIterations;
      });
    }
  }

  _onEnd() {
    if (widget._gameMode == GameMode.iterations) {
      if (_iteration < widget.maxIterations) {
        setState(() {
          _iteration++;
        });
      } else {
        _onGameEnd();
      }
    }
  }

  _onGameEnd() {
    print('Game over');
  }

  Widget buildSingleGame() {
    switch (widget.gameName) {
      case 'reflex':
        return new Reflex(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: _onEnd,
            iteration: _iteration);
      
      case 'true_or_false':
        return new QuizPage(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: _onEnd,
            iteration: _iteration);
    }
    return null;
  }
}
