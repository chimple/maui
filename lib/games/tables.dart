import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';

class Tables extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Tables({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TablesState();
}

class _TablesState extends State<Tables> {
  final int _size = 3;
  String str = "";
  final List<String> _allLetters = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '<-',
      '0',
      'X'
  ];
  List<String> _letters;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    _letters = _allLetters.sublist(0, _size * (_size + 1));
    var i = 2;
    var j = 3;
    str= "$i X $j";
  }

  Widget _buildItem(int index, String text) {
    print('_buildItem: $text');
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
        });
  }

  Widget subTile = new Container (
    padding: new EdgeInsets.all(45.0),
    alignment: Alignment.center,
    color: new Color(0X00000000),
    child: new Text(
      "$str",
      style: new TextStyle(
        fontSize: 60.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        decorationStyle: TextDecorationStyle.wavy,
      ),
    ),
  );

  @override
  void didUpdateWidget(Tables oldWidget) {
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    List<TableRow> rows = new List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size + 1; ++i) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }

    return new Container(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container (
            padding: new EdgeInsets.all(45.0),
            alignment: Alignment.center,
            color: new Color(0X00000000),
            child: new Text(
              '$str',
              style: new TextStyle(
                fontSize: 60.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decorationStyle: TextDecorationStyle.wavy,
              ),
            ),
            ),
            new Table(children: rows),
          ]
    ),
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
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          print('dismissed');
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

