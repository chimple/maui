import 'package:flutter/material.dart';
import 'dart:async';

class CalculateTheNumbers extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  CalculateTheNumbers(
      {key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new _CalculateTheNumbersState();
}

class _CalculateTheNumbersState extends State<CalculateTheNumbers> {
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
  int num1 = 5, num2 = 12;
  String _output = ' ';
  String _operator = '*';
  bool flag;

  @override
  void didUpdateWidget(CalculateTheNumbers oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    _numbers = _allNumbers.sublist(0, _size * (_size + 1));
    num1;
    num2;
    _operator;
  }

  void wrongOrRight(String text, String output, sum) {
    if (text == '✔') {
      try {
        if (int.parse(output) == sum) {
          setState(() {
            _output = output;
            print(_output);
            widget.onScore(2);
            widget.onProgress((num1 + num2) / 2);
            new Future.delayed(const Duration(milliseconds: 2000), () {
              _output = ' ';
              flag = false;
              widget.onEnd();
            });
          });
        } else {
          print("Entering wrong data");
          setState(() {
            _output = "✖";
            flag = false;
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

  void operation(String operator, String text) {
    switch (operator) {
      case '+':
        if (_zeoToNine(text) == true) {
          if (_output.length < 3) {
            _preValue = text;
            _output = _output + _preValue;
            print(_output);
            setState(() {
              if (int.parse(_output) == (num1 + num2)) {
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
        wrongOrRight(text, _output, (num1 + num2));
        break;
      case '-':
        if (_zeoToNine(text) == true) {
          if (_output.length < 3) {
            _preValue = text;
            _output = _output + _preValue;
            print(_output);
            setState(() {
              if (int.parse(_output) == (num1 - num2)) {
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
        wrongOrRight(text, _output, (num1 - num2));
        break;
      case '*':
        if (_zeoToNine(text) == true) {
          if (_output.length < 3) {
            _preValue = text;
            _output = _output + _preValue;
            print(_output);
            setState(() {
              if (int.parse(_output) == (num1 * num2)) {
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
        wrongOrRight(text, _output, (num1 * num2));
        break;
    }
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          operation(_operator, text);
        });
  }

  @override
  Widget build(BuildContext context) {
    double height1 = MediaQuery.of(context).size.height;
    double width1 = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    print(height1);
    print(width1);
    print(size);
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
    return new Expanded(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: new Container(
                color: Colors.pink,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            color: Colors.pink,
                            height: height1 / 18,
                            width: width1 / 7,
                            child: new Center(
                              child: new Text(" "),
                            )),
                        new Container(
                            color: Colors.lime,
                            height: height1 / 18,
                            width: width1 / 7,
                            child: new Center(
                              child: new Text('$num1',
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            ))
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            color: Colors.lime,
                            height: height1 / 18,
                            width: width1 / 7,
                            child: new Center(
                              child: new Text(_operator,
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            )),
                        new Container(
                            color: Colors.lime,
                            height: height1 / 18,
                            width: width1 / 7,
                            child: new Center(
                              child: new Text('$num2',
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 20.0)),
                            )),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            color: Colors.pink,
                            height: height1 / 18,
                            width: width1 / 7,
                            child: new Center(
                              child: new Text(""),
                            )),
                        new Container(
                            color: flag == true ? Colors.green : Colors.grey,
                            height: height1 / 18,
                            width: width1 / 7,
                            child: new Center(
                              child: new Output(flag: flag),
                              /* child: new Text(_output,
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 20.0)),*/
                            ) ),
                      ],
                    ),
                  ],
                ),
              )),
          new Expanded(
              //  flex: 1,
              child: new Container(
            padding: const EdgeInsets.all(5.0),
            color: Colors.pink,
            child: new Center(
              child: new Table(children: rows),
            ),
          ))
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

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  String _displayText;
  bool _flag;

  @override
  initState() {
    super.initState();
    _displayText = widget.text;
    _flag=widget.flag;
  }

  @override
  Widget build(BuildContext context) {
    return new TableCell(
    //  child: new Padding(
          // padding: new EdgeInsets.all(10.0),
        //  padding: _flag==true?new EdgeInsets.all(5.0):new EdgeInsets.all(10.0),
         // padding: new EdgeInsets.all(0.0),
          child: new RaisedButton(
              onPressed: () => widget.onPress(),
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(5.0))),
              child: new Center(
                  child: new Text(_displayText,
                      style: new TextStyle(
                          color: Colors.black, fontSize: 20.0)))),
    );
  }
}


class Output extends AnimatedWidget{
  Output({Key key, Animation animation, this.flag}) : super(key: key, listenable: animation);
   bool flag;

   @override
    Widget build(BuildContext context) {
    Animation animation = listenable;
    return new Center(
      child: new Container(
        margin: new EdgeInsets.only(left: animation.value ?? 0),
        
      ),
    );
    }
}

