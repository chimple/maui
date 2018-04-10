import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/shaker.dart';

class CalculateTheNumbers extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  CalculateTheNumbers(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
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
  String _preValue = '';
  int num1,
      num2,
      num1digit1 = 0,
      num1digit2 = 0,
      num1digit3 = 0,
      num2digit1 = 0,
      num2digit2 = 0,
      num2digit3 = 0,
      ans1,
      ans2;
  int result;
  int check = 0, check1 = 0, carry1 = 0, carry2 = 0, carry3 = 0;
  String _output = '', _output1 = '', _output2 = '';
  String _operator = '';
  bool flag = false, flag1, flag2, carrry = false;
  bool shake1 = true, shake2 = true, shake3 = true, shake4 = true;
  Animation animationShake, animation;
  AnimationController animationController;
  Tuple4<int, String, int, int> data;
  bool _isLoading = true;
  String options;

  @override
  void initState() {
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animationShake =
        new Tween(begin: -6.0, end: 6.0).animate(animationController);
    animation = new Tween(begin: 0.0, end: 0.0).animate(animationController);
    _myAnim();
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
    if (num1 % 10 == num1 && num2 % 10 == num2) {
      num1digit1 = num1 % 10;
      num2digit1 = num2 % 10;
      options = 'singleDigit';
      /*  if (calCount(num1 + num2) > 1) {
        carrry = true;
      } */
    } else if ((calCount(num1) <= 2 && calCount(num2) <= 2) &&
        (calCount(num1 + num2) == 2 || calCount(num1 + num2) == 3)) {
      options = 'doubleDigitWithoutCarry';
      num1digit1 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit2 = num1 % 10;
      num2digit1 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit2 = num2 % 10;
    } else {
      options = 'tripleDigitWithoutCarry';
      num1digit3 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit2 = num1 % 10;
      num1 = num1 ~/ 10;
      num1digit1 = num1 % 10;
      num2digit3 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit2 = num2 % 10;
      num2 = num2 ~/ 10;
      num2digit1 = num2 % 10;
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

  @override
  void didUpdateWidget(CalculateTheNumbers oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  void _myAnim() {
    animationShake.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
    animationController.forward();
  }

  void wrongOrRight(String text, String output, int sum) {
    print("output value");
    print(output);
    print("sum value");
    print(sum);
    if (text == '✔') {
      if (int.parse(output) == sum) {
        setState(() {
          flag == true;
        });
        widget.onScore(1);
        widget.onProgress(1.0);
        new Future.delayed(const Duration(milliseconds: 1000), () {
          _output = '';
          flag = false;
          widget.onEnd();
        });
      } else {
        setState(() {
          shake1 = false;
        });
        print("Entering wrong data");
        new Future.delayed(const Duration(milliseconds: 900), () {
          setState(() {
            _output = "";
            flag = false;
            shake1 = true;
          });
        });
      }
    }
    if (text == '✖') {
      print("Erasing content: " + output);
      if (_output.length > 0) {
        setState(() {
          _output = _output.substring(0, _output.length - 1);
          flag = false;
        });
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

  void operation( String text) {
       print('$result');
    if (_zeoToNine(text) == true) {
      if (_output.length < 2) {
        print("output is printing");
        setState(() {
          _output = _output + text;
        });
      }
    } else if (text == '✔') {
      if (int.parse(_output) == result) {
        setState(() {
          flag = true;
        });
      } else {
        setState(() {
          shake1 = false;
        });
        print("Entering wrong data");
        new Future.delayed(const Duration(milliseconds: 900), () {
          setState(() {
            _output = "";
            flag = false;
            shake1 = true;
          });
        });
      }
    } else if (text == '✖') {
      print("Erasing content: " + _output);
      if (_output.length > 0) {
        setState(() {
          _output = _output.substring(0, _output.length - 1);
          flag = false;
        });
      }
    }
  }

  Widget _buildItem(int index, String text, double _height, String _options) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        height: _height,
        onPress: () {
          switch (_options) {
            case 'singleDigit':
              operation(text);
              if (text == '✔') {
                if (int.parse(_output) == result) {
                  widget.onScore(1);
                  widget.onProgress(1.0);
                  new Future.delayed(const Duration(milliseconds: 1000), () {
                    _output = '';
                    flag = false;
                    widget.onEnd();
                  });
                }
              }
              break;
            case 'doubleDigitWithoutCarry':
              if (text == '✔') {
                print("data is coming");
                if (int.parse(_output) == (num1digit1 + num2digit1)) {
                  setState(() {
                    flag = true;
                    check = 1;
                    print(calCount(num1digit1 + num2digit1));
                    if (calCount(num1digit1 + num2digit1) > 1) {
                      carry2 = 1;
                      _output = (int.parse(_output) % 10).toString();
                    }
                  });
                } else {
                  if (check != 1) {
                    setState(() {
                      shake1 = false;
                    });
                    new Future.delayed(const Duration(milliseconds: 900), () {
                      setState(() {
                        shake1 = true;
                      });
                    });
                  }
                }
                if (int.parse(_output1) == (num1digit2 + num2digit2 + carry2)) {
                  if (calCount(num1digit2 + num2digit2 + carry2) > 1) {
                    carry3 = 1;
                    _output1 = (int.parse(_output1) % 10).toString();
                    flag2 = true;
                  }
                  setState(() {
                    flag1 = true;
                    check1 = 1;
                    if (flag2 == true) {
                      _output2 = carry3.toString();
                    }
                  });
                } else {
                  setState(() {
                    shake2 = false;
                  });
                  new Future.delayed(const Duration(milliseconds: 900), () {
                    setState(() {
                      shake2 = true;
                    });
                  });
                }
                setState(() {
                  _preValue = _output2 + _output1 + _output;
                });
                print("final output value");
                print(_preValue);
                print(result);
                if (int.parse(_preValue) == result) {
                  print("Given result..");
                  print(result);
                  widget.onScore(1);
                  widget.onProgress(1.0);
                  new Future.delayed(const Duration(milliseconds: 1000), () {
                    _output = '';
                    _output1 = '';
                    _output2 = '';
                    check = 0;
                    check1 = 0;
                    flag = false;
                    flag1 = false;
                    flag2 = false;
                    carry1 = 0;
                    carry2 = 0;
                    carry3 = 0;
                    widget.onEnd();
                  });
                }
              }
              if (_output1.length < 2 && text != '✔') {
                if (check == 1 && check1 == 0) {
                  setState(() {
                    _output1 = _output1 + text;
                  });
                }
              }
              if (_output.length < 2) {
                if (check == 0) {
                  setState(() {
                    _output = _output + text;
                  });
                }
              }
              if (text == '✖') {
                print("erasing the data");
                if (check == 0) {
                  setState(() {
                    _output = '';
                    flag = false;
                  });
                }
                if (check == 1) {
                  setState(() {
                    _output1 = '';
                    flag1 = false;
                    check1 = 0;
                  });
                }
              }
              break;
           
          }
        });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget displayContainer(double _height, String num, int carry, Key _key) {
    return new Container(
      key: _key,
      child: new Center(
          child: new Text(num,
              style: new TextStyle(
                color: carry == 0 ? Colors.limeAccent : Colors.black,
                fontSize: _height * 0.09,
              ))),
    );
  }

  Widget displayShake(
      double _height, String output, bool _flag, bool _shake, Key _key) {
    return new Shake(
        key: _key,
        animation: _shake == false ? animationShake : animation,
        child: new Container(
          color: _flag == true ? Colors.green : Colors.red,
          height: _height * 0.1,
          width: _height * 0.1,
          child: new Center(
              child: new Text(output,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: _height * 0.09,
                  ))),
        ));
  }

  Widget displayTable(double _height, String _options) {
    int j = 0;
    List<TableRow> rows = new List<TableRow>();
    for (var i = 0; i < _size + 1; ++i) {
      List<Widget> cells = _numbers
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e, _height, _options))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    return new Table(children: rows);
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
    switch (options) {
      case 'singleDigit':
        return new LayoutBuilder(builder: (context, constraints) {
          return new Container(
            color: new Color(0XFFFFF7EBCB),
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Table(
                    defaultColumnWidth: new FractionColumnWidth(0.25),
                    children: <TableRow>[
                      new TableRow(children: <Widget>[
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(
                                constraints.minHeight, ' ', 1, new Key(''))),
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(
                                constraints.minHeight, ' ', 1, new Key(''))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(
                                constraints.minHeight, ' ', 1, new Key(''))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                "$num1", 1, new Key('num1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                _operator, 1, new Key('_operator'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                "$num2", 1, new Key('num2'))),
                      ]),
                      new TableRow(children: <Widget>[
                        displayShake(constraints.minHeight, _output1, flag1,
                            shake1, new Key('shake')),
                        displayShake(constraints.minHeight, _output, flag,
                            shake1, new Key('shake1')),
                      ]),
                    ],
                  ),
                ),
                new Expanded(
                  child: new Container(
                    child: displayTable(constraints.minHeight, 'singleDigit'),
                  ),
                )
              ],
            ),
          );
        });
        break;

      case 'doubleDigitWithoutCarry':
        return new LayoutBuilder(builder: (context, constraints) {
          return new Container(
            color: new Color(0XFFFFF7EBCB),
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Table(
                    defaultColumnWidth: new FractionColumnWidth(0.2),
                    children: <TableRow>[
                      new TableRow(children: <Widget>[
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry3', carry3, new Key('carry3'))),
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry2', carry2, new Key('carry2'))),
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry1', carry1, new Key('carry1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(
                                constraints.minHeight, ' ', 1, new Key(''))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num1digit2', 1, new Key('num1digit2'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num1digit1', 1, new Key('num1digit1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                _operator, 1, new Key('_operator'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num2digit2', 1, new Key('num2digit2'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num2digit1', 1, new Key('num2digit1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                          child: displayShake(constraints.minHeight, _output2,
                              flag2, true, new Key('')),
                        ),
                        new Container(
                          child: displayShake(constraints.minHeight, _output1,
                              flag1, shake2, new Key('shake2')),
                        ),
                        new Container(
                          child: displayShake(constraints.minHeight, _output,
                              flag, shake1, new Key('shake1')),
                        ),
                      ]),
                    ],
                  ),
                ),
                new Expanded(
                  child: new Container(
                    child: displayTable(
                        constraints.minHeight, 'doubleDigitWithoutCarry'),
                  ),
                )
              ],
            ),
          );
        });
        break;
      case 'tripleDigitWithoutCarry':
        return new LayoutBuilder(builder: (context, constraints) {
          return new Container(
            color: new Color(0XFFFFF7EBCB),
            child: new Column(
              children: <Widget>[
                new Expanded(
                  child: new Table(
                    defaultColumnWidth: new FractionColumnWidth(0.2),
                    children: <TableRow>[
                      new TableRow(children: <Widget>[
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry3', carry3, new Key('carry3'))),
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry3', carry3, new Key('carry3'))),
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry2', carry2, new Key('carry2'))),
                        new Container(
                            color: Colors.limeAccent,
                            child: displayContainer(constraints.minHeight,
                                '$carry1', carry1, new Key('carry1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(
                                constraints.minHeight, ' ', 1, new Key(''))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num1digit3 ', 1, new Key('num1digit3'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num1digit2', 1, new Key('num1digit2'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num1digit1', 1, new Key('num1digit1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                _operator, 1, new Key(''))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num2digit3', 1, new Key('num2digit3'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num2digit2', 1, new Key('num2digit2'))),
                        new Container(
                            color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.minHeight,
                                '$num2digit1', 1, new Key('num2digit1'))),
                      ]),
                      new TableRow(children: <Widget>[
                        new Container(
                          child: displayShake(constraints.minHeight, _output2,
                              flag2, true, new Key('flag2')),
                        ),
                        new Container(
                          child: displayShake(constraints.minHeight, _output2,
                              flag2, true, new Key('flag2')),
                        ),
                        new Container(
                          child: displayShake(constraints.minHeight, _output1,
                              flag1, shake2, new Key('flag1')),
                        ),
                        new Container(
                          child: displayShake(constraints.minHeight, _output,
                              flag, shake1, new Key('flag1')),
                        ),
                      ]),
                    ],
                  ),
                ),
                new Expanded(
                  child: new Container(
                    child: displayTable(
                        constraints.minHeight, 'tripleDigitWithoutCarry'),
                  ),
                )
              ],
            ),
          );
        });
        break;
      default:
        return new Container();
        break;
    }
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.height, this.onPress}) : super(key: key);
  final String text;
  bool flag;
  double height;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  String _displayText;
  AnimationController controller;
  Animation<double> animation;
  // double _height;

  @override
  initState() {
    super.initState();
    _displayText = widget.text;

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
  }

  @override
  Widget build(BuildContext context) {
    return new TableCell(
        child: new Padding(
            padding: new EdgeInsets.all(widget.height * 0.01),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: new EdgeInsets.all(widget.height * 0.02),
                    color: Colors.orangeAccent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(widget.height * 0.09))),
                    child: new Text(_displayText,
                        key: new Key('keyPad'),
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: widget.height * 0.05))))));
  }
}
