import 'dart:async';

import 'package:flutter/material.dart';

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
    '✖',
    '0',
    '✔'
  ];

  final int _size = 3;
  List<String> _letters;
  String _preValue = ' ';
  int num1 =14, num2 = 2;
  String _output = ' ';
  String _operator = '-';
  List<num> reminder = [];
  int index = 0;
  bool flag;

  void reminderS(sum) {
    while (sum != 0) {
      num rem = sum % 10;
      sum = sum ~/ 10;
      reminder.add(rem);
    }
  }

  int calCount(sum) {
    print(sum);
    int count = 0;
    if (sum > 1) {
      while (sum != 0) {
        sum = sum ~/ 10;
        ++count;
      }
      return count;
    } else {
      return count = 1;
    }
  }

  void reminderForOperator(String operator){
    switch(operator){
      case '+': reminderS(num1+num2);
      break;
      case '-': reminderS(num1-num2);
      break;
      
    }

  }

  @override
  void initState() {
    super.initState();
    //reminderS(num1 + num2);
    reminderForOperator(_operator);
    _letters = _allLetters.sublist(0, _size * (_size + 1));
  }

  void operation(String operator, String text) {
    switch (operator) {
      case '+':
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
          if (calCount(num1 + num2) == 1) {
            if (int.parse(text) == (num1 + num2)) {
              print(text);
              setState(() {
                _output = text;
                flag = true;
                print("OUTPUT: " + text);
              });
            } else {
              setState(() {
                _output = text;
                flag = false;
              });
            }
          } else {
            if (int.parse(text) == reminder[1] ||
                int.parse(text) == reminder[0]) {
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
                _preValue = text;
                _output = _output + _preValue;
                flag = false;
              });
            }
          }
        }
        if (text == '✔') {
          try {
            if (int.parse(_output) == (num1 + num2)) {
              setState(() {
                _output;
                print(_output);
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
          print("Erasing content: " + _output);
          try {
            setState(() {
              _preValue = " ";
              _output = " ";
              flag = false;
            });
          } on FormatException {}
        }
        break;
      ////////////////////////////////////
      case '-':
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
          if (calCount(num1 - num2) == 1) {
            if (int.parse(text) == (num1 - num2)) {
              print(text);
              setState(() {
                _output = text;
                flag = true;
                print("OUTPUT: " + text);
              });
            } else {
              setState(() {
                _output = text;
                flag = false;
              });
            }
          } else {
            if (int.parse(text) == reminder[1] ||
                int.parse(text) == reminder[0]) {
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
                _preValue = text;
                _output = _output + _preValue;
                flag = false;
              });
            }
          }
        }
        if (text == '✔') {
          try {
            if (int.parse(_output) == (num1 - num2)) {
              setState(() {
                _output;
                print(_output);
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
          print("Erasing content: " + _output);
          try {
            setState(() {
              _preValue = " ";
              _output = " ";
              flag = false;
            });
          } on FormatException {}
        }
        break;
    }
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          operation(_operator, text);
          /*  if (text == '1' ||
              text == '2' ||
              text == '3' ||
              text == '4' ||
              text == '5' ||
              text == '6' ||
              text == '7' ||
              text == '8' ||
              text == '9' ||
              text == '0') {
            if (calCount(num1 + num2) == 1) {
              if (int.parse(text) == (num1 + num2)) {
                print(text);
                setState(() {
                  _output = text;
                  flag = true;
                  print("OUTPUT: " + text);
                });
              } else {
                setState(() {
                  _output = text;
                  flag = false;
                });
              }
            } else {
              if (int.parse(text) == reminder[1] ||
                  int.parse(text) == reminder[0]) {
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
                  _preValue = text;
                  _output = _output + _preValue;
                  flag = false;
                });
              }
            }
          }
          if (text == '✔') {
            try {
              if (int.parse(_output) == (num1 + num2)) {
                setState(() {
                  _output;
                  print(_output);
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
            print("Erasing content: " + _output);
            try {
              setState(() {
                _preValue = " ";
                _output = " ";
                flag = false;
              });
            } on FormatException {} */
          //}
        });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
        color: Colors.pink,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    color: Colors.orange,
                    height: height / 19,
                    width: width / 11,
                    child: new Center(
                        child: new Text("$num1",
                            style: new TextStyle(
                                color: Colors.black, fontSize: 20.0))))
              ],
            ),
            //  new Padding(padding: const EdgeInsets.only(top: 30.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(padding: const EdgeInsets.only(left: 150.0)),
                new Container(
                    color: Colors.orange,
                    height: height / 19,
                    width: width / 11,
                    child: new Center(
                        child: new Text(_operator,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 20.0)))),
                // new Padding(padding: const EdgeInsets.only(left: 40.0)),
                new Container(
                    color: Colors.orange,
                    height: height / 19,
                    width: width / 11,
                    child: new Center(
                        child: new Text("$num2",
                            style: new TextStyle(
                                color: Colors.black, fontSize: 20.0))))
              ],
            ),
            // new Padding(padding: const EdgeInsets.only(top: 50.0)),
            new Container(
                color: flag == true ? Colors.green : Colors.grey,
                height: height / 19,
                width: width / 11,
                child: new Center(
                    child: new Text("$_output",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        )))),
            // new Padding(padding: const EdgeInsets.only(top: 50.0)),
            new Table(children: rows),
          ],
        ));
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);
  final String text;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  String _displayText;

  @override
  initState() {
    super.initState();
    _displayText = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return new TableCell(
      child: new Padding(
          // padding: new EdgeInsets.all(10.0),
          padding: new EdgeInsets.all(0.0),
          child: new RaisedButton(
              onPressed: () => widget.onPress(),
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(5.0))),
              child: new Center(
                  child: new Text(_displayText,
                      style: new TextStyle(
                          color: Colors.black, fontSize: 20.0))))),
    );
  }
}
