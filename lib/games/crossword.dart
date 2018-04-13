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
  Tuple2<List<List<String>>, List<Tuple4<String, int, int, Direction>>> data;
  List<String> _rightwords = [];
  List<String> _letters = new List();
  List<String> _data2 = new List();
  List<int> _data3 = new List();
  List<int> _flag = new List();
  List<String> _data1 = new List();
  List _sortletters = [];
  bool _isLoading = true;
  String img;
  int _rows,_cols;
  int len;
  @override
  void initState() {
    super.initState();
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
  _rows=data.item1.length;
  _cols=data.item1[0].length;
  //print('lengtttt  ${data.item1[0]}');
    for (var i = 0; i < data.item2.length; i++) {
      _data2.add(data.item2[i].item1);
    }
    for (var i = 0; i < data.item2.length; i++) {
      _data3.add(data.item2[i].item2 * _rows + data.item2[i].item3);
    }
    _letters = _data1;
    switch(_data2.length){
      case 3 :{len=4;break;}
      case 4:{len=5;break;}
      case 5:{len=6;break;}
      case 6:{len=7;break;}
      case 7:{len=8;break;}
      case 8:{len=9;break;}
      case 9:{len=10;break;}
      case 10:{len=11;break;}
      default:{len=5;}
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
    _rightwords.shuffle();

    _flag.length = _letters.length + _rows + _cols;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, int flag) {
    final TextEditingController t1 = new TextEditingController(text: text);
    img=null;
    for (var i=0; i < _data3.length; i++) {
        if (_data3[i] == index) {
         img=_data2[i];
          break;
        }
      }
    if (text != null) {
      return new MyButton(
          index: index,
          text: text,
          color1: 1,
          onAccepted: (dindex) {
            flag1 = 0;
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
                _rightwords[dindex - 100]+= '.';
              //   print(' helo ${_rightwords[dindex - 100][1]}');
                _letters[index] = _sortletters[--i];
                correct++;
                widget.onScore(1);
                widget.onProgress(correct / _rightwords.length);
                if (correct == _rightwords.length) {
                  widget.onEnd();
                  widget.onEnd();
                }
              } else if (flag1 == 0) {
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
          },
          flag: flag,
          img: img,
          keys: keys++);
    } else {
      return new MyButton(
          index: index,
          text: '',
          color1: 0,
          flag: flag,
          onAccepted: (text) {},
          img: img,
          keys: keys);
    }
  }

  @override
  Widget build(BuildContext context) {
    int portf=0;
    MediaQueryData media = MediaQuery.of(context);
    if(media.size.height<media.size.width){
      portf=1;
    }
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    keys = 0;
    var j = 0, h = 0, k = 100;
    return new Container(
        color: Colors.purple[300],
        child: portf==0?new Column(
          children: <Widget>[
            //   new Padding(padding: new EdgeInsets.all(10.0)),
            new Flexible(
              flex: 4,
              child: new ResponsiveGridView(
                rows: _rows,
                cols: _cols,
                // childAspectRatio: 0.8,
                // mainAxisSpacing:9.0,
                //crossAxisSpacing:9.0,
                padding: const EdgeInsets.all(20.0),
                children: _letters
                    .map((e) => _buildItem(j++, e, _flag[h++]))
                    .toList(growable: false),
              ),
            ),
            //  new Padding(padding: new EdgeInsets.all(5.0)),
            new Expanded(
              child: new ResponsiveGridView(
                rows: 1,
                cols: _rightwords.length,
                // childAspectRatio: 2.3,
                padding: const EdgeInsets.all(14.0),
                //crossAxisSpacing: 9.0,
                children: _rightwords
                    .map((e) => _buildItem(k++, e, _flag[h++]))
                    .toList(growable: false),
              ),
            )
          ],
        ):new Row(
          children: <Widget>[
            new Flexible(
              flex: 4,
              child: new ResponsiveGridView(
                rows: _rows,
                cols: _cols,
                padding: const EdgeInsets.all(20.0),
                children: _letters
                    .map((e) => _buildItem(j++, e, _flag[h++]))
                    .toList(growable: false),
              ),
            ),
            new Expanded(
              child: new ResponsiveGridView(
                rows: _rightwords.length,
                cols: 1,
                padding: const EdgeInsets.all(14.0),
                children: _rightwords
                    .map((e) => _buildItem(k++, e, _flag[h++]))
                    .toList(growable: false),
              ),
            )
          ],
        ));
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.img,
      this.keys});
  final index;
  final int color1;
  final int flag;
  final String text;
  final String img;
  final DragTargetAccept onAccepted;
  final keys;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;
  List<Widget> feed1;
  String newtext;
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
                    color: Colors.yellow[500],
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: new DragTarget(
                    onAccept: (var data) => widget.onAccepted(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new Container(
                        decoration: new BoxDecoration(
                          color: widget.flag == 1
                              ? Colors.redAccent
                              : Colors.yellow[500],
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(8.0)),
                          image:widget.img!=null
                              ? new DecorationImage(
                                  image: new AssetImage(widget.img),
                                  fit: BoxFit.contain)
                              : null,
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
                ))),
      );
    } else if (widget.index >= 100 && widget.text.length == 2) {
       newtext=widget.text[0];
      return new ScaleTransition(
          scale: animation,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.grey[300],
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            ),
            child: new Center(
              child: new Text(newtext,
                  style: new TextStyle(color: Colors.black, fontSize: 24.0)),
            ),
          ));
    } else if (widget.index >= 100) {
      return new Draggable(
        data: widget.index,
        child: new ScaleTransition(
            scale: animation,
            child: new Container(
              decoration: new BoxDecoration(
                color: widget.color1 == 1
                    ? Colors.yellow[500]
                    : Colors.purple[300],
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new Center(
                child: new Text(_displayText,
                    key: new Key('B${widget.keys}'),
                    style: new TextStyle(color: Colors.black, fontSize: 24.0)),
              ),
            )),
        childWhenDragging: new Container(),
        feedback:new Container(
       //   transform: new Matrix4.identity().,
          height: 45.0,
          width: 58.0,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              color: Colors.yellow[400]),
          child: new Center(
            child: new Text(
              widget.text,
              style: new TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 26.0,
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
              color: Colors.purple[500],
              borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            ),
            child: new Center(
              child: new Text(_displayText,
                  style: new TextStyle(color: Colors.black, fontSize: 24.0)),
            ),
          ));
    }
  }
}
