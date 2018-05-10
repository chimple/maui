import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

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
      this.isRotated = false,
      this.gameCategoryId})
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
  bool _isLoading = true;
  String img, dragdata;
  int _rows, _cols, code, dindex, dcode;
  int len, _rightlen, _rightcols, j, k;
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
    data = await fetchCrosswordData(widget.gameCategoryId);

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
    switch (_data2.length) {
      case 3:
        {
          len = 4;
          break;
        }
      case 4:
        {
          len = 5;
          break;
        }
      case 5:
        {
          len = 6;
          break;
        }
      case 6:
        {
          len = 7;
          break;
        }
      case 7:
        {
          len = 8;
          break;
        }
      case 8:
        {
          len = 9;
          break;
        }
      case 9:
        {
          len = 10;
          break;
        }
      case 10:
        {
          len = 11;
          break;
        }
      case 11:
        {
          len = 12;
          break;
        }
      case 12:
        {
          len = 13;
          break;
        }
      case 13:
        {
          len = 14;
          break;
        }
      default:
        {
          len = 14;
        }
    }
    var rng = new Random();
    var i = 0;
    for (; i < _letters.length; i++) {
      if (_letters[i] != null) {
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
    _rightlen = _rightcols = _rightwords.length;
    _rightwords.shuffle();
    // if(_rightlen>6){
    //   _rightcols=(_rightlen/2).floor()!=_rightlen/2?
    //   ((_rightlen/2).floor()+1)*2:(_rightlen/2).floor()*2;
    //    while(_rightwords.length<=_rightcols){
    //     _rightwords.add('');
    //   }
    // }
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
                if (flag1 == 1) {
                  _rightwords[dindex - 100] += '.';
                  _letters[index] = _sortletters[--i];
                  correct++;
                  widget.onScore(2);
                  widget.onProgress(correct / _rightlen);
                  if (correct == _rightlen) {
                    widget.onEnd();
                    widget.onEnd();
                  }
                } else if (flag1 == 0 && _letters[index] == '') {
                  _flag[index] = 1;
                  if (_letters[index] == '') {
                    _letters[index] = _rightwords[dindex - 100];
                    flagtemp = 1;
                  }

                  new Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
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
          textsize: textsize,
          code: code,
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
          isRotated: widget.isRotated,
          img: img,
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
    if (media.orientation == Orientation.portrait) {
      if (_rightlen > _cols) {
        while (_rightwords.length <= _cols * 2) {
          _rightwords.add(null);
        }
      } else {
        while (_rightwords.length <= _cols) {
          _rightwords.add(null);
        }
      }
    } else {
      while (_rightwords.length <= _rows * 2) {
        _rightwords.add(null);
      }
    }
    return new LayoutBuilder(builder: (context, constraints) {
      keys = 0;
      j = 0;
      k = 100;
      var rwidth, rheight;
      rwidth = constraints.maxWidth;
      rheight = constraints.maxHeight;
      if (rheight < 300) {
        textsize = 11.0;
      }
      print('rightr len  ${_rightwords.length}');
      print(rheight);
      return new Container(
          padding: media.orientation == Orientation.portrait
              ? new EdgeInsets.symmetric(
                  vertical: rheight * .04, horizontal: rwidth * .12)
              : new EdgeInsets.symmetric(vertical: rheight * .03),
          color: new Color(0xffffE0DEE1),
          child: media.orientation == Orientation.portrait
              ? new Column(
                  // portrait mode
                  children: <Widget>[
                    new Flexible(
                      flex: 4,
                      child: new ResponsiveGridView(
                        rows: _rows,
                        cols: _cols,
                        maxAspectRatio: rwidth / (rheight * 0.65),
                        children: _letters
                            .map((e) => _buildItem(j, e, _flag[j++]))
                            .toList(growable: false),
                      ),
                    ),
                    new Flexible(
                      // flex:1,
                      //   widthFactor: _cols>_finalcols?0.75:null,
                      //  alignment: Alignment.center,
                      child: new ResponsiveGridView(
                        rows: _rightlen > _cols ? 2 : 1,
                        cols: _cols,
                        padding: rheight < 300.0
                            ? _rightlen > _cols
                                ? 2.0
                                : 4.0
                            : 4.0,
                        maxAspectRatio: rheight < 300.0
                            ? _rightlen > _cols
                                ? rwidth / (rheight * 0.38)
                                : rwidth / (rheight * 0.58)
                            : rwidth / (rheight * 0.58),
                        children: _rightwords
                            .map((e) => _buildItem(k++, e, _flag[j++]))
                            .toList(growable: false),
                      ),
                    ),
                  ],
                )
              : new Row(
                  // landsape mode
                  children: <Widget>[
                    new Flexible(
                      flex: 3,
                      child: new ResponsiveGridView(
                        rows: _rows,
                        cols: _cols,
                        maxAspectRatio: rwidth / (rheight * 1.1),
                        children: _letters
                            .map((e) => _buildItem(j, e, _flag[j++]))
                            .toList(growable: false),
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(rwidth * .03)),
                    new Flexible(
                      // child:new FractionallySizedBox(
                      //     heightFactor: _rightlen<6?0.5:null,
                      //     alignment: Alignment.center,
                      child: new ResponsiveGridView(
                        rows: _rows,
                        cols: 2,
                        maxAspectRatio: rwidth / (rheight * 1.3),
                        children: _rightwords
                            .map((e) => _buildItem(k++, e, _flag[j++]))
                            .toList(growable: false),
                      ),
                    ),
                  ],
                ));
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
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;
  String newtext = '';
  var f = 0;
  var i = 0;
  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -5.0, end: 5.0).animate(controller1);
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
    // RenderBox getBox = context.findRenderObject();
    MediaQueryData media = MediaQuery.of(context);
 //   print('height ${getBox.}');
    return new LayoutBuilder(builder: (context, constraints) {
      print('hi    ${constraints.maxHeight}');
      if (widget.index < 100 && widget.color1 != 0) {
        return new ScaleTransition(
          scale: animation,
          child: new Shake(
              animation: widget.flag == 1 ? animation1 : animation,
              child: new ScaleTransition(
                  scale: animation,
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: new Color(0xffff37A061),
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
                        return new Container(
                          decoration: new BoxDecoration(
                            color: widget.flag == 1
                                ? Colors.redAccent
                                : new Color(0xffff37A061),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(8.0)),
                            image: widget.img != null
                                ? new DecorationImage(
                                    image: new AssetImage(widget.img),
                                    fit: BoxFit.contain)
                                : null,
                          ),
                          child: new Center(
                            child: new Text(widget.text,
                                overflow: TextOverflow.clip,
                                key: new Key('A${widget.keys}'),
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontSize: widget.textsize,
                                    fontWeight: FontWeight.bold)),
                          ),
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
            child: new Container(
              decoration: new BoxDecoration(
                color: widget.text == ''
                    ? new Color(0xffffE0DEE1)
                    : Color(0xffffEAE8E4),
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new Center(
                child: new Text(newtext,
                    overflow: TextOverflow.clip,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: widget.textsize,
                        fontWeight: FontWeight.bold)),
              ),
            ));
      } else if (widget.index >= 100) {
        return new Draggable(
          data: '${widget.index}' + '_' + '${widget.code}',
          child: new ScaleTransition(
              scale: animation,
              child: new Container(
                decoration: new BoxDecoration(
                  color: widget.color1 == 1
                      ? Color(0xffff37A061)
                      : Color(0xffffE0DEE1),
                  borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                ),
                child: new Center(
                  child: new Text(_displayText,
                      overflow: TextOverflow.clip,
                      key: new Key('B${widget.keys}'),
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: widget.textsize,
                          fontWeight: FontWeight.bold)),
                ),
              )),
          //  childWhenDragging: new Container(),
          feedback: new Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                color: Color(0xffff37A061)),
            child: new Center(
              child: new Transform.rotate(
                angle: widget.isRotated == true
                    ? media.orientation == Orientation.portrait ? 3.14 : 0.0
                    : 0.0,
                alignment: Alignment.center,
                child: new Text(
                  widget.text,
                  overflow: TextOverflow.clip,
                  style: new TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: widget.textsize,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      } else {
        return new ScaleTransition(
            scale: animation,
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new Center(
                child: new Text(_displayText,
                    overflow: TextOverflow.clip,
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: widget.textsize,
                        fontWeight: FontWeight.bold)),
              ),
            ));
      }
    });
  }
}
