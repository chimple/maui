import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';

class CalculateTheNumbers extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  CalculateTheNumbers(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _CalculateTheNumbersState();
}

class _CalculateTheNumbersState extends State<CalculateTheNumbers>
    with SingleTickerProviderStateMixin {
  final List<String> _allNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '✖',
    '0',
    '✔'
  ];

  final int _size = 3;
  List<String> _numbers;
  String _preValue = ' ';
  int num1, num2;
  int result;
  String _output = ' ';
  String _operator = '';
  bool flag;
  Animation animation;
  AnimationController animationController;
  Tuple4<int, String, int, int> data;
  bool _isLoading = true;

  @override
  void initState() {
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 20.0).animate(animationController);
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _numbers = _allNumbers.sublist(0, _size * (_size + 1));
    data = await fetchMathData(widget.gameCategoryId);
    print(data);
    num1 = data.item1;
    num2 = data.item3;
    result = data.item4;
    _operator = data.item2;
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(CalculateTheNumbers oldWidget) {
   // print(oldWidget.iteration);
  //  print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  void _myAnim() {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
    print('Pushed the Button');
  }

  void wrongOrRight(String text, String output, sum) {
    if (text == '✔') {
      try {
        if (int.parse(output) == result) {
          setState(() {
            _output = output;
          });
          widget.onScore(1);
          widget.onProgress(1.0);
          if (int.parse(output) == sum) {
            new Future.delayed(const Duration(milliseconds: 1000), () {
              _output = ' ';
              flag = false;
              widget.onEnd();
            });
          }
        } else {
          _myAnim();
          print("Entering wrong data");
          new Future.delayed(const Duration(milliseconds: 700), () {
            setState(() {
              _output = " ";
              flag = false;
            });
            animationController.stop();
          });
        }
      } on FormatException {}
    }
    if (text == '✖') {
      print("Erasing content: " + output);
      if (_output.length > 0) {
        try {
          setState(() {
            _output = _output.substring(0, _output.length - 1);
            flag = false;
          });
        } on FormatException {}
      }
    }
  }

  bool _zeoToNine(String text) {
    if (text == '1' ||
        text == '2' ||
        text == '3' ||
        text == '4' ||
        text == '5' ||
        text == '6' ||
        text == '7' ||
        text == '8' ||
        text == '9' ||
        text == '0') {
      return true;
    } else
      return false;
  }

  void operation(String text) {
    if (_zeoToNine(text) == true) {
      if (_output.length < 3) {
        _preValue = text;
        _output = _output + _preValue;
        print(_output);
        setState(() {
          if (int.parse(_output) == result) {
            _output;
            flag = true;
            print("OUTPUT: " + _output);
          }
        });
      } else {
        setState(() {
          flag = false;
        });
      }
    }
    wrongOrRight(text, _output, result);
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          operation(text);
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _displayContainer(String text, Color color, Key key) {
    return new Container(
        color: color,
        height: 50.0,
        width: 50.0,
        child: new Center(
          child: new Text(text,
              key: key,
              style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        ));
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
    List<TableRow> rows = new List<TableRow>();
    var j = 0;
    for (var i = 0; i < _size + 1; ++i) {
      List<Widget> cells = _numbers
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e))
          .toList();
      rows.add(new TableRow(children: cells));
    }
   
    return new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                  child: new Container(
                color: Colors.pink,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _displayContainer(" ", Colors.pink, new Key(' ')),
                        _displayContainer('$num1', Colors.lime, new Key('num1')),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _displayContainer(
                            _operator, Colors.lime, new Key('_operator')),
                        _displayContainer('$num2', Colors.lime, new Key('num2')),
                      ],
                    ),
                    new Container(
                      height: 10.0,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _displayContainer(" ", Colors.pink, new Key(' ')),
                        new Container(
                          key: new Key('_outout'),
                          child: new TextAnimation(
                              animation: animation, text: _output, flag: flag),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              new Container(
               color: Colors.pink, child: new Table(children: rows))
            ],
          ),
    );
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);
  final String text;
  bool flag;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    _displayText = widget.text;
    //  print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        // print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          //  print('dismissed');
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
    // print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  @override
  Widget build(BuildContext context) {
    return new TableCell(
        child: new Padding(
            padding: const EdgeInsets.all(8.0),
      child: new ScaleTransition(
        scale: animation,
        child: new RaisedButton(
            onPressed: () => widget.onPress(),
            color: Colors.lime,
            shape: new RoundedRectangleBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(2.0))),
            child: new Container(
              child: new Center(
                  child: new Text(_displayText,
                      style:
                          new TextStyle(color: Colors.black, fontSize: 20.0))),
       ) )),
      ),
    );
  }
}

class TextAnimation extends AnimatedWidget {
  TextAnimation({Key key, Animation animation, this.text, this.flag})
      : super(key: key, listenable: animation);
  final String text;
  final bool flag;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return new Center(
      child: new Container(
          height: 50.0,
          width: 70.0,
          alignment: Alignment.center,
          margin:
              new EdgeInsets.only(right: animation.value ?? 0, bottom: 20.0),
          child: new Text(text,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
          color: flag == true ? Colors.green : Colors.grey),
    );
  }
}
