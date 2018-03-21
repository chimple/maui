import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';

class Reflex extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Reflex({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new ReflexState();
}

class ReflexState extends State<Reflex> {
  final int _size = 4;
  List<String> _allLetters;
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    _currentIndex = 0;
    _allLetters = fetchSerialData(Category.letter);
    _shuffledLetters = [];
    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }
    print(_shuffledLetters);
    _letters = _shuffledLetters.sublist(0, _size * _size);
  }

  @override
  void didUpdateWidget(Reflex oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print(_allLetters);
    }
  }

  Widget _buildItem(int index, String text) {
    print('_buildItem: $text');
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          if (text == _allLetters[_currentIndex]) {
            setState(() {
              _letters[index] =
                  _size * _size + _currentIndex < _allLetters.length
                      ? _shuffledLetters[_size * _size + _currentIndex]
                      : "";
              _currentIndex++;
            });
            widget.onScore(1);
            widget.onProgress(_currentIndex / _allLetters.length);
            if (_currentIndex >= _allLetters.length) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    List<TableRow> rows = new List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Table(children: rows);
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
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.reverse) {
          print('completed');
          if (!widget.text.isEmpty) {
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
    if (oldWidget.text.isEmpty && widget.text.isNotEmpty) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new TableCell(
        child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style: new TextStyle(
                            color: Colors.white, fontSize: 24.0))))));
  }
}
