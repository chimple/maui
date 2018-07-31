import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/gameaudio.dart';

class Reflex extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Reflex(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.onTurn,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new ReflexState();
}

class ReflexState extends State<Reflex> with TickerProviderStateMixin {
  int _size = 4;
  int _maxSize = 4;
  List<String> _allLetters;
  List<String> _solvedLetters = [];
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters;
  bool _isLoading = true;
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    print('reflex: initState()');
    if (widget.gameConfig.level < 4) {
      _maxSize = 2;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 3;
    } else {
      _maxSize = 4;
    }
    _controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    final CurvedAnimation curve =
        new CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _animation =
        new Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset(0.0, 0.0))
            .animate(curve);
    new Future.delayed(Duration(milliseconds: 750 + _maxSize * 300), () {
      _controller.forward();
    });

//    print('ReflexState:initState');
    _initBoard();
  }

  void _initBoard() async {
    print('_initBoard: ${widget.gameConfig.gameData}');
//    if (widget.gameConfig.gameData != null) {
//      print('initializing from: ${widget.gameConfig.gameData}');
//      fromJsonMap(widget.gameConfig.gameData);
//      setState(() => _isLoading = false);
//    } else {
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
    _letters = _shuffledLetters.sublist(0, _size * _size);
    _solvedLetters = [];
    setState(() => _isLoading = false);
//    }
  }

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['allLetters'] = _allLetters;
    data['shuffledLetters'] = _shuffledLetters;
    data['letters'] = _letters;
    data['solvedLetters'] = _solvedLetters;
    data['currentIndex'] = _currentIndex;
    data['size'] = _size;
    return data;
  }

  void fromJsonMap(Map<String, dynamic> data) {
    _allLetters = data['allLetters'].cast<String>();
    _shuffledLetters = data['shuffledLetters'].cast<String>();
    _letters = data['letters'].cast<String>();
    _solvedLetters = data['solvedLetters'].cast<String>();
    _currentIndex = data['currentIndex'];
    _size = data['size'];
  }

  @override
  void didUpdateWidget(Reflex oldWidget) {
    print('Reflex old iteration: ${oldWidget.iteration}');
    print('Reflex new iteration: ${widget.iteration}');
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
//      print(_allLetters);
    }
  }

  Widget _buildItem(
      int index, String text, int maxChars, double maxWidth, double maxHeight) {
    return new MyButton(
        key: new ValueKey<int>(index),
        order: index,
        text: text,
        maxChars: maxChars,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
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
            AppStateContainer.of(context).play('_audioright.mp3');
            widget.onScore(1);
            widget.onProgress(_currentIndex / _allLetters.length);
            new Future.delayed(const Duration(milliseconds: 250), () {
              setState(() {
                _solvedLetters.insert(0, text);
//                widget.onEnd(toJsonMap(), false);
              });
            });
            if (_currentIndex >= _allLetters.length) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd(toJsonMap(), true);
              });
            }
          } else {
            AppStateContainer.of(context).play('_audiowrong.mp3');
            widget.onScore(-1);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new Center(
          child: new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      ));
    }
    int j = 0;
    final maxChars = (_allLetters != null
        ? _allLetters.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);

    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;

      return new Column(
        children: <Widget>[
          Material(
              color: Theme.of(context).accentColor,
              elevation: 8.0,
              child: new LimitedBox(
                  maxHeight: maxHeight,
                  child: ListView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.all(buttonPadding),
                      itemExtent: buttonConfig.width,
                      children: _solvedLetters
                          .map((l) => Center(
                              child: Padding(
                                  padding: EdgeInsets.all(buttonPadding),
                                  child: UnitButton(
                                    text: l,
                                    primary: false,
                                    onPress: () {},
                                  ))))
                          .toList(growable: false)))),
          new Expanded(
              child: new Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: ResponsiveGridView(
                    rows: _size,
                    cols: _size,
                    children: _letters
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(
                                j++, e, maxChars, maxWidth, maxHeight)))
                        .toList(growable: false),
                  )))
        ],
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.order,
      this.text,
      this.onPress,
      this.maxChars,
      this.maxWidth,
      this.maxHeight})
      : super(key: key);

  final int order;
  final String text;
  final VoidCallback onPress;
  final int maxChars;
  final double maxWidth;
  final double maxHeight;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticInOut)
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
//    Future.delayed(Duration(milliseconds: 250 + widget.order * 100), () {
    controller.forward(from: 1.0);
//    });
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('MyButton.didUpdateWidget ${oldWidget.text} ${widget.text}');
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
    print("_MyButtonState.build ${widget.text}");
    return new ScaleTransition(
        scale: animation,
        child: new UnitButton(
          onPress: widget.onPress,
          text: _displayText ?? '',
          unitMode: UnitMode.text,
        ));
  }
}
