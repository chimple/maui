import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/components/responsive_grid_view.dart';

class MatchTheFollowing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  MatchTheFollowing({
    key,
    this.onScore,
    this.onProgress,
    this.onEnd,
    this.iteration,
    this.function,
    this.gameCategoryId,
  })
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _MatchTheFollowingState();
}

enum Status { Disable, Enable, ShakeLeft, Stopped0 }
enum StatusShake { Stopped, ShakeRight }

class _MatchTheFollowingState extends State<MatchTheFollowing>
    with SingleTickerProviderStateMixin {
  int c = 0;
  int start = 0, increament = 0;
  final List<String> _leftSideletters = [];
  final List<String> _rightSideLetters = [];
  List<String> _lettersLeft = [], _lettersRight = [];
  List<String> _shuffledLetters = [], _shuffledLetters1 = [];
  List<Status> _statusColorChange;
  List<StatusShake> _statusShake;
  Map<String, String> _allLetters;
  String _leftSideText, _rightSideText;
  int indexText1, indexText2, indexLeftButton;
  int attem = 0,
      i = 0,
      _oldIndexforLeftButton = 0,
      _oldIndexforRightButton = 0,
      _nextTask = 5,
      flag2 = 0;
  bool _isLoading = true;
  int indexL, flag = 0, flag1 = 0;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    return new Expanded(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: _buildLeftSide(context),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(35.0),
                  ),
                  new Expanded(child: _buildRightSide(context)),
                ],
              ),
            ),
          ]),
    );
  }

  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _allLetters = await fetchPairData(widget.gameCategoryId, 5);
    _allLetters.forEach((k, v) {
      _leftSideletters.add(k);
      _rightSideLetters.add(v);
    });
    print("first initState method");
    for (var i = start; i < _leftSideletters.length; i++) {
      _shuffledLetters.addAll(
          _leftSideletters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
      _shuffledLetters1.addAll(
          _rightSideLetters.skip(i).take(_nextTask).toList(growable: false)
            ..shuffle());
    }
    _lettersLeft = _shuffledLetters.sublist(start, _nextTask);
    _lettersRight = _shuffledLetters1.sublist(start, _nextTask);
    _statusColorChange =
        _shuffledLetters.map((a) => Status.Disable).toList(growable: false);
    _statusShake = _shuffledLetters1
        .map((e) => StatusShake.Stopped)
        .toList(growable: false);
    setState(() => _isLoading = false);
  }

  Widget _buildLeftSide(BuildContext context) {
    int j = 0;
    return new ResponsiveGridView(
      rows: 1,
      cols: 5,
      children: _lettersLeft
          .map((e) => _buildItemsLeft(j, e, _statusColorChange[j++]))
          .toList(growable: false),
    );
  }

  Widget _buildItemsLeft(int index, String text, Status colorstatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        colorstatus: colorstatus,
        onPress: () {
          indexText1 = _lettersLeft.indexOf(text);
          _leftSideText = text;
          if (_statusColorChange[index] != Status.Enable) {
            setState(() {
              _statusColorChange[index] = Status.Enable;
            });
            flag = 1;
          }
          if (_oldIndexforLeftButton != index && flag == 1) {
            _statusColorChange[_oldIndexforLeftButton] = Status.Disable;
            flag = 0;
          }
          _oldIndexforLeftButton = index;
          indexLeftButton = index;
          flag2 = 1;
        });
  }

  Widget _buildRightSide(BuildContext context) {
    int j = 5;
    return new ResponsiveGridView(
      rows: 1,
      cols: 5,
      children: _lettersRight
          .map((e) => _buildItemsRight(j, e, _statusShake[j++]))
          .toList(growable: false),
    );
  }

  Widget _buildItemsRight(int index, String text, StatusShake shakestatus) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        shakestatus: shakestatus,
        onPress: () {
          indexText2 = _lettersRight.indexOf(text);
          _rightSideText = text;
          match(index);
        });
  }

  void match(int indexRightbutton) {
    _MyButtonState ob;
    int score = 2;
    if (_leftSideletters.indexOf(_leftSideText) ==
        _rightSideLetters.indexOf(_rightSideText)) {
      setState(() {
        _lettersLeft[indexText1] = '';
        _lettersRight[indexText2] = '';
      });
      attem++;
      widget.onScore(score);
      widget.onProgress(attem / 5);
      score = score + 2;
    } else {
      if (flag2 == 1) {
        if (_statusShake[indexRightbutton] != StatusShake.ShakeRight) {
          setState(() {
            _statusShake[indexRightbutton] = StatusShake.ShakeRight;
            _statusColorChange[indexLeftButton] = Status.ShakeLeft;
            flag1 = 1;
          });
          new Future.delayed(const Duration(milliseconds: 1500), () {
            setState(() {
              _statusShake[indexRightbutton] = StatusShake.Stopped;
              _statusColorChange[indexLeftButton] = Status.Enable;
            });
            ob.stop();
          });
        }

        flag2 = 0;
      }
    }
    _oldIndexforRightButton = indexRightbutton;
    if (attem == 5) {
      attem = 0;
      _initBoard();
      setState(() {});
    }
  }
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text,
    this.onPress,
    this.active: true,
    this.colorstatus,
    this.shakestatus,
    this.shake,
  })
      : super(key: key);
  final String text;
  final VoidCallback onPress;
  bool active;
  Status colorstatus;
  StatusShake shakestatus;
  Animation shake;
  int flag = 0;
  @override
  createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller, controller1;
  Animation animationInvisible, animationShake;
  initState() {
    super.initState();
    initStateData();
  }

  initStateData() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(microseconds: 10), vsync: this);
    animationInvisible =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animationShake = new Tween(begin: 0.0, end: 4.0).animate(controller1);
    controller.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        if (widget.text == null) {
          setState(() => _displayText = widget.text);
        }
      }
    });
    controller.forward();
    shake();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    } else if (widget.shakestatus == StatusShake.ShakeRight ||
        widget.colorstatus == Status.Enable) {}
  }

  void shake() {
    animationShake.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  void stop() {
    controller1.stop();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return new Shake(
        key: widget.key,
        animation: (widget.colorstatus == Status.ShakeLeft ||
                widget.shakestatus == StatusShake.ShakeRight)
            ? animationShake
            : animationInvisible,
        child: new ScaleTransition(
            scale: animationInvisible,
            key: widget.key,
            child: new RaisedButton(
                elevation: 5.0,
                splashColor: Colors.red,
                onPressed: () => widget.onPress(),
                color: (widget.colorstatus == Status.Enable ||
                        widget.colorstatus == Status.ShakeLeft)
                    ? Colors.yellow[300]
                    : new Color(0xFFed4a79),
                shape: new RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8.0))),
                child: new Text(_displayText,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 25.0,
                        fontStyle: FontStyle.italic)))));
  }
}
