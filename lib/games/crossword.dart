import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/gameaudio.dart';

class Crossword extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;
  Crossword(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.onTurn,
      this.iteration,
      this.isRotated = false,
      this.gameConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new CrosswordState();
}

class CrosswordState extends State<Crossword> {
  static var rand = new Random();
  Tuple2<List<List<String>>, List<Tuple4<String, int, int, Direction>>> data =
      (rand.nextInt(2)) == 0
          ? new Tuple2([
              ['E', null, null, null, null],
              ['A', null, null, null, null],
              ['T', 'I', 'G', 'E', 'R'],
              [null, null, null, null, 'A'],
              [null, null, null, null, 'T']
            ], [
              new Tuple4('assets/apple.png', 0, 0, Direction.down),
              new Tuple4('assets/apple.png', 2, 0, Direction.across),
              new Tuple4('assets/apple.png', 2, 4, Direction.down),
            ])
          : new Tuple2([
              ['C', 'A', 'T', null, null, 'E'],
              [null, 'N', null, null, null, 'G'],
              [null, 'T', 'I', 'G', 'E', 'R'],
              [null, null, 'B', null, null, 'E'],
              [null, null, 'E', null, null, 'T'],
              [null, 'O', 'X', 'E', 'N', null]
            ], [
              new Tuple4('assets/apple.png', 0, 0, Direction.across),
              new Tuple4('assets/apple.png', 0, 1, Direction.down),
              new Tuple4('assets/apple.png', 0, 5, Direction.down),
              new Tuple4('assets/apple.png', 2, 1, Direction.across),
              new Tuple4('assets/apple.png', 2, 2, Direction.down),
              new Tuple4('assets/apple.png', 5, 1, Direction.across)
            ]);
  List<String> _rightwords = [];
  List<String> _letters = [];
  List<String> _images = [];
  List<int> _data3 = [];
  List<int> _flag = [];
  List _sortletters = [];
  bool _isLoading = true;
  String img, dragdata;
  int _rows, _cols, code, dindex, dcode;
  int len, _rightlen, j, k, l;
  var flag1, correct, keys;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    // _data3.removeRange(0, _data3.length);
    // _sortletters.removeRange(0, _sortletters.length);
    // _rightwords.removeRange(0, _rightwords.length);
    // _letters.removeRange(0, _letters.length);
    // _rightlen = 0;
    correct = 0;
    //  flag1 = 0;
    // _letters.removeRange(0, _letters.length);
    // _images.removeRange(0, _images.length);
    // _flag.removeRange(0, _flag.length);
    // _rows = 0;
    // _cols = 0;
    // j = 0;
    // k = 0;
    keys = 0;
    // l = 0;
    // data = await fetchCrosswordData(widget.gameConfig.gameCategoryId);
    print('data camee $data');
    data.item1.forEach((e) {
      e.forEach((v) {
        _letters.add(v);
      });
    });
    _rows = data.item1.length;
    _cols = data.item1[0].length;
    for (var n = 0; n < data.item2.length; n++) {
      _data3.add(data.item2[n].item2 * _rows + data.item2[n].item3);
    }
    len = _data3.length + 1;
    if (len > 14) {
      len = 14;
    }
    var rng = new Random();
    var f = 0;
    for (var t = 0; t < _letters.length; t++) {
      f = 0;
      for (var j = 0; j < _data3.length; j++) {
        if (t == _data3[j]) {
          f = 1;
        }
      }
      if (_letters[t] != null && f != 1) {
        if (rng.nextInt(2) == 1) {
          _rightwords.add(_letters[t]);
          _sortletters.add(_letters[t]);
          _sortletters.add(t);
        }
      }
      if (t == _letters.length - 1) {
        if (_rightwords.length != len) {
          t = 0;
          _rightwords = [];
          _sortletters = [];
        }
      }
    }
    for (var p = 1; p < _sortletters.length; p += 2) {
      _letters[_sortletters[p]] = '';
    }
    _rightlen = _rightwords.length;
    _rightwords.shuffle();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    for (var k = 0; k < (_rows * _cols) + _rows * 2 + _cols * 2; k++) {
      _flag.add(0);
    }
    _data3.add(null);
    _images.length = _letters.length;
    for (var m = 0, j = 0; m < _letters.length; m++) {
      if (m == _data3[j]) {
        _images[m] = data.item2[j].item1;
        j++;
      } else
        _images[m] = null;
    }
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Crossword oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  Widget _buildItem(int index, String text, int flag, String img) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: text == null ? 0 : 1,
        flag: flag,
        code: code,
        onDrag: () {
          setState(() {});
        },
        isRotated: widget.isRotated,
        img: img,
        onAccepted: (text == null)
            ? (e) {}
            : (dcindex) {
                flag1 = 0;
                dragdata = dcindex;
                dindex = int.parse(dragdata.substring(0, 3));
                dcode = int.parse(dragdata.substring(4));
                if (code == dcode) {
                  var c = 0;
                  for (; c < _sortletters.length; c++) {
                    if (_rightwords[dindex - 100] == _sortletters[c] &&
                        index == _sortletters[++c] &&
                        _letters[index] == '') {
                      flag1 = 1;
                      break;
                    }
                  }
                  if (flag1 == 1) {
                    setState(() {
                      _rightwords[dindex - 100] += '.';
                      _letters[index] = _sortletters[--c];
                      correct++;
                      widget.onScore(((1 / _rightlen) * 40).toInt());
                      widget.onProgress(correct / _rightlen);
                      print('progress $correct $_rightlen ');
                      if (correct == _rightlen) {
                        _images.removeRange(0, _images.length);
                        _data3.removeRange(0, _data3.length);
                        _sortletters.removeRange(0, _sortletters.length);
                        _rightwords.removeRange(0, _rightwords.length);
                        _letters.removeRange(0, _letters.length);
                        _rightlen = 0;
                        correct = 0;
                        flag1 = 0;
                        _flag.removeRange(0, _flag.length);
                        _rows = 0;
                        _cols = 0;
                        c = 0;
                        j = 0;
                        keys = 0;
                        l = 0;
                        k = 0;
                        widget.onEnd();
                      }
                    });
                  } else if (flag1 == 0 && _letters[index] == '') {
                    setState(() {
                      _flag[index] = 1;
                      _letters[index] = _rightwords[dindex - 100];
                    });
                    new Future.delayed(const Duration(milliseconds: 700), () {
                      setState(() {
                        widget.onScore(-((1 / _rightlen) * 20).toInt());
                        _flag[index] = 0;
                        _letters[index] = '';
                      });
                    });
                  }
                }
              }
        // keys: keys++
        );
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
    int j = 0;
    int inc = 0;
    int k = 100;
    int l = (_rows * _cols) - 1;
    return new LayoutBuilder(builder: (context, constraints) {
      var rwidth, rheight;
      rwidth = constraints.maxWidth;
      rheight = constraints.maxHeight;
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      final isPortait = rwidth < rheight * 1.2;

      double maxWidth = (constraints.maxWidth - hPadding * 2) /
          (isPortait ? _cols : _cols + _rows + _rightlen > _cols ? 2 : 1);
      double maxHeight = (constraints.maxHeight - vPadding * 2) /
          (isPortait ? _rows + 1 + (_rightlen > _cols ? 2 : 1) : _cols);
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      //  keys = 0;
      j = 0;
      inc = 0;
      k = 100;
      l = (_rows * _cols) - 1;
      print(
          'builded widget ${_flag.length}   $_rows $_cols ${_letters.length}');
      print('letters      $_letters');
      print(' right  words      $_rightwords');
      print('_images   is   ${_images.length}');
      print('sortletters    $_sortletters');
      return new Container(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          child: rwidth < rheight * 1.2
              ? new Column(
                  // portrait mode
                  children: <Widget>[
                      new Expanded(
                          child: new Container(
                              color: Color(0xFFD32F2F),
                              child: ResponsiveGridView(
                                  rows: _rows,
                                  cols: _cols,
                                  children: _letters
                                      .map((e) => Padding(
                                          padding:
                                              EdgeInsets.all(buttonPadding),
                                          child: _buildItem(inc, e, _flag[inc],
                                              _images[inc++])))
                                      .toList(growable: false)))),
                      new Padding(padding: new EdgeInsets.all(buttonPadding)),
                      new Container(
                          color: Colors.white,
                          child: new ResponsiveGridView(
                              rows: _rightlen > _cols ? 2 : 1,
                              cols: _cols,
                              children: _rightwords
                                  .map((r) => Padding(
                                      padding: EdgeInsets.all(buttonPadding),
                                      child: _buildItem(
                                          k++, r, _flag[inc++], null)))
                                  .toList(growable: false)))
                    ])
              : new Row(
                  // landsape mode
                  children: <Widget>[
                      new Expanded(
                          child: new Container(
                              color: Colors.white,
                              child: new ResponsiveGridView(
                                  rows: _cols,
                                  cols: _rightlen > _cols ? 2 : 1,
                                  children: _rightwords
                                      .map((e) => Padding(
                                          padding:
                                              EdgeInsets.all(buttonPadding),
                                          child: _buildItem(
                                              k++, e, _flag[l++], null)))
                                      .toList(growable: false)))),
                      new Expanded(
                          flex: 4,
                          child: new Container(
                              color: Color(0xFFD32F2F),
                              child: new ResponsiveGridView(
                                  rows: _rows,
                                  cols: _cols,
                                  children: _letters
                                      .map((e) => Padding(
                                          padding:
                                              EdgeInsets.all(buttonPadding),
                                          child: _buildItem(
                                              j, e, _flag[j], _images[j++])))
                                      .toList(growable: false))))
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
      this.img,
      this.onDrag,
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
  final VoidCallback onDrag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String newtext = '';
  String disptext;
  initState() {
    super.initState();
    disptext = widget.text == null ? '' : widget.text;
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
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
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
                        highlighted: widget.flag == 1 ? true : false,
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
        newtext = widget.text.substring(0, 1);
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
              text: disptext,
              showHelp: false,
            )),
        feedback: UnitButton(
          text: disptext,
          maxHeight: buttonConfig.height,
          maxWidth: buttonConfig.width,
          fontSize: buttonConfig.fontSize,
        ),
      );
    } else {
      return new ScaleTransition(
          scale: animation,
          child: new UnitButton(
            key: new Key('A${widget.keys}'),
            text: disptext,
            disabled: true,
            showHelp: false,
          ));
    }
  }
}
