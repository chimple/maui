import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/gameaudio.dart';

class Tables extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Tables(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _TablesState();
}

class _TablesState extends State<Tables> with SingleTickerProviderStateMixin {
  final int _size = 3;
  String _question = "";
  String _result = "";
  int _count = 0, score = 0;
  int _wrong = 0;
  int _answer;
  bool _isLoading = true;
  List<Tuple4<int, String, int, int>> _tableData;
  List<Tuple4<int, String, int, int>> _tableShuffledData = [];
  Animation animation;
  AnimationController animationController;
  bool _isShowingFlashCard = false;

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
    '✔',
  ];

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 15.0).animate(animationController);
    _initBoard();
  }

  void _initBoard() async {
    _count = 0;
    _wrong = 0;
    _result = '';
    setState(() => _isLoading = true);
    _tableData = await fetchTablesData(widget.gameCategoryId);
    _tableShuffledData = [];

    for (var i = 0; i < _allLetters.length; i += _size * _size) {
      _tableShuffledData.addAll(
          _tableData.skip(i).take(_size * _size).toList(growable: false)
            ..shuffle());
    }

    int temp1 = _tableShuffledData[_count].item1;
    String temp2 = _tableShuffledData[_count].item2;
    int temp3 = _tableShuffledData[_count].item3;
    _question = "$temp1 $temp2 $temp3";
    _answer = _tableShuffledData[_count].item4;
    setState(() => _isLoading = false);
  }

  //used for shake animation
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

  Widget _buildItem(int index, String text, double _height) {
    print('_buildItem: $text');
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        height: _height,
        onPress: () {
          if (text == '✖') {
            setState(() {
              _result = _result.substring(0, _result.length - 1);
            });
          } else if (text == '✔') {
            if (_count == _tableShuffledData.length - 1 &&
                int.parse(_result) == _answer) {
              print("coming.........");
              int _temp = _tableShuffledData.length;
              print("$_count $_temp");
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
            }

            if (int.parse(_result) == _answer) {
              widget.onScore(4);
              widget.onProgress((_count + 1) / _tableShuffledData.length);
              setState(() {
                _count = _count + 1;
                print(_count);
                int temp1 = _tableShuffledData[_count].item1;
                String temp2 = _tableShuffledData[_count].item2;
                int temp3 = _tableShuffledData[_count].item3;
                _question = "$temp1 $temp2 $temp3";
                _answer = _tableShuffledData[_count].item4;
                _result = "";
                _wrong = 0;
                score = score + 4;
              });
            } else {
              if (score > 0) {
                print("Score $score");
                widget.onScore(-1);
              }
              _myAnim();
              new Future.delayed(const Duration(milliseconds: 700), () {
                setState(() {
                  _wrong = _wrong + 1;
                  _result = "";
                  score = score > 0 ? score - 1 : score;
                });
                animationController.stop();
                if (_wrong == 4) {
                  widget.onProgress((_count + 1) / _tableShuffledData.length);
                  setState(() {
                    _isShowingFlashCard = true;
                    _wrong = 0;
                  });
                }
              });
            }
          } else {
            setState(() {
              if (_result.length < 3) {
                _result = _result + text;
              }
            });
          }
        });
  }

  @override
  void didUpdateWidget(Tables oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      print(_tableData);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print("anuj data");
    print(media.size);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    return new LayoutBuilder(builder: (context, constraints) {
      print("this is  data");
      print(constraints.maxHeight);
      print(constraints.maxWidth);
      double _height, _width;
      _height = constraints.maxHeight;
      _width = constraints.maxWidth;
      List<TableRow> rows = new List<TableRow>();
      var j = 0;
      for (var i = 0; i < _size + 1; ++i) {
        List<Widget> cells = _allLetters
            .skip(i * _size)
            .take(_size)
            .map((e) => _buildItem(j++, e, _height))
            .toList();
        rows.add(new TableRow(children: cells));
      }

      if (_isShowingFlashCard) {
        String temp = _question + " = " + _answer.toString();
        return FractionallySizedBox(
            widthFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.7 : 0.65,
            heightFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.4 : 0.8,
            child: new FlashCard(
                text: temp,
                onChecked: () {
                  setState(() {
                    _isShowingFlashCard = false;
                    print(
                        'thiss    ${this._count}   ${_tableShuffledData.length}');
                    if (this._count == _tableShuffledData.length - 1) {
                      widget.onEnd();
                    } else {
                      this._count = this._count + 1;
                      int temp1 = _tableShuffledData[_count].item1;
                      String temp2 = _tableShuffledData[_count].item2;
                      int temp3 = _tableShuffledData[_count].item3;
                      _question = "$temp1 $temp2 $temp3";
                      _answer = _tableShuffledData[_count].item4;
                    }
                  });
                }));
      }
      return new Center(
          child: new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                  height: _height * 0.35,
                  width: _width,
                  color: new Color(0xFFFF812C),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.only(bottom: _height * 0.03),
                          alignment: Alignment.center,
                          child: new Text(
                            '$_question',
                            key: new Key('question'),
                            style: new TextStyle(
                              fontSize: _height * 0.1,
                              fontWeight: FontWeight.bold,
                              color: new Color(0xFFA46DBA),
                            ),
                          ),
                        ),
                        new TextAnimation(
                          animation: animation,
                          text: _result,
                          height: _height,
                          width: _width,
                        )
                      ])),
              new Container(
                height: _height * 0.6,
                width: _width,
                padding: new EdgeInsets.only(
                    right: constraints.maxWidth > constraints.maxHeight
                        ? constraints.maxWidth * 0.3
                        : constraints.maxWidth * 0.1,
                    left: constraints.maxWidth > constraints.maxHeight
                        ? constraints.maxWidth * 0.3
                        : constraints.maxWidth * 0.1,
                    top: constraints.maxWidth > constraints.maxHeight
                        ? constraints.maxHeight * 0.05
                        : constraints.maxWidth * 0.07),
                child: new Table(children: rows),
              ),
            ]),
      ));
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.height, this.onPress}) : super(key: key);

  final String text;
  final double height;
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
    return new TableCell(
        child: new Padding(
            padding: new EdgeInsets.all(widget.height * 0.008),
            child: new RaisedButton(
                splashColor: Theme.of(context).primaryColor,
                highlightColor: Theme.of(context).primaryColor,
                onPressed: () => widget.onPress(),
                padding: new EdgeInsets.all(widget.height * 0.028),
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    side: new BorderSide(
                        color: _displayText == '✖'
                            ? Colors.red
                            : _displayText == '✔'
                                ? Colors.green
                                : new Color(0xFFA46DBA),
                        width: widget.height * 0.0075),
                    borderRadius: new BorderRadius.all(
                        new Radius.circular(widget.height * 0.020))),
                child: new Center(
                  child: new Text(_displayText,
                      key: new Key('keyPad'),
                      style: new TextStyle(
                          color: _displayText == '✖'
                              ? Colors.red
                              : _displayText == '✔'
                                  ? Colors.green
                                  : new Color(0xFFA46DBA),
                          fontSize: _displayText == '✖' || _displayText == '✔'
                              ? widget.height * 0.053
                              : widget.height * 0.06,
                          fontWeight: FontWeight.bold)),
                )))
        // )
        );
  }
}

class TextAnimation extends AnimatedWidget {
  TextAnimation(
      {Key key, Animation animation, this.text, this.height, this.width})
      : super(key: key, listenable: animation);
  final String text;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return new Center(
        child: new Container(
            height: height * 0.12,
            width: height / 4.0,
            alignment: Alignment.center,
            margin: new EdgeInsets.only(
                left: animation.value ?? 0, bottom: height * 0.03),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius:
                    new BorderRadius.all(new Radius.circular(height * 0.015)),
                border: new Border.all(
                  color: new Color(0xFFA46DBA),
                  width: height * 0.0075,
                ),
                shape: BoxShape.rectangle),
            child: new Text(text,
                style: new TextStyle(
                  color: new Color(0xFFA46DBA),
                  fontSize: height * 0.09,
                  fontWeight: FontWeight.bold,
                ))));
  }
}
