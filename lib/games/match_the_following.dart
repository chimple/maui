import 'dart:async';

import 'package:flutter/material.dart';

class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;

  MatchTheFollowing({
    key,
    this.onScore,
    this.onProgress,
    this.onEnd,
    this.iteration,
    this.function,
  })
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

enum Status {
  ColorChange,
  Hidden,
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
  int c = 0;
  int start = 0, increament = 0;
  bool _next = false;
  final List<String> _leftSideletters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',

    'W',
    'X',
    'Y',
    'Z'
  ];
  final List<String> _rightSideLetters = [
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
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z',
  ];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  int indexText1, indexText2;
  int i = 0, flag1 = 0, flag2 = 0;
  int attem = 0;
  int _nextTask = 5;
  String text1, text2;
  bool _active = true;
  @override
  Widget build(BuildContext context) {
    print("parent build::");
    return new Expanded(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(
                  child: _buildLeftSide(context),
                ),
                new Padding(
                  padding: const EdgeInsets.all(100.0),
                ),
                new Expanded(child: _buildRightSide(context)),
              ],
            ),
          ]),
    );
  }

  @override
  void initState() {
    print("first initState method");
    super.initState();
    for (var i = 0; i < _size; i++) {
      _shuffledLetters.addAll(
          _allLetters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
      _shuffledLetters1.addAll(
          _allLetters1.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());

    for (var i = start; i < _leftSideletters.length; i++) {
      _shuffledLetters.addAll(
          _leftSideletters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
      _shuffledLetters1.addAll(
          _rightSideLetters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
    }
    _lettersLeft = _shuffledLetters.sublist(start, _nextTask + increament);
    _lettersRight = _shuffledLetters1.sublist(start, _nextTask + increament);
  }

  Widget _buildLeftSide(BuildContext context) {
    // print("_buildLeftSidde method::");
    int j = 0;
    flag1 = 1;
    List<TableRow> rows = new List<TableRow>();
    List<Widget> cells;
    for (var i = 0; i < _nextTask; ++i) {
      cells = _lettersLeft
          .skip(i)
          .take(1)
          .map((e) => _buildItemseft(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));

    }
    return new Table(children: rows);
  }

  Widget _buildItemseft(int index, String text) {
    // print("_Build Items Right::");
    return new MyButton(

        key: new ValueKey<int>(index), text: text, onPress: () {});

        key: new ValueKey<int>(index),
        text: text,
        active: _active,
        onPress: () {
          color(index);
          indexText1 = _lettersLeft.indexOf(text);
          text1 = text;
          print("Left Index:: $indexText1");
          //setState(() {});
        });

  }

  void color(int getText) {
    // if (getText==1){
    //   setState((){
    //     _active=false;
    //   });
    // }
  }
  Widget _buildRightSide(BuildContext context) {
    // print("Build Right side::");
    int j = 5;
    flag2 = 1;
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

    for (var i = start; i < _nextTask + increament; ++i) {
      cells = _lettersRight
          .skip(i)
          .take(1)
          .map((e) => _buildItemsRight(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }

    return new Table(children: rows);
  }

  Widget _buildItemsRight(int index, String text) {
    // print("BuildIteme ::");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          indexText2 = _lettersRight.indexOf(text);
          text2 = text;
          print("Right Index:: $indexText2");
          if (_leftSideletters.indexOf(text1) ==_rightSideLetters.indexOf(text2)) {
            setState(() {
              _lettersLeft[indexText1] = '';
              _lettersRight[indexText2] = '';
            });
            print("match::");
            attem++;
            widget.onScore(attem);
            widget.onProgress(attem/5);
          }
          if (attem == 5) {
            print("change::");
            //new Future.delayed(const Duration(milliseconds: 250), () {});
            attem = 0;
            _next = true;
            setState((){
              _lettersLeft = _shuffledLetters.sublist(5,10);
              _lettersRight = _shuffledLetters1.sublist(5, 10);
            });
           print("left:: $_lettersLeft");
           print("right:: $_lettersRight");
          }
          if (_next == true) {
            _next = false;
          }
        });
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text,
    this.onPress,
    this.active: true,
    this.status,
  })
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  bool active;
  Status status;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;

  int _default = 300;
  var _locationOfList = [];
  AnimationController controller;
  Animation<double> animationInvisible, animationShake, commonAnimation;

  int _default = 600;
  AnimationController controller, controller1;
  Animation<double> animationInvisible, commonAnimation, animationShake;


  initState() {
    // print("2nd initState::");
    super.initState();
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

        duration: new Duration(milliseconds: 400), vsync: this);
    animationInvisible =
        new CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animationShake = new Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.dismissed) {
        if (widget.text == null) {
          setState(() => _displayText = widget.text);

          controller.forward();
        }
      }
    });
    // controller1.addStatusListener((state1) {
    //   if (state1 == AnimationStatus.dismissed) {
    //     if (widget.text == null) {
    //       controller.forward();
    //     }
    //   }
    // });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    controller.forward();
    if (oldWidget.text != widget.text) {}

    if (oldWidget.text != widget.text) {
      controller.reverse();
    } else {}
    //print("didUpadataeWidget::");
  }

  void shake() {
    print("Shake Button is pressed:");
    controller1.addStatusListener((state) {
      if (state == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Child Build method");
    Size media = MediaQuery.of(context).size;
    double _height, _width;
    _height = media.height / 18;
    _width = media.width / 20;
    return new Padding(
      padding: new EdgeInsets.all(5.0),
      child: new ScaleTransition(
        scale: animationInvisible,
        child: new Container(
            decoration: new BoxDecoration(
              color: widget.active ? Colors.green[400] : Colors.green[600],
            ),
            height: _height,
            width: _width,
            child: new RaisedButton(
                elevation: 8.0,
                splashColor: Colors.red,
                
                //splashColor: Colors.green[_default],
                onPressed: () => widget.onPress(),
                padding: new EdgeInsets.only(left: animationShake.value ?? 0),
                color: widget.active ? Colors.green[600] : Colors.green[400],
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text(_displayText,
                    style:
                        new TextStyle(color: Colors.white, fontSize: 30.0)))),
      ),
    );
  }
}
