import 'dart:async';
import 'dart:math';
import 'package:maui/games/single_game.dart';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

class Wordgrid extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Wordgrid(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new WordgridState();
}

enum Status { Draggable, First , Dragtarget }
enum ShakeCell { Right, InActive, Dance, CurveRow }

class WordgridState extends State<Wordgrid> {
  int _maxSize;
  int _otherSize;
  int totalgame = 2;
  var size, _size;
  String words = '';
  bool _isShowingFlashCard = false;
  List<Status> _statuses;
  bool _isLoading = true;
  List<double> cdlist = [];
  List<int> cdletters = [];
  List<String> newletters = [];
  Tuple2<List<String>, List<String>> data;
  List<String> temp = [];
  List<int> tempindex=[];
  List<bool> _visibleflag=[];
  var progress = 0;
  int endflag = 0;
  int code;
  int lastclick;
  int tries = 0;
  List<ShakeCell> _ShakeCells = [];
  List<int> clicks = [];
  @override
  void initState() {
    super.initState();
    _initBoard();
    if (widget.gameConfig.level < 4) {
      _maxSize = 3;
      _otherSize = 1;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 5;
      _otherSize = 4;
    } else {
      _maxSize = 7;
      _otherSize = 9;
    }
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    data = await fetchWordData(
        widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
    print('original data $data');
    print("this data 1 ${data.item1}");
    print('data 2 ${data.item2}');
    var f = 4;
    while (data.item1.length != _maxSize || data.item2.length < _otherSize) {
      print('hi');
      data = await fetchWordData(
          widget.gameConfig.gameCategoryId, _maxSize, _otherSize);
      f--;
      if (f == 0) {
        print('hi22');
        _maxSize = 4;
        _otherSize = 5;
        f = 10;
      }
      if (f == 7) {
        print('lastttt dataa');
        _maxSize = 3;
        _otherSize = 1;
      }
      if (f == 5) {
        break;
      }
    }
    _size = sqrt(data.item1.length + _otherSize).toInt();
    size = _size;
    data.item1.forEach((e) {
      words = words + e;
    });
    var rng = new Random();
    cdlist = [];
    for (var i = 0; i < _size; i++) {
      for (var j = 0; j < _size; j++) {
        cdlist.add(i + j / 10);
      }
    }
    var cflag = 1;
    while (cflag == 1) {
      var start = 0;
      if (_size < 3) {
        if (rng.nextInt(3) == 1)
          start = 0;
        else
          start = 1;
      } else if (rng.nextInt(3) == 1) {
        print('123233');
        start = rng.nextInt( _size);
      } else {
        print('99993');
        start = rng.nextInt(_size * _size - 2);
      }
     print('start $start $cdlist');
      var cdstart = cdlist[start];
      int eflag = 1;
      _fun(int m, int p, int q) {
        switch (m) {
          case 1:
            for (var i = 0; i < cdletters.length; i++) {
              if (p * _size + (q + 1) == cdletters[i]) {
                return false;
              }
            }
            return true;
          case 2:
            for (var i = 0; i < cdletters.length; i++) {
              if ((p + 1) * _size + q == cdletters[i]) {
                return false;
              }
            }
            return true;
          case 3:
            for (var i = 0; i < cdletters.length; i++) {
              if (p * _size + (q - 1) == cdletters[i]) {
                return false;
              }
            }
            return true;
          case 4:
            for (var i = 0; i < cdletters.length; i++) {
              if ((p - 1) * _size + q == cdletters[i]) {
                return false;
              }
            }
            return true;
        }
      }

      while (eflag == 1) {
        eflag = 0;
        var p = cdstart.toInt();
        var q = ((cdstart - p) * 10).toInt();
        var len = 0;
        var top = 1;
        cdletters = [];
        var rand =
            rng.nextInt(3) == 1;
        while (len < data.item1.length) {
          cflag = 0;
          if (q + 1 < _size && _fun(1, p, q) && !rand && top < 2) {
            cdletters.add(p * _size + (q + 1));
            q++;
            top = 1;
          } else if (p + 1 < _size && _fun(2, p, q) && top < 3) {
            cdletters.add((p + 1) * _size + q);
            p++;
            top = 2;
          } else if (q + 1 < _size && _fun(1, p, q) && rand && top < 2) {
            cdletters.add(p * _size + (q + 1));
            q++;
            top = 1;
          } else if (q - 1 >= 0 && _fun(3, p, q) && top < 4) {
            cdletters.add(p * _size + (q - 1));
            q--;
            top = 3;
          } else if (p - 1 >= 0 && _fun(4, p, q) && top < 5) {
            cdletters.add((p - 1) * _size + q);
            p--;
            top = 4;
          } else {
            print('exit 2 breakkkkk');
            cflag = 1;
            break;
          }
          len++;
          if (len > 4) {
            top = top;
          } else {
            top = 1;
          }
        }
        if (cdletters.length != data.item1.length) {
          eflag = 1;
        }
      }
    }
    newletters = [];
    newletters.length = data.item1.length + _otherSize;
    for (var i = 0; i < cdletters.length; i++) {
      newletters[cdletters[i]] = data.item1[i];
    }

    for (var i = 0, j = 0; i < newletters.length; i++) {
      if (newletters[i] == null) {
        newletters[i] = data.item2[j];
        j++;
      }
    }
    _statuses = [];
    _statuses = newletters.map((a) => Status.Draggable).toList(growable: false);
     _visibleflag = newletters.map((a) => false).toList(growable: false);
    _ShakeCells =
        newletters.map((a) => ShakeCell.InActive).toList(growable: false);
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Wordgrid oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  Widget _buildItem(int index, String text, Status status, ShakeCell tile,bool vflag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        code: code,
        vflag:vflag,
        onStart: () {
          setState(() {
            temp.add(text);
            tempindex.add(index);
            lastclick = index;
            _visibleflag[index]=true;
            _statuses[index]=Status.First;
            for (var i = 0; i < newletters.length; i++) {
              if (_statuses[i] == Status.Draggable&& index!=i) {
                _statuses[i] = Status.Dragtarget;
              }
            }
          });
        },
        onwill: (data) {         
        if (data == code && _visibleflag[index]==false) {
            if (lastclick % size == 0) {
              if (index == lastclick + 1 ||
                  index == lastclick + size ||
                  index == lastclick - size) {
                setState(() {
                  _visibleflag[index]=true;
                  lastclick = index;
                });
                temp.add(text);
                tempindex.add(index);
                _statuses[tempindex[0]]=Status.Dragtarget;
                return true;
              } else
                return false;
            } else if ((lastclick + 1) % size == 0) {
              if (index == lastclick - 1 ||
                  index == lastclick + size ||
                  index == lastclick - size) {
                setState(() {
                  _visibleflag[index]=true;
                  lastclick = index;
                });
                temp.add(text);
                tempindex.add(index);
                _statuses[tempindex[0]]=Status.Dragtarget;
                return true;
              } else
                return false;
            } else if (index == lastclick + 1 ||
                index == lastclick - 1 ||
                index == lastclick + size ||
                index == lastclick - size) {
              setState(() {
                _visibleflag[index]=true;
                lastclick = index;
              });
              temp.add(text);
              tempindex.add(index);
              _statuses[tempindex[0]]=Status.Dragtarget;
              return true;
            } else
              return false;
          } 
          else if(data == code && _visibleflag[index]==true){
            if(index==tempindex[tempindex.length-2]){
            setState(() {
                  _visibleflag[tempindex.last] =false;
                  tempindex.removeLast();
                  temp.removeLast();
                  lastclick=tempindex.last;
                });
                return true;}
                else return false;
          }
            return false;
        },
        onCancel: (v, g) {
          print('cancelled  $v  $g');
          lastclick = -1;
          int flag = 0;
          if (data.item1.length == temp.length) {
            for (var i = 0; i < temp.length; i++) {
              if (temp[i] != data.item1[i]) {
                flag = 1;
                break;
              }
            }
          } else {
            flag = 1;
          }
          if (flag == 1) {
            temp = [];
            tempindex=[];
            tries += 5;
            setState(() {
            for (var i = 0; i < _visibleflag.length; i++) 
            _visibleflag[i] == true?_ShakeCells[i] = ShakeCell.Right:i;                
                });
            new Future.delayed(const Duration(milliseconds: 800), () {
              setState(() {
                _ShakeCells = newletters
                    .map((a) => ShakeCell.InActive)
                    .toList(growable: false);
                _statuses = newletters
                    .map((a) => Status.Draggable)
                    .toList(growable: false);
                 _visibleflag = newletters
                    .map((a) => false)
                    .toList(growable: false);
              });
            });
          } else {
            widget.onScore(((40 - tries) ~/ totalgame));
            widget.onProgress(1.0);
            endflag = 1;
            new Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                _isShowingFlashCard = true;
              });
            });
          }      
        });
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
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 1);
      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      if (_isShowingFlashCard) {
        return FractionallySizedBox(
            widthFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.9 : 0.65,
            heightFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.9 : 0.9,
            child: new FlashCard(
                text: words,
                image: words,
                onChecked: () {
                  widget.onEnd(); // _initBoard();
                  setState(() {
                    _isShowingFlashCard = false;
                    endflag = 0;
                    words = '';
                    temp = [];
                    tempindex=[];
                    tries = 0;
                  });
                }));
      }
      var j = 0;
      return new Column(
        children: [
          new LimitedBox(
              maxHeight: maxHeight,
              child: new Material(
                  color: Colors.orange,
                  elevation: 4.0,
                  textStyle: new TextStyle(
                      color: Colors.white,
                      fontSize: state.buttonFontSize / 1.3),
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(buttonPadding / 2.0),
                          child: UnitButton(
                            text: words,
                            bgImage: 'assets/dict/${words.toLowerCase()}.png',
                            primary: false,
                            onPress: () {},
                            unitMode: UnitMode.image,
                          ))))),
          new Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: _size,
                    cols: _size,
                    children: newletters
                        .map((e) => Padding(
                            padding: EdgeInsets.all(buttonPadding),
                            child: _buildItem(
                                j, e, _statuses[j], _ShakeCells[j],_visibleflag[j++])))
                        .toList(growable: false),
                  )))
        ],
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.status,
      this.tile,
      this.code,
      this.vflag,
      this.onStart,
      this.onCancel,
      this.onwill})
      : super(key: key);

  final String text;
  Status status;
  ShakeCell tile;
  final DraggableCanceledCallback onCancel;
  final DragTargetWillAccept onwill;
  final VoidCallback onStart;
  final int code;
  final bool vflag;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  String _displayText;
   Velocity v;
   Offset o;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (!widget.text.isEmpty) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -2.0, end: 2.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Shake(
        animation:
            widget.tile == ShakeCell.Right ? animationWrong : animationRight,
        child: new ScaleTransition(
            scale: animationRight,
            child: widget.status == Status.Dragtarget
                ? new DragTarget(
                  onAccept: (int d)=>(widget.tile == ShakeCell.Right||widget.status == Status.First)?{}:widget.onCancel(v,o),
                    onWillAccept: (int data) => (widget.tile == ShakeCell.Right||widget.status == Status.First)?{}:widget.onwill(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new Material(
                        elevation: widget.vflag==true?8.0:0.0,
                        color: Colors.transparent,
                     child:new UnitButton(
                        highlighted:
                            widget.vflag==true ? true : false,
                        text: _displayText,
                        onPress: () => {},
                        unitMode: UnitMode.text,
                        showHelp: false,
                      ));
                    })
                : new Draggable(
                    onDragStarted: () => widget.tile == ShakeCell.Right?{}:widget.onStart(),
                    onDraggableCanceled: (v, g) => widget.tile == ShakeCell.Right?{}:widget.onCancel(v, g),
                    data: widget.code,
                    feedback: new Container(),
                    child: new UnitButton(
                      highlighted:widget.vflag==true?true:false,
                      text: _displayText,
                      onPress: () => {},
                      unitMode: UnitMode.text,
                      showHelp: false,
                    ))));
  }
}
