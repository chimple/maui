import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/jamaica/state/game_utils.dart';

class WordGridGame extends StatefulWidget {
  final List<String> answer;
  final List<String> choice;
  final OnGameOver onGameOver;

  WordGridGame({key, this.answer, this.choice, this.onGameOver})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new WordGridGameState();
}

enum Status { first, draggable, dragTarget }
enum ShakeCell { shake, inactive }

class WordGridGameState extends State<WordGridGame> {
  int _size;
  String words = '';
  List<Status> _status;
  List<String> finalLetter = [];
  List<String> temp = [];
  List<int> tempIndex = [];
  List<bool> _visibleFlag = [];
  bool stopDrag = false;
  int code;
  int lastClick;
  int tries = 0;
  List<Offset> _pointsSend = <Offset>[];
  List<ShakeCell> _shakeCells = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    List<double> cdlist = [];
    List<int> cdletters = [];
    _size = sqrt(widget.answer.length + widget.choice.length).toInt();
    widget.answer.forEach((e) {
      words = words + e;
    });
    if (words[0] == words[1] && words[0] == words[2]) {
      words = words[0];
    }
    var rng = new Random();
    cdlist = [];
    for (var i = 0; i < _size; i++) {
      for (var j = 0; j < _size; j++) {
        cdlist.add(i + j / 10);
      }
    }
    var cflag = 1;
    while (cflag == 1) {
      cflag = 0;
      var start = 1;
      if (rng.nextInt(3) == 1) {
        start = rng.nextInt(_size);
      } else {
        start = rng.nextInt(_size * _size - 2);
      }
      if (rng.nextInt(3) != 1) {
        if (_size < 3) {
          if (rng.nextInt(3) == 1)
            start = 2;
          else
            start = 3;
        }
      }
      if (start == 0) start = 1;
      var cdstart = cdlist[start - 1];
      int eflag = 1;
      _fun(data) {
        for (var i = 0; i < cdletters.length; i++) {
          if (data == cdletters[i]) {
            return false;
          }
        }
        return true;
      }

      while (eflag == 1) {
        eflag = 0;
        var p = cdstart.toInt();
        var q = ((cdstart - p) * 10).toInt();
        var len = 1;
        cdletters = [];
        var top = true;
        var rand = rng.nextInt(3) == 1;
        cdletters.add(start - 1);
        while (len < widget.answer.length) {
          if (q + 1 < _size && _fun(p * _size + (q + 1)) && rand && top) {
            cdletters.add(p * _size + (q + 1));
            q++;
          } else if (p + 1 < _size && _fun((p + 1) * _size + q) && top) {
            cdletters.add((p + 1) * _size + q);
            p++;
          } else if (q + 1 < _size &&
              _fun(p * _size + (q + 1)) &&
              !rand &&
              top) {
            cdletters.add(p * _size + (q + 1));
            q++;
          } else if (q - 1 >= 0 && _fun(p * _size + (q - 1))) {
            cdletters.add(p * _size + (q - 1));
            q--;
          } else if (p - 1 >= 0 && _fun((p - 1) * _size + q)) {
            cdletters.add((p - 1) * _size + q);
            p--;
          } else {
            print('exit 2 breakkkkk');
            cflag = 1;
            break;
          }
          len++;
          if (len == 5) {
            top = rng.nextInt(3) != 1;
          }
        }
        if (cflag == 1) break;
        if (cdletters.length != widget.answer.length) eflag = 1;
      }
    }
    finalLetter = [];
    finalLetter.length = widget.answer.length + widget.choice.length;
    for (var i = 0; i < cdletters.length; i++) {
      finalLetter[cdletters[i]] = widget.answer[i];
    }
    for (var i = 0, j = 0; i < finalLetter.length; i++) {
      if (finalLetter[i] == null) {
        finalLetter[i] = widget.choice[j];
        j++;
      }
    }
    _status = [];
    _status = finalLetter.map((a) => Status.draggable).toList(growable: false);
    _visibleFlag = finalLetter.map((a) => false).toList(growable: false);
    _shakeCells =
        finalLetter.map((a) => ShakeCell.inactive).toList(growable: false);
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, Status status, ShakeCell tile,
      Offset offset, bool vflag, double maxHeight, double maxWidth) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        code: code,
        offset: offset,
        vflag: vflag,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        onStart: () {
          if (!stopDrag) {
            setState(() {
              stopDrag = true;
              temp.add(text);
              tempIndex.add(index);
              _pointsSend.add(offset);
              lastClick = index;
              _visibleFlag[index] = true;
              _status[index] = Status.first;
              for (var i = 0; i < finalLetter.length; i++) {
                if (_status[i] == Status.draggable && index != i) {
                  _status[i] = Status.dragTarget;
                }
              }
            });
          }
        },
        onwill: (data) {
          if (data == code && _visibleFlag[index] == false) {
            var x, y;
            if (lastClick == _size ||
                lastClick == _size + _size ||
                lastClick == _size + _size + _size) {
              x = lastClick;
            } else if (lastClick == _size - 1 ||
                lastClick == _size + _size - 1 ||
                lastClick == _size + _size + _size - 1) {
              y = lastClick;
            }

            if ((index == lastClick + 1 && y != lastClick) ||
                (index == lastClick - 1 && x != lastClick) ||
                (index == lastClick + _size) ||
                (index == lastClick - _size)) {
              _status[tempIndex[0]] = Status.dragTarget;
              setState(() {
                lastClick = index;
                temp.add(text);
                tempIndex.add(index);
                _pointsSend.add(offset);
                _visibleFlag[index] = true;
              });
              return true;
            }
          } else if (data == code &&
              _visibleFlag[index] == true &&
              tempIndex.length > 1) {
            if (index == tempIndex[tempIndex.length - 2]) {
              setState(() {
                _visibleFlag[tempIndex.last] = false;
                tempIndex.removeLast();
                temp.removeLast();
                _pointsSend.removeLast();
                lastClick = tempIndex.last;
              });
              return true;
            } else
              return false;
          }
          return false;
        },
        onCancel: (v, g) {
          lastClick = -1;
          int flag = 0;
          if (widget.answer.length == temp.length) {
            for (var i = 0; i < temp.length; i++) {
              if (temp[i] != widget.answer[i]) {
                flag = 1;
                break;
              }
            }
          } else {
            flag = 1;
          }
          if (flag == 1) {
            temp = [];
            tempIndex = [];
            tries += 4;
            setState(() {
              for (var i = 0; i < _visibleFlag.length; i++)
                _visibleFlag[i] == true ? _shakeCells[i] = ShakeCell.shake : i;
              //  widget.onScore(-4);
            });
            new Future.delayed(const Duration(milliseconds: 800), () {
              setState(() {
                stopDrag = false;
                _pointsSend = [];
                _shakeCells = finalLetter
                    .map((a) => ShakeCell.inactive)
                    .toList(growable: false);
                _status = finalLetter
                    .map((a) => Status.draggable)
                    .toList(growable: false);
                _visibleFlag =
                    finalLetter.map((a) => false).toList(growable: false);
              });
            });
          } else
            //   widget.onScore((40 ~/ totalgame) - tries);
            // widget.onProgress(1.0);
            new Future.delayed(const Duration(milliseconds: 350), () {
              setState(() {
                print(' finally over');
                widget.onGameOver(2);
              });
            });
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
    var j = 0;
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      double fullwidth = (_size * maxWidth) + (_size * buttonPadding);
      double removeallpaddingh = constraints.maxWidth - fullwidth;
      double startpointx = removeallpaddingh / 2;
      double removeallpaddingv = constraints.maxHeight - fullwidth;
      double startpointy = removeallpaddingv / 2;
      double yaxis = startpointy + (maxHeight / 2);
      double xaxis = startpointx + (maxWidth / 2);
      Offset startpoint = new Offset(xaxis, yaxis);

      List<Offset> offsets1 =
          calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      yaxis = yaxis + maxWidth + buttonPadding;
      xaxis = xaxis;
      double ystart = yaxis;
      double xstart =
          (xaxis + xaxis + (maxWidth / 1.4)) - (hPadding + buttonPadding);

      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets2 =
          calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      yaxis = yaxis + maxWidth + buttonPadding;
      xaxis = xaxis;
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets3 =
          calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      yaxis = yaxis + maxWidth + buttonPadding;
      xaxis = xaxis;
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets4 =
          calculateOffsets(buttonPadding, startpoint, _size, maxWidth);

      List<Offset> offsets = offsets1 + offsets2 + offsets3 + offsets4;
      var coloris = Theme.of(context).primaryColor;
      return Container(
        child: new Stack(children: [
          new Container(
            child: _buildpoint(_pointsSend, coloris, xstart, ystart),
          ),
          new Padding(
              padding: EdgeInsets.symmetric(
                  vertical: vPadding, horizontal: hPadding),
              child: ResponsiveGridView(
                rows: _size,
                cols: _size,
                // maxAspectRatio: 1.0,
                children: finalLetter
                    .map((e) => new Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: _buildItem(
                            j,
                            e,
                            _status[j],
                            _shakeCells[j],
                            offsets[j],
                            _visibleFlag[j++],
                            maxHeight,
                            maxWidth)))
                    .toList(growable: false),
              )),
        ]),
      );
    });
  }

  List<Offset> calculateOffsets(
      double d, Offset startpoint, int size, double maxWidth) {
    // double angle = 2 * pi / amount;
    // double alpha = 0.0;
    double centeraxis = maxWidth / 4;
    double x0 = startpoint.dx;
    double y0 = startpoint.dy;
    List<Offset> offsets = new List(size);
    d = 0.0;
    double y;
    double x;
    for (int i = 0; i < size; i++) {
      if (i == 0) {
        x = x0;
        y = y0;
      } else if (i == 1) {
        x = x0 + d + maxWidth;
        x0 = x;
        y = y0;
      } else {
        x = x0 + d + maxWidth + (maxWidth / 6);
        x0 = x;
        y = y0;
      }
      offsets[i] = new Offset(x, y);
    }
    return offsets;
  }

  _buildpoint(
      List<Offset> points1, Color coloris, double xstart, double ystart) {
    return MyApp(
      npoints1: points1,
      coloris: coloris,
      xstart: xstart,
      ystart: ystart,
    );
  }
}

class MyApp extends StatefulWidget {
  final List npoints1;
  final Color coloris;
  final double xstart;
  final double ystart;
  MyApp({Key key, this.npoints1, this.coloris, this.xstart, this.ystart})
      : super(key: key);
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      return new Container(
        child: new CustomPaint(
          painter: new SignaturePainter(
              widget.npoints1, widget.coloris, widget.xstart, widget.ystart),
        ),
      );
    });
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points, this.coloris, this.xstart, this.ystart);
  final List<Offset> points;
  final Color coloris;
  final double xstart;
  final double ystart;

  void paint(Canvas canvas, Size size) {
    var paint = new Paint()
      ..color = coloris
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.index,
      this.status,
      this.tile,
      this.offset,
      this.code,
      this.vflag,
      this.maxHeight,
      this.maxWidth,
      this.onStart,
      this.onCancel,
      this.onwill})
      : super(key: key);

  final String text;
  final int index;
  final Status status;
  final ShakeCell tile;
  final Offset offset;
  final double maxWidth;
  final double maxHeight;
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
  Animation<double> animation, animationWrong;
  Velocity velocity;
  Offset offset;

  @override
  initState() {
    super.initState();
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);

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
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shake(
        animation: widget.tile == ShakeCell.shake ? animationWrong : animation,
        child: widget.status == Status.dragTarget
            ? new DragTarget(
                onAccept: (int d) => (widget.tile == ShakeCell.shake ||
                        widget.status == Status.first)
                    ? {}
                    : widget.onCancel(velocity, offset),
                onWillAccept: (int data) => (widget.tile == ShakeCell.shake ||
                        widget.status == Status.first)
                    ? {}
                    : widget.onwill(data),
                builder: (_, __, ___) {
                  return new Material(
                      elevation: widget.vflag == true ? 10.0 : 0.0,
                      shape: new RoundedRectangleBorder(
                          side: new BorderSide(
                              color: Colors.blueAccent,
                              width: widget.maxWidth * 0.0075),
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(16.0))),
                      child: SizedBox(
                        height: widget.maxWidth,
                        width: widget.maxWidth,
                        child: RaisedButton(
                          splashColor: Theme.of(context).primaryColor,
                          highlightColor: Theme.of(context).primaryColor,
                          color:
                              widget.vflag == true ? Colors.blue : Colors.white,
                          onPressed: () => {},
                          child: Text(widget.text,
                              style:
                                  new TextStyle(fontSize: widget.maxWidth / 4)),
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.blueAccent,
                                  width: widget.maxWidth * 0.0075),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(16.0))),
                        ),
                      ));
                })
            : Draggable(
                onDragStarted: () =>
                    widget.tile == ShakeCell.shake ? {} : widget.onStart(),
                onDraggableCanceled: (v, g) =>
                    widget.tile == ShakeCell.shake ? {} : widget.onCancel(v, g),
                data: widget.code,
                feedback: new Container(),
                maxSimultaneousDrags: 1,
                child: SizedBox(
                  height: widget.maxWidth,
                  width: widget.maxWidth,
                  child: RaisedButton(
                    splashColor: Theme.of(context).primaryColor,
                    highlightColor: Theme.of(context).primaryColor,
                    color: widget.vflag == true ? Colors.blue : Colors.white,
                    onPressed: () => {},
                    child: Text(widget.text,
                        style: new TextStyle(fontSize: widget.maxWidth / 4)),
                    shape: new RoundedRectangleBorder(
                        side: new BorderSide(
                            color: Colors.blueAccent,
                            width: widget.maxWidth * 0.0075),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(16.0))),
                  ),
                )));
  }
}
