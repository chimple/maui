import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maui/games/reflex.dart';
import 'package:maui/games/order_it.dart';
import 'package:maui/games/identify_game.dart';
import 'package:maui/games/abacus.dart';
import 'package:maui/games/drawing_game.dart';
import 'package:maui/games/memory.dart';
import 'package:maui/games/TrueFalse.dart';
import 'package:maui/games/bingo.dart';
import 'package:maui/games/fill_in_the_blanks.dart';
import 'package:maui/games/casino.dart';
import 'package:maui/games/crossword.dart';
import 'package:maui/games/tables.dart';
import 'package:maui/games/match_the_following.dart';
import 'package:maui/games/calculate_numbers.dart';
import 'package:maui/games/fill_number.dart';
import 'package:maui/games/connectdots.dart';
import 'package:maui/components/progress_bar.dart';
import 'package:maui/components/hoodie.dart';

enum GameMode { timed, iterations }

class SingleGame extends StatefulWidget {
  final String gameName;
  final int gameCategoryId;
  final Function onGameEnd;
  final Function onScore;
  final GameMode gameMode;
  final bool isRotated;

  SingleGame(this.gameName,
      {Key key,
        this.gameMode = GameMode.iterations,
      this.gameCategoryId,
      this.onGameEnd,
      this.onScore,
      this.isRotated = false})
      : super(key: key);

  @override
  _SingleGameState createState() {
    return new _SingleGameState();
  }
}

class _SingleGameState extends State<SingleGame> {
  int _score = 0;
  double _progress = 0.0;
  int _iteration = 0;
  int maxIterations = 2;
  int playTime = 10000;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('_SingleGameState:build');
    MediaQueryData media = MediaQuery.of(context);
    print(media.size);
    var game = buildSingleGame(context);
    return new Scaffold(
        appBar: new PreferredSize(
            child: new Row(
              children: <Widget>[
                new Hoodie(),
                new Text('$_score')
              ],
            ),
            preferredSize: new Size(100.0, 60.0)),
        body: new Column(children: <Widget>[
          widget.gameMode == GameMode.timed
              ? new ProgressBar(
                  time: playTime, onEnd: () => _onGameEnd(context))
              : new ProgressBar(progress: _progress),
          new Expanded(child: game)
        ]));
  }

  _onScore(int incrementScore) {
    setState(() {
      _score += incrementScore;
    });
    if (widget.onScore != null) widget.onScore(_score);
  }

  _onProgress(double progress) {
    if (widget.gameMode == GameMode.iterations) {
      setState(() {
        _progress = (_iteration + progress) / maxIterations;
      });
    }
  }

  _onEnd(BuildContext context) {
    if (widget.gameMode == GameMode.iterations) {
      if (_iteration + 1 < maxIterations) {
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
        playTime = 15000;
        maxIterations = 1;
        return new Reflex(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'order_it':
        return new OrderIt(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'true_or_false':
        return new TrueFalseGame(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'identify':
        return new IdentifyGame(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'abacus':
        return new Abacus(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'drawing':
        return new Drawing(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'bingo':
        return new Bingo(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'fill_in_the_blanks':
        return new FillInTheBlanks(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'casino':
        return new Casino(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'crossword':
        return new Crossword(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            isRotated: widget.isRotated,
            iteration: _iteration);
        break;
      case 'tables':
        return new Tables(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'match_the_following':
        playTime = 15000;
        maxIterations = 4;
        return new MatchTheFollowing(
          onScore: _onScore,
          onProgress: _onProgress,
          onEnd: () => _onEnd(context),
          iteration: _iteration,
          isRotated: widget.isRotated,
          gameCategoryId: widget.gameCategoryId,
        );
        break;
      case 'calculate_numbers':
        return new CalculateTheNumbers(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'memory':
        return new Memory(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
      case 'fill_number':
        return new Fillnumber(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
        case 'connect_the_dots': 
        return new Connectdots(
            onScore: _onScore,
            onProgress: _onProgress,
            onEnd: () => _onEnd(context),
            iteration: _iteration,
            isRotated: widget.isRotated,
            gameCategoryId: widget.gameCategoryId);
        break;
    }
    return null;
  }
}
