import 'dart:async';

import 'package:flutter/material.dart';

class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  MatchTheFollowing(
      {key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

class _MatchTheFollowingState extends State<MatchTheFollowing> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(children: <Widget>[
        new Row(
          children: <Widget>[
            new Expanded(
              child: new MyTable(),
            ),
            new Padding(
              padding: const EdgeInsets.all(80.0),
            ),
            new Expanded(child: new MyTable()),
          ],
        ),
      ]),
    );
  }
}

class MyTable extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyTableState();
}

var flag = 0;

class MyTableState extends State<MyTable> {
  final List<String> _nothing = ['', '', '', '', '', ''];
  final List<String> _allLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', // left side question
    'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  final List<String> _allLetters1 = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'u',
    'j',
    'k',
    'l',
    'm',
    'n'
  ]; // right side answer
  //var j = 0;
  int _size = 5;
  int _textIncreament = 0;
  int _nextTask;
  var _currentIndex = 0;
  List<String> _shuffledLetters = [];
  List<String> _shuffledLetters1 = [];
  List<String> _letters, _letters1;
  var color = 300;
  @override
  void initState() {
    _nextTask = _size;
    super.initState();
    for (var i = 0; i < _size; i++) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
      _shuffledLetters1.addAll(
          _allLetters1.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
    }
    _letters = _shuffledLetters.sublist(_nextTask);
    _letters1 = _shuffledLetters1.sublist(_nextTask);
  }

  Widget _buildItem(int index, String text) {
    //print(text);
    List<String> listTest;
    return new MyButton(
        key: new ValueKey<int>(index), text: text, onPress: () {});
  }

  @override
  Widget build(BuildContext context) {
    var _btHeight;
    var _btWidht;
    Size media = MediaQuery.of(context).size;
    _btHeight = (media.height) / 8;
    print(_btHeight);
    _btWidht = media.width;
    print(media);
    List<TableRow> rows = new List<TableRow>();
    List<Widget> cells;
    int j = 0;
    int j1 = _size;
    if (flag == 0) {
      for (var i = 0; i < _size; ++i) {
        cells =
            _letters.skip(i).take(1).map((e) => _buildItem(j++, e)).toList();
        rows.add(new TableRow(children: cells));
      }
      flag = 1;
    }
    // else {
    for (var i = 0; i < _size; ++i) {
      cells =
          _letters1.skip(i).take(1).map((e) => _buildItem(j1++, e)).toList();
      rows.add(new TableRow(children: cells));
    }
    //}
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
  String _displayText;
  int _default = 300;
  var _locationOfList = [];
  AnimationController controller;
  Animation<double> animationInvisible, animationShake, commonAnimation;

  initState() {
    super.initState();
    //print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);
    animationInvisible =
        new CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animationShake = new Tween(begin: 0.0, end: 4.0).animate(controller)
      ..addStatusListener((state) {
        commonAnimation = animationInvisible;
        // print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.forward();
    if (oldWidget.text != widget.text) {}

    // print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  // @override
  // // void _handleTouch() {
  // //   //print(widget.text);
  // //   controller.reverse();
  // // }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.all(9.0),
      child: new ScaleTransition(
        scale: animationInvisible,
        child: new Container(
          height: 60.0,
          width: 50.0,
          child: new RaisedButton(
            splashColor: Colors.green[600],
            onPressed: () => widget.onPress(),
            padding: new EdgeInsets.only(left: animationShake.value ?? 0),
            color: Colors.green[_default],
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.all(new Radius.circular(8.0))),
            child: new Text(_displayText,
                style: new TextStyle(color: Colors.white, fontSize: 30.0)),
          ),
        ),
      ),
    );
    // );
  }
}
