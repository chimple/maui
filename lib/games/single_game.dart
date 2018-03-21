import 'package:flutter/material.dart';
import 'package:maui/games/reflex.dart';
import 'package:maui/games/order_it.dart';
import 'package:maui/games/Memory.dart';
import 'package:maui/components/progress_bar.dart';

enum GameMode { timed, iterations }

class SingleGame extends StatefulWidget {
  final String gameName;
  final int maxIterations;
  final int playTime;
  Function onGameEnd;
  Function onScore;
  final GameMode _gameMode;

  SingleGame(this.gameName,
      {this.maxIterations = 0, this.playTime = 0, this.onGameEnd, this.onScore})
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
            ? new ProgressBar(
                time: widget.playTime, onEnd: () => _onGameEnd(context))
            : new ProgressBar(progress: _progress),
        buildSingleGame(context)
      ]),
    );
  }

  _onScore(int incrementScore) {
    setState(() {
      _score += incrementScore;
    });
    if (widget.onScore != null) widget.onScore(_score);
  }

  _onProgress(double progress) {
    if (widget._gameMode == GameMode.iterations) {
      setState(() {
        _progress = (_iteration + progress) / widget.maxIterations;
      });
    }
  }

  _onEnd(BuildContext context) {
    if (widget._gameMode == GameMode.iterations) {
      if (_iteration + 1 < widget.maxIterations) {
        setState(() {
          _iteration++;
        });
      } else {
        _onGameEnd(context);
      }
    } else {
      setState(() {
        _iteration++;
      });
    }
  }

  _onGameEnd(BuildContext context) {
    if (widget.onGameEnd != null) {
      widget.onGameEnd(context);
    } else {
      showDialog<String>(
          context: context,
          child: new AlertDialog(
            content: new Text('$_score'),
          )).then<Null>((String s) {
        Navigator.pop(context);
      });
    }
  }

  Widget buildSingleGame(BuildContext context) {
    switch (widget.gameName) {
      case 'reflex':
        return new Reflex(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration);
        break;
       case 'order_it':
        return new OrderIt(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: _onEnd,
            iteration: _iteration);
        break;
        case 'memory':
        return new Memory(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: _onEnd,
            iteration: _iteration);
        break;       
    }
    return null;
  }
}
