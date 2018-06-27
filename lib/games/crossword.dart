import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/unit_button.dart';

class Crossword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;
  Crossword(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false,
      this.gameConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new CrosswordState();
}

class CrosswordState extends State<Crossword> {
  var flag1 = 0;
  var correct = 0;
  var keys = 0;
  var textsize = 24.0;
  Tuple2<List<List<String>>, List<Tuple4<String, int, int, Direction>>> data;
  List<String> _rightwords = [];
  List<String> _letters = new List();
  List<String> _data2 = new List();
  List<int> _data3 = new List();
  List<int> _flag = new List();
  List<String> _data1 = new List();
  List _sortletters = [];
  List _gridsize = [];
  bool _isLoading = true;
  String img, dragdata;
  int _rows, _cols, code, dindex, dcode;
  int len, _rightlen, j, k;
  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _letters = [];
    _data2 = [];
    _data1 = [];
    _data3 = [];
    _sortletters = [];
    _rightwords = [];
    data = await fetchCrosswordData(widget.gameConfig.gameCategoryId);

    data.item1.forEach((e) {
      e.forEach((v) {
        _data1.add(v);
      });
    });
    _rows = data.item1.length;
    _cols = data.item1[0].length;
    for (var i = 0; i < data.item2.length; i++) {
      _data2.add(data.item2[i].item1);
    }
    for (var i = 0; i < data.item2.length; i++) {
      _data3.add(data.item2[i].item2 * _rows + data.item2[i].item3);
    }
    _letters = _data1;
    len=_data2.length+1;
    if(len>14){
      len=14;
    }
    var rng = new Random();
    var i = 0, f = 0;
    for (; i < _letters.length; i++) {
      f = 0;
      for (var j = 0; j < _data3.length; j++) {
        if (i == _data3[j]) {
          f = 1;
        }
      }
      if (_letters[i] != null && f != 1) {
        if (rng.nextInt(2) == 1) {
          _rightwords.add(_letters[i]);
          _sortletters.add(_letters[i]);
          _sortletters.add(i);
        }
      }
      if (i == _letters.length - 1) {
        if (_rightwords.length != len) {
          i = 0;
          _rightwords = [];
          _sortletters = [];
        }
      }
    }
    for (var i = 1; i < _sortletters.length; i += 2) {
      _letters[_sortletters[i]] = '';
    }
    _rightlen = _rightwords.length;
    _rightwords.shuffle();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    _flag = [];
    print('flag ${_flag.length}');
    for (var i = 0; i < (_rows * _cols) + _rows * 2 + _cols * 2; i++) {
      _flag.add(0);
    }
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, int flag) {
    img = null;
    for (var i = 0; i < _data3.length; i++) {
      if (_data3[i] == index) {
        img = _data2[i];
        break;
      }
    }
    if (text != null || text == '') {
      return new MyButton(
          key: new ValueKey<int>(index),
          index: index,
          text: text,
          color1: 1,
          onAccepted: (dcindex) {
            flag1 = 0;
            dragdata = dcindex;
            dindex = int.parse(dragdata.substring(0, 3));
            dcode = int.parse(dragdata.substring(4));
            if (code == dcode) {
              var i = 0, flagtemp = 0;
              for (i; i < _sortletters.length; i++) {
                if (_rightwords[dindex - 100] == _sortletters[i] &&
                    index == _sortletters[++i] &&
                    _letters[index] == '') {
                  flag1 = 1;
                  break;
                }
              }
              setState(() {
                print('progress $correct $_rightlen ');
                if (flag1 == 1) {
                  _rightwords[dindex - 100] += '.';
                  _letters[index] = _sortletters[--i];
                  correct++;
                  widget.onScore(((1/_rightlen)*40).toInt());
                  widget.onProgress(correct / _rightlen);
                  if (correct == _rightlen) {
                    widget.onEnd();
                  }
                } else if (flag1 == 0 && _letters[index] == '') {
                  _flag[index] = 1;
                    _letters[index] = _rightwords[dindex - 100];
                    flagtemp = 1;
                  new Future.delayed(const Duration(milliseconds: 700), () {
                    setState(() {
                       widget.onScore(-((1/_rightlen)*20).toInt());
                      _flag[index] = 0;
                      if (flagtemp == 1) {
                        _letters[index] = '';
                        flagtemp = 0;
                      }
                    });
                  });
                }
              });
            }
          },
          flag: flag,
          grid: _gridsize,
          textsize: textsize,
          code: code,
          onDrag: () {
          setState(() {});},
          isRotated: widget.isRotated,
          img: img,
          keys: keys++);
    } else {
      return new MyButton(
          key: new ValueKey<int>(index),
          index: index,
          text: '',
          color1: 0,
          flag: flag,
          textsize: textsize,
          onAccepted: (text) {},
          code: code,
          grid: _gridsize,
          isRotated: widget.isRotated,
          img: img,
          onDrag: () {
          setState(() {});},
          keys: keys);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    // if (media.orientation == Orientation.portrait) {
    //   if (_rightlen > _cols) {
    //     while (_rightwords.length <= _cols * 2) {
    //       _rightwords.add(null);
    //     }
    //   } else {
    //     while (_rightwords.length <= _cols) {
    //       _rightwords.add(null);
    //     }
    //   }
    // } else {
    //   while (_rightwords.length <= _rows * 2) {
    //     _rightwords.add(null);
    //   }
    // }
    return new LayoutBuilder(builder: (context, constraints) {
      keys = 0;
      j = 0;
      k = 100;
      var l=(_rows*_cols)-1;
      var rwidth, rheight;
      rwidth = constraints.maxWidth;
      rheight = constraints.maxHeight;
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      final isPortait = rwidth < rheight * 1.2;

      double maxWidth = (constraints.maxWidth - hPadding * 2) /
          (isPortait ? _cols : _cols + _rows + _rightlen > _cols ? 2 : 1);
      double maxHeight = (constraints.maxHeight - vPadding * 2) /
          (isPortait ? _rows + 1+(_rightlen > _cols ? 2 : 1) : _cols);
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      return new Container(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          child: rwidth < rheight * 1.2
              ? new Column(
                  // portrait mode
                  children: <Widget>[
                      new Expanded(
                        child:new Container(
                          color:Color(0xFFD32F2F),
                          child: ResponsiveGridView(
                        rows: _rows,
                        cols: _cols,
                        children: _letters
                            .map((e) =>Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child:_buildItem(j, e, _flag[j++]))
                      ).toList(growable: false)))),
                      new Padding(padding:new EdgeInsets.all(buttonPadding)),
                     new Container(
                          color:Colors.white,
                       child:new ResponsiveGridView(
                        rows: _rightlen > _cols ? 2 : 1,
                        cols: _cols,
                        children: _rightwords
                            .map((e) =>Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(k++, e, _flag[j++]))
                      ).toList(growable: false)))
                    ])
              : new Row(
                  // landsape mode
                  children: <Widget>[
                    new Expanded(
                      child:new Container(
                          color:Colors.white,
                       child:
                      new ResponsiveGridView(
                        rows: _cols,
                        cols: _rightlen > _cols ? 2 : 1,
                        children: _rightwords
                            .map((e) =>Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(k++, e, _flag[l++]))
                      ).toList(growable: false)))),
                       new Expanded(
                         flex: 4,
                           child:new Container(
                          color:Color(0xFFD32F2F),
                         child: new ResponsiveGridView(
                        rows: _rows,
                        cols: _cols,
                        children: _letters
                            .map((e) =>Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(j, e, _flag[j++]))
                      ).toList(growable: false))))
                    ]));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.code,
      this.isRotated,
      this.textsize,
      this.img,
      this.onDrag,
      this.grid,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  final DragTargetAccept onAccepted;
  final keys;
  final textsize;
  final List grid;
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String newtext = '';
  var f = 0;
  var i = 0;
  initState() {
    super.initState();
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -3.0, end: 3.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index < 100 && widget.color1 != 0) {
      return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.flag == 1 ? animation1 : animation,
            child: new ScaleTransition(
                scale: animation,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: new DragTarget(
                    onAccept: (String data) => widget.onAccepted(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new UnitButton(
                        key: new Key('A${widget.keys}'),
                        text: widget.text,
                        bgImage: widget.img,
                        showHelp: false,
                        highlighted: widget.flag==1?true:false,
                      );
                    },
                  ),
                ))),
      );
    } else if (widget.index >= 100 &&
        (widget.text == '' || widget.text.length == 2)) {
      if (widget.text == '') {
        newtext = '';
      } else {
        newtext = widget.text[0];
      }
      return new ScaleTransition(
          scale: animation,
          child: new UnitButton(
            key: new Key('A${widget.keys}'),
            text: newtext,
            showHelp: false,
            disabled: true,
          ));
    } else if (widget.index >= 100) {
      return new Draggable(
        onDragStarted: widget.onDrag,
        data: '${widget.index}' + '_' + '${widget.code}',
        child: new ScaleTransition(
            scale: animation,
            child: new UnitButton(
              key: new Key('A${widget.keys}'),
              text: widget.text,
              showHelp: false,
            )),
        //  childWhenDragging: new Container(),
        feedback: UnitButton(
          text: widget.text,
        ),
      );
    } else {
      return new ScaleTransition(
          scale: animation,
          child: new UnitButton(
            key: new Key('A${widget.keys}'),
            text: widget.text,
            disabled: true,
            showHelp: false,
          ));
    }
  }
}
