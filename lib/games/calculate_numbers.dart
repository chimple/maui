import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/shaker.dart';
import 'dart:math';

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
  String _preValue = '', _finalResult;
  int _num1,
      _num2,
      _num1digit1 = 0,
      _num1digit2 = 0,
      _num1digit3 = 0,
      _num2digit1 = 0,
      _num2digit2 = 0,
      _num2digit3 = 0;
  int _result;
  int _tempf = 0, _tempf1 = 0;
  String _arrow = '⤵';
  String _operator = '';
  bool _carryFlag, _carryFlag1;
  Animation _animationShake, _animation;
  AnimationController _animationController;
  Tuple4<int, String, int, int> _data;
  bool _isLoading = true;
  String _options;
  int _scoreCount = 0;
  List<int> _num1List = [];
  List<int> _num2List = [];
  List<String> _outputList = [];
  List<bool> _flag = [];
  List<bool> _shake = [];
  List<int> _carry = [];
  List<int> cf = [];
  List<bool> _barrowFlag = [];
  List<bool> _numbershake = [];
  int _j1;
  int _i = 0;

  @override
  void initState() {
    _animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    _animationShake =
        new Tween(begin: -6.0, end: 6.0).animate(_animationController);
    _animation = new Tween(begin: 0.0, end: 0.0).animate(_animationController);
    _myAnim();
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _numbers = _allNumbers.sublist(0, _size * (_size + 1));
    _data = await fetchMathData(widget.gameCategoryId);
    print(_data);
    _num1 = _data.item1;
    _num2 = _data.item3;
    _result = _data.item4;
    _operator = _data.item2;
    _scoreCount = 0;
    setState(() => _isLoading = false);
    _outputList.clear();
    print("printing output list....$_outputList");
    _tempf = 0;
    _tempf1 = 0;
    _carryFlag = false;
    _carryFlag1 = false;
    _flag.clear();
    _shake.clear();
    _i = 0;
    _j1 = 0;
    _preValue = '';
    _barrowFlag.clear();
    cf.clear();
    _carry.clear();
    _num1List.clear();
    _num2List.clear();
    cf.clear();
    if (_num1 % 10 == _num1 && _num2 % 10 == _num2) {
      _num1digit1 = _num1 % 10;
      _num2digit1 = _num2 % 10;
      _num1List.add(_num1digit1);
      _num2List.add(_num2digit1);
      _options = 'singleDigit';
    } else if ((calCount(_num1) <= 2 && calCount(_num2) <= 2) &&
        (calCount(_num1 + _num2) == 2 || calCount(_num1 + _num2) == 3)) {
      _options = 'doubleDigitWithoutCarry';
      _num1digit1 = _num1 % 10;
      _num1 = _num1 ~/ 10;
      _num1digit2 = _num1 % 10;
      _num1List.add(_num1digit1);
      _num1List.add(_num1digit2);
      _num2digit1 = _num2 % 10;
      _num2 = _num2 ~/ 10;
      _num2digit2 = _num2 % 10;
      _num2List.add(_num2digit1);
      _num2List.add(_num2digit2);
      print('printing _num1List list values..');
      print(_num1List);
      print('printing _num2List list values..');
      print(_num2List);
    } else {
      _options = 'tripleDigitWithoutCarry';
      _num1digit1 = _num1 % 10;
      _num1 = _num1 ~/ 10;
      _num1digit2 = _num1 % 10;
      _num1 = _num1 ~/ 10;
      _num1digit3 = _num1 % 10;
      _num2digit1 = _num2 % 10;
      _num2 = _num2 ~/ 10;
      _num2digit2 = _num2 % 10;
      _num2 = _num2 ~/ 10;
      _num2digit3 = _num2 % 10;
      _num1List.add(_num1digit1);
      _num1List.add(_num1digit2);
      _num1List.add(_num1digit3);
      _num2List.add(_num2digit1);
      _num2List.add(_num2digit2);
      _num2List.add(_num2digit3);
    }
    _j1 = calCount(_result);
    for (int _i = 0; _i < 4; _i++) {
      _outputList.add(' ');
      _flag.add(false);
      _barrowFlag.add(false);
      _shake.add(true);
      _carry.add(0);
      cf.add(0);
      _numbershake.add(true);
    }
    _finalResult = _result.toString();
    if (_options == 'doubleDigitWithoutCarry' &&
        _operator == '-' &&
        calCount(_result) == 1) {
      setState(() {
        _finalResult = '0' + _result.toString();
        _j1 = 2;
      });
    }
    if (_options == 'tripleDigitWithoutCarry' &&
        _operator == '-' &&
        calCount(_result) == 2) {
      setState(() {
        _finalResult = '0' + _result.toString();
        _j1 = 3;
      });
    }
    if (_options == 'tripleDigitWithoutCarry' &&
        _operator == '-' &&
        calCount(_result) == 1) {
      setState(() {
        _finalResult = '0' + '0' + _result.toString();
        _j1 = 3;
      });
    }
    if (_options == 'tripleDigitWithoutCarry' &&
        _operator == '-' &&
        calCount(_result) == 0) {
      setState(() {
        _finalResult = '0' + '0' + '0';
        _j1 = 3;
      });
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

  int _removeZero(int out) {
    if (calCount(out) > 1) {
      int num = out;
      int rem1 = num % 10;
      num = num ~/ 10;
      int rem2 = num;
      if (rem2 == 0) {
        print("printing reminder");
        print(rem1);
        return rem1;
      } else
        return out;
    } else
      return out;
  }

  @override
  void didUpdateWidget(CalculateTheNumbers oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  void _myAnim() {
    _animationShake.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
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

  String _addText(String _text, String _gettingResult) {
    print(_gettingResult);
    if (_gettingResult.length < 2 && _zeoToNine(_text) == true) {
      _gettingResult = _gettingResult + _text;
    }
    return _gettingResult;
  }

  String _removeText(String _text, String _gettingResult) {
    print(_gettingResult);
    if (_text == '✖') {
      _gettingResult = ' ';
    }
    return _gettingResult;
  }

  bool _final(String _text, String _gettingResult) {
    print("coming to the final function");
    if (_text == '✔' && _gettingResult == _finalResult) {
      if (_scoreCount == 0) {
        print("coming to the score count section");
        widget.onScore(1);
        widget.onProgress(1.0);
        _scoreCount = 1;
        new Future.delayed(const Duration(milliseconds: 2000), () {
          widget.onEnd();
        });
      }
      return true;
    }
    return false;
  }

  bool _rigltClick(String _text, String _gettingResult, int _result) {
    if (_text == '✔') {
      print("coming to right click ...");
      if (int.parse(_gettingResult) == _result) {
        return true;
      } else {
        return false;
      }
    } else
      return false;
  }

  Widget _buildItem(int index, String text, double _height, String _options) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        height: _height,
        onPress: () {
          switch (_operator) {
            case '+':
              if (_j1 > 0) {
                print("coming to the double digit..");
                print('initial _i value... $_i');
                print('initial j value... $_j1');
                print('_num1List first digit....${_num1List[_i]}');
                print('_num2List first digit....${_num2List[_i]}');
                setState(() {
                  _outputList[_i] =
                      _removeZero(int.parse(_addText(text, _outputList[_i])))
                          .toString();
                  _outputList[_i] = _removeText(text, _outputList[_i]);
                  _flag[_i] = _rigltClick(text, _outputList[_i],
                      (_num1List[_i] + _num2List[_i] + cf[_i]));
                  print('printing flag value....${_flag[_i]}');
                });
                print('first output....${_outputList[_i]}');
                print('complete list...${_outputList}');
                if (text == '✔') {
                  if (_rigltClick(text, _outputList[_i],
                          (_num1List[_i] + _num2List[_i] + cf[_i])) ==
                      true) {
                    setState(() {
                      _shake[_i] = true;
                      _carry[_i] = 1;
                    });
                    if (_outputList[_i].length > 1) {
                      setState(() {
                        _outputList[_i] =
                            (int.parse(_outputList[_i]) % 10).toString();
                        cf[_i + 1] = 1;
                        print(
                            'printing _outputList+1 value ....$_outputList[_i+1]');
                        _preValue = _outputList[_i] + _preValue;
                      });
                    } else {
                      setState(() {
                        _preValue = _outputList[_i] + _preValue;
                      });
                    }
                  }
                  if (_carry[_i] == 1) {
                    setState(() {
                      print('printing _i increment....');
                      //   _carry[_i] = 0;
                      _i++;
                      _j1--;
                    });
                  } else {
                    setState(() {
                      _shake[_i] = false;
                    });
                    new Future.delayed(const Duration(milliseconds: 1000), () {
                      setState(() {
                        _shake[_i] = true;
                        _outputList[_i] = ' ';
                      });
                    });
                  }
                }
                print('printing final value....$_preValue');
                print(' at end _i value ${_i}');
                print(' at end j value ${_j1}');
              }
              if ((cf[calCount(_result) - 1] == 1 &&
                      _options == 'singleDigit') ||
                  (cf[calCount(_result) - 1] == 1 &&
                      _options == 'tripleDigitWithoutCarry' &&
                      _outputList.length == calCount(_result)) ||
                  (cf[calCount(_result) - 1] == 1 &&
                      _options == 'doubleDigitWithoutCarry' &&
                      (_num1digit2 + _num2digit2 + 1) >= 10)) {
                print("coming to check final carry is there or not...");
                setState(() {
                  print('printing _i value in _carryFlag function...$_i');
                  _outputList[_i] = '1';
                  print('printing output list...$_outputList');
                  _preValue = _outputList[_i] + _preValue;
                  _flag[_i] = true;
                });
              }
              _final(text, _preValue);
              break;
            case '-':
              if (_j1 > 0 && _carry[_i] == 0) {
                setState(() {
                  _outputList[_i] =
                      _removeZero(int.parse(_addText(text, _outputList[_i])))
                          .toString();
                  _outputList[_i] = _removeText(text, _outputList[_i]);
                });
                if (text == '✔') {
                  if (_num1List[_i] > _num2List[_i] ||
                      _num1List[_i] == _num2List[_i]) {
                    if (_rigltClick(text, _outputList[_i],
                            (_num1List[_i] - _num2List[_i] + cf[_i])) ==
                        true) {
                      setState(() {
                        _flag[_i] = _rigltClick(text, _outputList[_i],
                            (_num1List[_i] - _num2List[_i] + cf[_i]));
                        _shake[_i] = true;
                        _carry[_i] = 1;
                        _preValue = _outputList[_i] + _preValue;
                      });
                    }
                  } else {
                    setState(() {
                      _barrowFlag[_i] = true;
                    });
                    if (_rigltClick(text, _outputList[_i],
                            ((_num1List[_i] + 10) - _num2List[_i] + cf[_i])) ==
                        true) {
                      setState(() {
                        _flag[_i] = _rigltClick(text, _outputList[_i],
                            ((_num1List[_i] + 10) - _num2List[_i] + cf[_i]));
                        _shake[_i] = true;
                        _carry[_i] = 1;
                        cf[_i + 1] = -1;
                        _preValue = _outputList[_i] + _preValue;
                      });
                    } else {
                      setState(() {
                        _numbershake[_i] = false;
                        _shake[_i] = false;
                      });
                      new Future.delayed(const Duration(milliseconds: 900), () {
                        setState(() {
                          _numbershake[_i] = true;
                          _shake[_i] = true;
                        });
                      });
                    }
                  }
                  if (_flag[_i] == true) {
                    setState(() {
                      _i++;
                      _j1--;
                      print('printing j value after decrement...$_j1');
                    });
                  } else {
                    setState(() {
                      _shake[_i] = false;
                    });
                    new Future.delayed(const Duration(milliseconds: 1000), () {
                      setState(() {
                        _shake[_i] = true;
                        _outputList[_i] = ' ';
                      });
                    });
                  }
                }
              }
              _final(text, _preValue);
              break;
            case '*':
              setState(() {
                _outputList[_i] =
                    _removeZero(int.parse(_addText(text, _outputList[_i])))
                        .toString();
                _outputList[_i] = _removeText(text, _outputList[_i]);
                _flag[_i] = _rigltClick(
                    text, _outputList[_i], (_num1List[_i] * _num2List[_i]));
              });
              if (text == '✔') {
                if (_rigltClick(text, _outputList[_i],
                        (_num1List[_i] * _num2List[_i])) ==
                    true) {
                  setState(() {
                    _shake[_i] = true;
                    _carry[_i] = 1;
                    _preValue = _outputList[_i] + _preValue;
                  });
                  if (_outputList[_i].length > 1) {
                    setState(() {
                      _outputList[_i] =
                          (int.parse(_outputList[_i]) % 10).toString();
                      _outputList[_i + 1] = (_result ~/ 10).toString();
                      _flag[_i + 1] = true;
                    });
                  }
                } else {
                  setState(() {
                    _shake[_i] = false;
                  });
                  new Future.delayed(const Duration(milliseconds: 900), () {
                    setState(() {
                      _shake[_i] = true;
                      _outputList[_i] = ' ';
                    });
                  });
                }
              }
              _final(text, _preValue);
          }
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget displayContainer(double _height, String num, int carry, Key _key) {
    return new Container(
      height: _height * 0.09,
      width: _height * 0.05,
      decoration: new BoxDecoration(
        color: Colors.blue,
        borderRadius:
            new BorderRadius.all(new Radius.circular(_height * 0.0095)),
      ),
      key: _key,
      child: new Center(
          child: new Text(num,
              style: new TextStyle(
                  color: carry == 0 ? Colors.blue : Colors.black,
                  fontSize: _height * 0.05,
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget displayShake(
      double _height, String output, bool _flag, bool _shake, Key _key) {
    return new Shake(
        key: _key,
        animation: _shake == false ? _animationShake : _animation,
        child: new Container(
          height: _height * 0.09,
          width: _height * 0.05,
          //  color: _flag == true ? Colors.green : Colors.red,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: _flag == true ? Colors.green : Colors.red,
            borderRadius:
                new BorderRadius.all(new Radius.circular(_height * 0.0095)),
          ),
          child: new Center(
              child: new Text(output,
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: _height * 0.05,
                      fontWeight: FontWeight.bold))),
        ));
  }

  Widget displayTable(double _height, String _options) {
    int j = 0;
    List<TableRow> rows = new List<TableRow>();
    for (var _i = 0; _i < _size + 1; ++_i) {
      List<Widget> cells = _numbers
          .skip(_i * _size)
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
    switch (_options) {
      case 'singleDigit':
        return new LayoutBuilder(builder: (context, constraints) {
          return new Container(
            //    color: new Color(0XFFFFF7EBCB),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  margin:
                      new EdgeInsets.only(bottom: constraints.maxHeight * 0.04),
                  child: new Table(
                    defaultColumnWidth:
                        // constraints.maxHeight > constraints.maxWidth
                        // ? new FractionColumnWidth(
                        // constraints.maxHeight * 0.0003)
                        // :
                        new FractionColumnWidth(constraints.maxHeight * 0.0003),
                    children: <TableRow>[
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //  color: Colors.limeAccent,
                              child: displayContainer(constraints.maxHeight,
                                  cf[1].toString(), cf[1], new Key('carry1'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //  color: Colors.limeAccent,
                              child: displayContainer(
                                  constraints.maxHeight, ' ', 1, new Key(''))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            //  color: new Color(0XFFFF52C5CE),
                            child: displayContainer(
                                constraints.maxHeight, ' ', 1, new Key('')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  "$_num1", 1, new Key('_num1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            // color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.maxHeight,
                                _operator, 1, new Key('_operator')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            //  color: new Color(0XFFFF52C5CE),
                            child: displayContainer(constraints.maxHeight,
                                "$_num2", 1, new Key('_num2')),
                          ),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _flag[1] == true
                              ? new Container(
                                  height: constraints.maxHeight * 0.09,
                                  width: constraints.maxHeight * 0.05,
                                  child: new _BlinkAnimation(
                                    text: _outputList[1],
                                    height: constraints.maxHeight,
                                  ),
                                )
                              : displayShake(
                                  constraints.maxHeight,
                                  _outputList[1],
                                  _flag[1],
                                  _shake[1],
                                  new Key('shake')),
                        ),
                        new Padding(
                            padding: new EdgeInsets.all(
                                constraints.maxHeight * 0.005),
                            child: _flag[0] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[0],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : new Container(
                                    child: displayShake(
                                        constraints.maxHeight,
                                        _outputList[0],
                                        _flag[0],
                                        _shake[0],
                                        new Key('shake1')))),
                      ]),
                    ],
                  ),
                ),
                new Container(
                  child: displayTable(constraints.maxHeight, 'singleDigit'),
                )
              ],
            ),
          );
        });
        break;

      case 'doubleDigitWithoutCarry':
        return new LayoutBuilder(builder: (context, constraints) {
          return new Container(
            //  color: new Color(0XFFFFF7EBCB),

            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  margin:
                      new EdgeInsets.only(bottom: constraints.maxHeight * 0.04),
                  child: new Table(
                    defaultColumnWidth:
                        /* constraints.maxHeight > constraints.maxWidth
                            ? new FractionColumnWidth(
                                constraints.maxHeight * 0.0004)
                            : */
                        new FractionColumnWidth(
                            constraints.maxHeight * 0.00025),
                    children: <TableRow>[
                      new TableRow(children: <Widget>[
                        //  new BarrowAnimation(),
                        new Padding(
                            padding: new EdgeInsets.all(
                                constraints.maxHeight * 0.005),
                            child: new Container(

                                ///   color: Colors.limeAccent,
                                child: displayContainer(
                                    constraints.maxHeight,
                                    cf[2].toString(),
                                    cf[2],
                                    new Key('carry3')))),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Container(
                                  decoration: new BoxDecoration(
                                    // color: Colors.blue,
                                    color: _barrowFlag[0] == true &&
                                            _operator == '-' &&
                                            _carryFlag == true
                                        ? Colors.redAccent
                                        : Colors.blue,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(
                                            constraints.maxHeight * 0.0095)),
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      cf[1].toString(),
                                      style: new TextStyle(
                                        color: cf[1] == -1
                                            ? Colors.black
                                            : Colors.blue,
                                        fontSize: constraints.maxHeight * 0.09,
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(
                                  //   color: Colors.limeAccent,
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      cf[1].toString(),
                                      cf[1],
                                      new Key('carry2'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Container(
                                  height: constraints.maxHeight * 0.09,
                                  width: constraints.maxHeight * 0.05,
                                  decoration: new BoxDecoration(
                                    color: _barrowFlag[0] == true &&
                                            _operator == '-' &&
                                            _carryFlag == true
                                        ? Colors.redAccent
                                        : Colors.blue,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(
                                            constraints.maxHeight * 0.0095)),
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      _barrowFlag[0] == true &&
                                              _operator == '-' &&
                                              _carryFlag == true
                                          ? _arrow
                                          : ' ',
                                      style: new TextStyle(
                                        fontSize: _barrowFlag[0] == true &&
                                                _operator == '-' &&
                                                _carryFlag == true
                                            ? constraints.maxHeight * 0.078
                                            : constraints.maxHeight * 0.09,
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(
                                  //color: Colors.limeAccent,
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      cf[0].toString(),
                                      cf[0],
                                      new Key('carry1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //  color: new Color(0XFFFF52C5CE),
                              child: displayContainer(
                                  constraints.maxHeight, ' ', 1, new Key(''))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              // color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  '$_num1digit2', 1, new Key('_num1digit2'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Shake(
                                  animation: _numbershake[0] == false
                                      ? _animationShake
                                      : _animation,
                                  child: new GestureDetector(
                                    onTap: _carry[0] == 0
                                        ? () {
                                            setState(() {
                                              _carryFlag = true;
                                              if (_tempf == 0 &&
                                                  _barrowFlag[0] == true) {
                                                _num1digit1 = _num1digit1 + 10;
                                                cf[1] = -1;
                                                _tempf++;
                                              }
                                            });
                                            new Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              setState(() {
                                                _carryFlag = false;
                                              });
                                            });
                                          }
                                        : () {},
                                    child: new Container(
                                      height: constraints.maxHeight * 0.09,
                                      width: constraints.maxHeight * 0.05,
                                      decoration: new BoxDecoration(
                                        color: _barrowFlag[0] == true &&
                                                _operator == '-' &&
                                                _carryFlag == true
                                            ? Colors.green
                                            : Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(
                                                constraints.maxHeight *
                                                    0.0095)),
                                      ),
                                      child: new Center(
                                          child: new Text('$_num1digit1',
                                              style: new TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.09,
                                              ))),
                                    ),
                                  ),
                                )
                              : new Container(
                                  // color: new Color(0XFFFF52C5CE),
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      '$_num1digit1',
                                      1,
                                      new Key('_num1digit1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              // color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  _operator, 1, new Key('_operator'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              // color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  '$_num2digit2', 1, new Key('_num2digit2'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              // color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  '$_num2digit1', 1, new Key('_num2digit1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[2] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[2],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[2],
                                    _flag[2],
                                    true,
                                    new Key('')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[1] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[1],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[1],
                                    _flag[1],
                                    _shake[1],
                                    new Key('shake2')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[0] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[0],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[0],
                                    _flag[0],
                                    _shake[0],
                                    new Key('shake1')),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                new Container(
                  child: displayTable(
                      constraints.maxHeight, 'doubleDigitWithoutCarry'),
                )
              ],
            ),
          );
        });
        break;
      case 'tripleDigitWithoutCarry':
        return new LayoutBuilder(builder: (context, constraints) {
          return new Container(
            //   color: new Color(0XFFFFF7EBCB),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Container(
                  margin:
                      new EdgeInsets.only(bottom: constraints.maxHeight * 0.04),
                  child: new Table(
                    defaultColumnWidth:
                        /* constraints.maxHeight > constraints.maxWidth
                            ? new FractionColumnWidth(
                                constraints.maxHeight * 0.0003)
                            :  */
                        new FractionColumnWidth(constraints.maxHeight * 0.0002),
                    children: <TableRow>[
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //   color: Colors.limeAccent,
                              child: displayContainer(constraints.maxHeight,
                                  cf[3].toString(), cf[3], new Key('carry4'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Container(
                                  decoration: new BoxDecoration(
                                    color: _barrowFlag[1] == true &&
                                            _operator == '-' &&
                                            _carryFlag1 == true
                                        ? Colors.redAccent
                                        : Colors.blue,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(
                                            constraints.maxHeight * 0.0095)),
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      _barrowFlag[1] == true &&
                                              _operator == '-' &&
                                              _carryFlag1 == true
                                          ? '-1'
                                          : cf[2] == -1 ? '-1' : ' ',
                                      style: new TextStyle(
                                        fontSize: _barrowFlag[1] == true &&
                                                _operator == '-' &&
                                                _carryFlag1 == true
                                            ? constraints.maxHeight * 0.09
                                            : constraints.maxHeight * 0.09,
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(
                                  // color: Colors.limeAccent,
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      cf[2].toString(),
                                      cf[2],
                                      new Key('carry3'))),
                        ),
                        new Padding(
                            padding: new EdgeInsets.all(
                                constraints.maxHeight * 0.005),
                            child: _operator == '-'
                                // ? barrowFlag==true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    decoration: new BoxDecoration(
                                      color: (_barrowFlag[0] == true &&
                                                  _carryFlag == true) ||
                                              (_barrowFlag[1] == true &&
                                                  _carryFlag1 == true)
                                          ? Colors.redAccent
                                          : Colors.blue,
                                      borderRadius: new BorderRadius.all(
                                          new Radius.circular(
                                              constraints.maxHeight * 0.0095)),
                                    ),
                                    child: new Center(
                                      child: new Text(
                                        _barrowFlag[1] == true &&
                                                _carryFlag1 == true
                                            ? _arrow
                                            : cf[1].toString(),
                                        style: new TextStyle(
                                            color: cf[1] == -1
                                                ? Colors.black
                                                : Colors.blue,
                                            fontSize: _barrowFlag[1] == true &&
                                                    _carryFlag1 == true
                                                ? constraints.maxHeight * 0.078
                                                : constraints.maxHeight * 0.09),
                                      ),
                                    ),
                                  )
                                : new Container(
                                    // color: Colors.limeAccent,
                                    child: displayContainer(
                                        constraints.maxHeight,
                                        cf[1].toString(),
                                        cf[1],
                                        new Key('carry2'))) //,
                            ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Container(
                                  decoration: new BoxDecoration(
                                    color: _barrowFlag[0] == true &&
                                            _operator == '-' &&
                                            _carryFlag == true
                                        ? Colors.redAccent
                                        : Colors.blue,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(
                                            constraints.maxHeight * 0.0095)),
                                  ),
                                  child: new Center(
                                    child: new Text(
                                      _barrowFlag[0] == true &&
                                              _operator == '-' &&
                                              _carryFlag == true
                                          ? _arrow
                                          : ' ',
                                      style: new TextStyle(
                                        fontSize: _barrowFlag[0] == true &&
                                                _operator == '-' &&
                                                _carryFlag == true
                                            ? constraints.maxHeight * 0.078
                                            : constraints.maxHeight * 0.09,
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(
                                  color: Colors.limeAccent,
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      cf[0].toString(),
                                      cf[0],
                                      new Key('carry1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              child: displayContainer(
                                  constraints.maxHeight, ' ', 1, new Key(''))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              child: displayContainer(constraints.maxHeight,
                                  '$_num1digit3', 1, new Key('_num1digit3'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Shake(
                                  animation: _numbershake[1] == false
                                      ? _animationShake
                                      : _animation,
                                  child: new GestureDetector(
                                    onTap: _carry[1] == 0 && _carry[0] == 1
                                        ? () {
                                            setState(() {
                                              _carryFlag1 = true;
                                              if (_tempf1 == 0 &&
                                                  _barrowFlag[1] == true) {
                                                _num1digit2 = _num1digit2 + 10;
                                                cf[2] = -1;
                                                _tempf1++;
                                              }
                                            });
                                            new Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              setState(() {
                                                _carryFlag1 = false;
                                              });
                                            });
                                          }
                                        : () {},
                                    child: new Container(
                                      height: constraints.maxHeight * 0.09,
                                      width: constraints.maxHeight * 0.05,
                                      decoration: new BoxDecoration(
                                        //   color: Colors.blue,
                                        color: _barrowFlag[1] == true &&
                                                _operator == '-' &&
                                                _carryFlag1 == true
                                            ? Colors.green
                                            : Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(
                                                constraints.maxHeight *
                                                    0.0095)),
                                      ),
                                      child: new Center(
                                          child: new Text('$_num1digit2',
                                              style: new TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.09,
                                              ))),
                                    ),
                                  ),
                                )
                              : new Container(
                                  //  color: new Color(0XFFFF52C5CE),
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      '$_num1digit2',
                                      1,
                                      new Key('_num1digit2'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: _operator == '-'
                              ? new Shake(
                                  animation: _numbershake[0] == false
                                      ? _animationShake
                                      : _animation,
                                  child: new GestureDetector(
                                    onTap: _carry[0] == 0
                                        ? () {
                                            setState(() {
                                              _carryFlag = true;
                                              if (_tempf == 0 &&
                                                  _barrowFlag[0] == true) {
                                                _num1digit1 = _num1digit1 + 10;
                                                cf[1] = -1;
                                                _tempf++;
                                              }
                                            });
                                            new Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              setState(() {
                                                _carryFlag = false;
                                              });
                                            });
                                          }
                                        : () {},
                                    child: new Container(
                                      decoration: new BoxDecoration(
                                        color: _barrowFlag[0] == true &&
                                                _operator == '-' &&
                                                _carryFlag == true
                                            ? Colors.green
                                            : Colors.blue,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(
                                                constraints.maxHeight *
                                                    0.0095)),
                                      ),
                                      child: new Center(
                                          child: new Text('$_num1digit1',
                                              style: new TextStyle(
                                                fontSize:
                                                    constraints.maxHeight *
                                                        0.09,
                                              ))),
                                    ),
                                  ),
                                )
                              : new Container(
                                  //  color: new Color(0XFFFF52C5CE),
                                  child: displayContainer(
                                      constraints.maxHeight,
                                      '$_num1digit1',
                                      1,
                                      new Key('_num1digit1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              // color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  _operator, 1, new Key('_operator'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //   color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  '$_num2digit3', 1, new Key('_num2digit3'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              //  color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  '$_num2digit2', 1, new Key('_num2digit2'))),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                              // color: new Color(0XFFFF52C5CE),
                              child: displayContainer(constraints.maxHeight,
                                  '$_num2digit1', 1, new Key('_num2digit1'))),
                        ),
                      ]),
                      new TableRow(children: <Widget>[
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[3] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[3],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[3],
                                    _flag[3],
                                    _shake[3],
                                    new Key('flag2')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[2] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[2],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[2],
                                    _flag[2],
                                    _shake[2],
                                    new Key('flag2')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[1] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[1],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[1],
                                    _flag[1],
                                    _shake[1],
                                    new Key('flag1')),
                          ),
                        ),
                        new Padding(
                          padding:
                              new EdgeInsets.all(constraints.maxHeight * 0.005),
                          child: new Container(
                            child: _flag[0] == true
                                ? new Container(
                                    height: constraints.maxHeight * 0.09,
                                    width: constraints.maxHeight * 0.05,
                                    child: new _BlinkAnimation(
                                      text: _outputList[0],
                                      height: constraints.maxHeight,
                                    ),
                                  )
                                : displayShake(
                                    constraints.maxHeight,
                                    _outputList[0],
                                    _flag[0],
                                    _shake[0],
                                    new Key('flag1')),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                new Container(
                  child: displayTable(
                      constraints.maxHeight, 'tripleDigitWithoutCarry'),
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
  void dispose() {
    controller.dispose();
    super.dispose();
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
            padding: new EdgeInsets.all(widget.height * 0.005),
            child: new ScaleTransition(
                scale: animation,
                child: new RaisedButton(
                    onPressed: () => widget.onPress(),
                    padding: new EdgeInsets.all(widget.height * 0.02),
                    //  color: Colors.orangeAccent,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.all(
                            new Radius.circular(widget.height * 0.0095))),
                    child: new Text(_displayText,
                        key: new Key('keyPad'),
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: _displayText == '✖' || _displayText == '✔'
                                ? widget.height * 0.042
                                : widget.height * 0.05,
                            fontWeight: FontWeight.bold))))));
  }
}

class _BlinkAnimation extends StatefulWidget {
  _BlinkAnimation({Key key, this.text, this.height}) : super(key: key);
  String text;
  double height;
  @override
  _BlinkAnimationState createState() => new _BlinkAnimationState();
}

class _BlinkAnimationState extends State<_BlinkAnimation>
    with TickerProviderStateMixin {
  AnimationController _opacityController;
  Animation<double> _opacity;
  bool _showHint = false;
  String _text;
  double _height;

  @override
  void initState() {
    super.initState();
    _text = widget.text;
    _height = widget.height;
    _opacityController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _opacity =
        new CurvedAnimation(parent: _opacityController, curve: Curves.easeInOut)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _opacityController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _opacityController.forward();
            }
          });
    _opacityController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _opacityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        //   height: _height*0.09,
        // width:_height*0.05,
        child: new Stack(
      alignment: Alignment.center,
      children: <Widget>[
        !_showHint
            ? new FadeTransition(
                opacity: _opacity,
                child: new Container(
                  //           height: _height*0.09,
                  // width:_height*0.05,
                  decoration: new BoxDecoration(
                    color: Colors.green,
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(_height * 0.0095)),
                  ),
                  child: new Center(
                    child: new Text(
                      _text,
                      style: new TextStyle(
                          fontSize: _height * 0.05,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            : new Container(
                //         height: _height*0.09,
                // width:_height*0.05,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.all(
                      new Radius.circular(_height * 0.0095)),
                ),
                child: new Text(
                  ' ',
                  style: new TextStyle(
                      fontSize: _height * 0.05,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ],
    ));
  }
}
