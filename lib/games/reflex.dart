import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';

class Reflex extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Reflex(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new ReflexState();
}

class ReflexState extends State<Reflex> {
  int _size = 4;
  int _maxSize = 4;
  List<String> _allLetters;
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.gameConfig.level < 4) {
      _maxSize = 2;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 3;
    } else {
      _maxSize = 4;
    }
//    print('ReflexState:initState');
    _initBoard();
  }

  void _initBoard() async {
    _currentIndex = 0;
    setState(() => _isLoading = true);
    _allLetters = await fetchSerialData(widget.gameConfig.gameCategoryId);
    _size = min(_maxSize, sqrt(_allLetters.length).floor());
    _shuffledLetters = [];
    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }
//    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _size * _size);
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Reflex oldWidget) {
//    print(oldWidget.iteration);
//    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
//      print(_allLetters);
    }
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          print('_buildItem.onPress');
          if (text == _allLetters[_currentIndex]) {
            setState(() {
              _letters[index] =
                  _size * _size + _currentIndex < _allLetters.length
                      ? _shuffledLetters[_size * _size + _currentIndex]
                      : null;
              _currentIndex++;
            });
            widget.onScore(1);
            widget.onProgress(_currentIndex / _allLetters.length);
            if (_currentIndex >= _allLetters.length) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
            }
          } else {
            widget.onScore(-1);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
//    print("ReflexState.build");
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    int j = 0;
    return new ResponsiveGridView(
      rows: _size,
      cols: _size,
      maxAspectRatio: 1.3,
      padding: 4.0,
      children: _letters.map((e) => _buildItem(j++, e)).toList(growable: false),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);

  final String text;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
//        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == null && widget.text != null) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
//    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
//    print("_MyButtonState.build");
    return new ScaleTransition(
        scale: animation,
        child: new UnitButton(
          onPress: widget.onPress,
          text: _displayText,
          unitMode: UnitMode.text,
        ));
  }
}
