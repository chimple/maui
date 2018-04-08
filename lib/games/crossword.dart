import 'dart:async';

import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';

class Crossword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Crossword(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new CrosswordState();
}

class CrosswordState extends State<Crossword> {
  var flag1 = 0;
  var correct = 0;
  var keys = 0;
  Tuple2<List<List<String>>, List<Tuple4<String, int, int, Direction>>> data;
  static final int _size = 5;
  List<String> _rightwords = new List(_size);
  List<String> _letters = new List();
  List<String> _data2 = new List();
  List<int> _data2_ = new List();
  List<int> _flag = new List();
  List<String> _data1 = new List();
  List _sortletters = new List(_size * 2);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // keys=0;
    //  print('init 111');
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    data = await fetchCrosswordData(widget.gameCategoryId);

    data.item1.forEach((e) {
      e.forEach((v) {
        _data1.add(v);
      });
    });

    for (var i = 0; i < data.item2.length; i++) {
      _data2.add(data.item2[i].item1);
    }
    // _data2_.add(data.item2[0].item2)
    for (var i = 0; i < data.item2.length; i++) {
      _data2_.add(data.item2[i].item2 * 5 + data.item2[i].item3);
    }

    // print('hoi  $_data1');
    // print('hoi ss ${_data1.length}');
    _letters = _data1;
    for (var i = 0; i < _data1.length; i++) {
      if (_data1[i] == null) {
        _letters[i] = '1';
      } else {
        _letters[i] = _data1[i];
      }
    }
    for (var i = 0, j = 0, h = 0; i < _letters.length; i++) {
      if (i == 5 || i == 11 || i == 12 || i == 13 || i == 19) {
        _rightwords[j++] = _letters[i];
        _sortletters[h++] = _letters[i];
        _sortletters[h++] = i;
        _letters[i] = '';
      }
    }
    _rightwords.shuffle();
    _flag.length = _letters.length + _size + 1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    setState(() => _isLoading = false);
    //  print('helo $_sortletters');
  }

  Widget _buildItem(int index, String text, int flag) {
    final TextEditingController t1 = new TextEditingController(text: text);
    if (text != '1') {
      return new MyButton(
          index: index,
          text: text,
          color1: 1,
          isRotated: widget.isRotated,
          onAccepted: (targettext) {
            flag1 = 0;
            for (var i = 0; i < _sortletters.length; i++) {
              if (_sortletters[i] == targettext &&
                  index == _sortletters[++i] &&
                  _letters[index] == '') {
                //  _rightwords[index-100]='';
                flag1 = 1;
                break;
              }
            }
            setState(() {
              if (flag1 == 1) {
                _letters[index] = targettext;

                correct++;
                widget.onScore(1);
                widget.onProgress(correct / _size);
                if (correct == _size) {
                  widget.onEnd();
                  widget.onEnd();
                }
              } else if (flag1 == 0) {
                _flag[index] = 1;
              }
            });
          },
          flag: flag,
          arr: _flag,
          img: _data2,
          imgindex: _data2_,
          keys: keys++); //mybutton
    } else {
      return new MyButton(
          index: index,
          text: '',
          color1: 0,
          flag: flag,
          arr: _flag,
          onAccepted: (text) {},
          img: _data2,
          imgindex: _data2_,
          keys: keys);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  print("MyTableState.build");
    keys = 0;
    List<TableRow> rows = new List<TableRow>();
    List<TableRow> rows1 = new List<TableRow>();
    var j = 0, h = 0;
    for (var i = 0; i < 5; i++) {
      List<Widget> cells = _letters
          .skip(i * _size)
          .take(_size)
          .map((e) => _buildItem(j++, e, _flag[h++]))
          .toList();
      rows.add(new TableRow(children: cells));
    }
    j = 100;
    for (var i = 0; i < 1; i++) {
      List<Widget> cells = _rightwords
          .skip(i * 1)
          .take(_size)
          .map((e) => _buildItem(j++, e, _flag[h++]))
          .toList();
      rows1.add(new TableRow(children: cells));
    }
    return new Center(
        child: new Container(
            color: Colors.purple[300],
            child: new Column(
              children: <Widget>[
                new Table(children: rows),
                new Padding(padding: new EdgeInsets.all(20.0)),
                new Text("choose words",
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 50.0,
                        fontFamily: "Roboto")),
                new Padding(padding: new EdgeInsets.all(20.0)),
                new Table(children: rows1)
              ],
            )));
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.arr,
      this.img,
      this.isRotated = false,
      this.imgindex,
      this.keys});
  var index;
  final int color1;
  final int flag;
  final String text;
  List arr;
  final List<String> img;
  final List<int> imgindex;
  final DragTargetAccept onAccepted;
  int keys;
  final bool isRotated;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {
            //  print("$state:${animation.value}");
            if (state == AnimationStatus.dismissed) {
              controller.forward();
            }
          });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flag == 1) {
      // print("old ${oldWidget.text} new ${widget.text}");
      controller.reverse();
    }
    //  print("_MyButtonState.didUpdateWidget: ${widget.text} ${oldWidget.text}");
  }

  void _handleTouch() {
    print(widget.text);
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    widget.keys++;
    print(widget.keys);
    for (var i = 0; i < widget.arr.length; i++) {
      widget.arr[i] = 0;
    }
    for (var i = 0; i < widget.imgindex.length; i++) {
      if (widget.imgindex[i] == widget.index) {
        return new TableCell(
            child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new ScaleTransition(
                    scale: animation,
                    child: new Container(
                      width: 30.0,
                      height: 44.0,
                      decoration: new BoxDecoration(
                          color: Colors.yellow[500],
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(8.0)),
                          image: new DecorationImage(
                              image: new AssetImage(widget.img[i]),
                              fit: BoxFit.contain)),
                      child: new Center(
                        child: new Text(widget.text,
                            key: new Key('A${widget.keys}'),
                            style: new TextStyle(
                                color: Colors.black, fontSize: 24.0)),
                      ),
                    ))));
      }
    }
    if (widget.index < 100 && widget.color1 != 0) {
      return new TableCell(
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new ScaleTransition(
            scale: animation,
            child: new Container(
              width: 30.0,
              height: 44.0,
              decoration: new BoxDecoration(
                color: widget.color1 == 1
                    ? Colors.yellow[500]
                    : Colors.purple[300],
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new DragTarget(
                onAccept: (String data) => widget.onAccepted(data),
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return new Container(
                    width: 30.0,
                    height: 44.0,
                    decoration: new BoxDecoration(
                      color: Colors.yellow[500],
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0)),
                    ),
                    child: new Center(
                      child: new Text(widget.text,
                          key: new Key('A${widget.keys}'),
                          style: new TextStyle(
                              color: Colors.black, fontSize: 24.0)),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else if (widget.index >= 100) {
      var feedbackContainer = new Container(
        height: 60.0,
        width: 80.0,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            color: Colors.yellow[400]),
        child: new Center(
          child: new Text(
            _displayText,
            style: new TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 26.0,
            ),
          ),
        ),
      );
      return new TableCell(
          child: new Draggable(
              data: _displayText,
              child: new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new ScaleTransition(
                    scale: animation,
                    child: new Container(
                      width: 30.0,
                      height: 44.0,
                      decoration: new BoxDecoration(
                        color: widget.color1 == 1
                            ? Colors.yellow[500]
                            : Colors.purple[300],
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(8.0)),
                      ),
                      child: new Center(
                        child: new Text(_displayText,
                            key: new Key('B${widget.keys}'),
                            style: new TextStyle(
                                color: Colors.black, fontSize: 24.0)),
                      ),
                    )),
              ),
              feedback: widget.isRotated
                  ? new RotatedBox(quarterTurns: 2, child: feedbackContainer)
                  : feedbackContainer));
    } else {
      return new TableCell(
          child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new ScaleTransition(
                  scale: animation,
                  child: new Container(
                    width: 30.0,
                    height: 44.0,
                    decoration: new BoxDecoration(
                      color: Colors.purple[300],
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0)),
                    ),
                    child: new Center(
                      child: new Text(_displayText,
                          style: new TextStyle(
                              color: Colors.black, fontSize: 24.0)),
                    ),
                  ))));
    }
  }
}
