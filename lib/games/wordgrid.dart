import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';

class Wordgrid extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Wordgrid(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new WordgridState();
}

class WordgridState extends State<Wordgrid> {
  int _size = 4;
  List<String> _others = [
    'q',
    'w',
    'j',
    'q',
    'w',
    'j',
    'q',
    'w',
    'j',
    'w',
    'j'
  ];
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _letters = ['A', 'P', 'P', 'L', 'E'];
  List<int> _flags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    _currentIndex = 0;
    setState(() => _isLoading = true);
    _shuffledLetters.addAll(_letters);
    _shuffledLetters.addAll(_others);
    _shuffledLetters.shuffle();
    _flags.length=0;
    while (_flags.length <= _shuffledLetters.length) _flags.add(0);
    print('flag array $_flags');
    setState(() => _isLoading = false);
  }

  // @override
  // void didUpdateWidget(Wordgrid oldWidget) {
  //   print(oldWidget.iteration);
  //   print(widget.iteration);
  //   if (widget.iteration != oldWidget.iteration) {
  //     _initBoard();
  //   }
  // }

  Widget _buildItem(int index, String text, int flag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        flag: flag,
        onPress: () {
          if (text == _letters[_currentIndex]) {
            setState(() {
              _currentIndex++;
              _flags[index] = 1;
            });
            widget.onScore(1);
            widget.onProgress(_currentIndex / _letters.length);
            if (_currentIndex >= _letters.length) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
            }
          }
          else{
                setState(() {
              _flags[index] = 1;
            });
              new Future.delayed(const Duration(milliseconds: 550), () {
              setState(() {
                _flags[index] = 0;
              });
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    int j = 0;
    return new ResponsiveGridView(
      rows: _size,
      cols: _size,
      children: _shuffledLetters
          .map((e) => _buildItem(j, e, _flags[j++]))
          .toList(growable: false),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress, this.flag}) : super(key: key);

  final String text;
  final VoidCallback onPress;
  final int flag;

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
    print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new ScaleTransition(
        scale: animation,
        child: new RaisedButton(
            onPressed: () => widget.onPress(),
            color: widget.flag == 1 ? Colors.red : Colors.blue,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(8.0))),
            child: new Text(_displayText,
                style: new TextStyle(color: Colors.white, fontSize: 24.0))));
  }
}
