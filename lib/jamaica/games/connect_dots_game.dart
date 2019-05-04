import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

class ConnectDotGame extends StatefulWidget {
  final OnGameUpdate onGameUpdate;
  final List<int> otherData;
  final List<int> serialData;
  const ConnectDotGame(
      {key, this.onGameUpdate, this.otherData, this.serialData})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new ConnectDotGameState();
}

enum Status { active, visible, disappear, draggable, first, dragtarget }
enum ShakeCell { right, inActive, dance, curveRow }

class ConnectDotGameState extends State<ConnectDotGame> {
  List<bool> _visibleflag = [];
  final _size = 4;
  static int size = 4;
  var n = size;
  var rowExtracting = 0;
  var rowFlowDisplay = 0;
  var colFlowDisplay = 0;
  var colExtracting = 0;
  bool start = false;
  var range;
  var rand;
  var code;
  List<int> numbers = [];
  List<int> storingAnsData = [];
  List<int> _shuffledLetters = [];
  List<int> _letters;
  List<int> _todnumber = [];
  List<Status> _statuses;
  List<int> _letterex = [];
  List<int> tempindex = [];
  int lastclick;
  List<Offset> _pointssend = <Offset>[];
  var temp = 0;
  List<ShakeCell> shakeCells = [];
  @override
  void initState() {
    super.initState();
    print("hello this should come first...");
    var rnge = new Random();
    for (var i = 0; i < 1; i++) {
      rand = rnge.nextInt(2);
    }
    if (rand == 1) {
      widget.serialData.forEach((e) {
        numbers.add(e);
      });
      widget.otherData.forEach((v) {
        numbers.add(v);
      });
    } else {
      widget.otherData.forEach((e) {
        numbers.add(e);
      });
      widget.serialData.forEach((v) {
        numbers.add(v);
      });
    }

    for (var i = 0; i < numbers.length; i += _size * _size) {
      _shuffledLetters
          .addAll(numbers.skip(i).take(_size * _size).toList(growable: true));
    }
    _statuses = numbers.map((a) => Status.draggable).toList(growable: false);
    shakeCells = numbers.map((a) => ShakeCell.inActive).toList(growable: false);

    print(_shuffledLetters);

    var todnumbers = new List.generate(n, (_) => new List(n));
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        rowFlowDisplay = j + 1 + rowExtracting;
        print("print something in forloop");
        _shuffledLetters.sublist(rowExtracting, rowFlowDisplay).forEach((e) {
          todnumbers[i][j] = e;
        });

        print("value of 2d is each time $todnumbers");
      }
      rowExtracting = rowFlowDisplay;
    }
    for (var i = 1; i < size; i++) {
      if (i % 2 != 0) {
        Iterable letdo = todnumbers[i].reversed;
        var fReverse = letdo.toList();
        todnumbers[i].setRange(0, size, fReverse.map((e) => e));
      }
    }

    todnumbers.forEach((e) {
      e.forEach((v) {
        _todnumber.add(v);
      });
    });

    var todcolnumbers = new List.generate(n, (_) => new List(n));
    for (var i = 0; i < size; i++) {
      if (i % 2 != 0) {
        for (var j = size - 1; j >= 0; j--) {
          colFlowDisplay = 1 + colExtracting;
          _shuffledLetters.sublist(colExtracting, colFlowDisplay).forEach((e) {
            todcolnumbers[j][i] = e;
          });

          colExtracting = colFlowDisplay;
        }
      } else {
        for (var j = 0; j < size; j++) {
          colFlowDisplay = j + 1 + colExtracting;
          // count6= count2+j+1+count4;
          print("print something in forloop");
          _shuffledLetters.sublist(colExtracting, colFlowDisplay).forEach((e) {
            todcolnumbers[j][i] = e;
          });

          print("value of 2d is cols each time $todcolnumbers");
        }
      }
      colExtracting = colFlowDisplay;
    }

    todcolnumbers.forEach((e) {
      e.forEach((v) {
        _letterex.add(v);
      });
    });

    var rng = new Random();
    for (var i = 0; i < 1; i++) {
      range = rng.nextInt(4);
    }
    if (range == 4) {
      range = range - 1;
    }

    switch (range) {
      case 0:
        {
          _letters = _todnumber;
        }
        break;
      case 1:
        {
          Iterable iterableNumberReverse = _todnumber.reversed;
          var reverseData = iterableNumberReverse.toList();
          _letters = reverseData;
        }
        break;

      case 2:
        {
          _letters = _letterex;
        }
        break;
      case 3:
        {
          Iterable iterableNumberReverse = _letterex.reversed;
          var reverseData = iterableNumberReverse.toList();
          _letters = reverseData;
        }
        break;
    }
    shakeCells =
        _letters.map((a) => ShakeCell.inActive).toList(growable: false);

    _statuses = _letters.map((a) => Status.draggable).toList(growable: false);
    _visibleflag = _letters.map((a) => false).toList(growable: false);
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
  }

  Widget _buildItem(int index, int text, Status status, ShakeCell tile,
      Offset offset, bool vflag, double maxHeight, double maxWidth) {
    // return Text(text);
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        index: index,
        status: status,
        tile: tile,
        offset: offset,
        vflag: vflag,
        code: code,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        onStart: () {
          if (!start) {
            setState(() {
              print('nikkkkkkkkkkkkkk');
              temp = index;
              start = true;
              storingAnsData.add(text);
              tempindex.add(index);
              _pointssend.add(offset);
              lastclick = index;
              _visibleflag[index] = true;
              _statuses[index] = Status.first;
              for (var i = 0; i < _letters.length; i++) {
                if (_statuses[i] == Status.draggable && index != i) {
                  _statuses[i] = Status.dragtarget;
                }
              }
            });
          }
        },
        onwill: (data) {
          print('nikkkkkkkkkkkkkk  999');
          var x;
          var y;

          if (data == code && _visibleflag[index] == false) {
            if (lastclick == _size ||
                lastclick == _size + _size ||
                lastclick == _size + _size + _size) {
              x = lastclick;
            } else if (lastclick == _size - 1 ||
                lastclick == _size + _size - 1 ||
                lastclick == _size + _size + _size - 1) {
              y = lastclick;
              print("hello this iiis yyyy$y");
            }

            if ((index == lastclick + 1 && y != lastclick) ||
                (index == lastclick - 1 && x != lastclick) ||
                (index == lastclick + _size) ||
                (index == lastclick - _size)) {
              _statuses[temp] = Status.dragtarget;
              setState(() {
                lastclick = index;
                storingAnsData.add(text);
                tempindex.add(index);
                _statuses[tempindex[0]] = Status.dragtarget;
                _pointssend.add(offset);
                _visibleflag[index] = true;
              });
              return true;
            } else
              return false;
          } else if (data == code &&
              _visibleflag[index] == true &&
              tempindex.length > 1) {
            if (index == tempindex[tempindex.length - 2]) {
              setState(() {
                _visibleflag[tempindex.last] = false;
                tempindex.removeLast();
                storingAnsData.removeLast();
                _pointssend.removeLast();

                //  temp.removeLast();
                lastclick = tempindex.last;
              });
              return true;
            } else
              return false;
          } else
            return true;
        },
        onCancel: (v, g) {
          int flag = 0;
          setState(() {
            start = false;
            if (storingAnsData.length == widget.serialData.length) {
              for (int i = 0; i < storingAnsData.length; i++) {
                if (storingAnsData[i] == widget.serialData[i]) {
                } else {
                  //  tries += 5;
                  flag = 1;
                  break;
                }
              }
            } else {
              flag = 1;
              // tries += 5;
            }
            print('flaggggggggggggg     $flag');
            if (flag == 0) {
              print('on  endddd  ');
              widget.onGameUpdate(
                  score: 20, max: 20, gameOver: true, star: true);

              setState(() {
                rowExtracting = 0;
                storingAnsData = [];
                rowFlowDisplay = 0;
                colFlowDisplay = 0;
                colExtracting = 0;
                _pointssend.removeRange(0, _pointssend.length);
                _todnumber.removeRange(0, _todnumber.length);
                _letters.removeRange(0, _letters.length);

                _letterex.removeRange(0, _letterex.length);
                numbers.removeRange(0, numbers.length);

                _shuffledLetters.removeRange(0, _shuffledLetters.length);

                new Future.delayed(const Duration(milliseconds: 250), () {
                  start = false;
                });
              });
            }
            if (flag == 1) {
              widget.onGameUpdate(score: 0, max: 1, gameOver: true, star: true);
              print("object....shanking thing is...:$_visibleflag");
              setState(() {
                storingAnsData = [];

                for (var i = 0; i < _visibleflag.length; i++)
                  _visibleflag[i] == true ? shakeCells[i] = ShakeCell.right : i;
              });
              new Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  shakeCells = _letters
                      .map((a) => ShakeCell.inActive)
                      .toList(growable: false);
                  _statuses = _letters
                      .map((a) => Status.draggable)
                      .toList(growable: false);
                  _visibleflag =
                      _letters.map((a) => false).toList(growable: false);
                  _pointssend = [];
                });
              });
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");

    MediaQueryData media = MediaQuery.of(context);
    print("hello data coming or not in widgets is $_letters");

    print("how head to head is working");
    var j = 0;

    return new LayoutBuilder(builder: (context, constraints) {
      print("this is where the its comming full");
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      // UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      // UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);
      // final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
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
      print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets3 =
          calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      yaxis = yaxis + maxWidth + buttonPadding;
      xaxis = xaxis;
      print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets4 =
          calculateOffsets(buttonPadding, startpoint, _size, maxWidth);

      List<Offset> offsets = offsets1 + offsets2 + offsets3 + offsets4;
      var coloris = Theme.of(context).primaryColor;
      return Container(
        child: new Stack(children: [
          new Container(
            child: _buildpoint(_pointssend, coloris, xstart, ystart),
          ),
          new Padding(
              padding: EdgeInsets.symmetric(
                  vertical: vPadding, horizontal: hPadding),
              child: new ResponsiveGridView(
                rows: _size,
                cols: _size,
                //    maxAspectRatio: 1.0,
                children: _letters
                    .map((e) => new Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: _buildItem(
                            j,
                            e,
                            _statuses[j],
                            shakeCells[j],
                            offsets[j],
                            _visibleflag[j++],
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
    MediaQueryData media = MediaQuery.of(context);
    return new LayoutBuilder(builder: (context, constraints) {
      print("emulator size in canvas .....::...${media.size.height}");
      return new Container(
        child: new CustomPaint(
          // size: new Size(0.0, 0.0),
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
  //  var size1 =Size(683.0,345.0);

  void paint(Canvas canvas, Size size) {
    print("hello canvas is ....${size.height}");
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

  final int text;
  int index;
  Status status;
  ShakeCell tile;
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
  Animation<double> animationRight, animation, animationWrong, animationDance;

  Velocity v;
  Offset o;
  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");

    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (widget.text == null) {
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
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Shake(
        animation:
            widget.tile == ShakeCell.right ? animationWrong : animationRight,
        child: new ScaleTransition(
            scale: animationRight,
            child: widget.status == Status.dragtarget
                ? new DragTarget(
                    onAccept: (int d) => (widget.tile == ShakeCell.right ||
                            widget.status == Status.first)
                        ? {}
                        : widget.onCancel(v, o),
                    onWillAccept: (int data) =>
                        (widget.tile == ShakeCell.right ||
                                widget.status == Status.first)
                            ? {}
                            : widget.onwill(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new Material(
                          elevation: widget.vflag == true ? 10.0 : 0.0,
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.blueAccent,
                                  width: widget.maxWidth * 0.0075),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(16.0))),
                          // color:
                          //     widget.vflag == true ? Colors.blue : Colors.white,
                          child: SizedBox(
                            height: widget.maxWidth,
                            width: widget.maxWidth,
                            child: RaisedButton(
                              splashColor: Theme.of(context).primaryColor,
                              highlightColor: Theme.of(context).primaryColor,
                              color: widget.vflag == true
                                  ? Colors.blue
                                  : Colors.white,
                              onPressed: () => {},
                              child: Text("${widget.text}",
                                  style: new TextStyle(
                                      fontSize: widget.maxWidth / 4)),
                              shape: new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blueAccent,
                                      width: widget.maxWidth * 0.0075),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(16.0))),
                            ),
                          )
                          //     new UnitButton(
                          //   highlighted: widget.vflag,
                          //   text: _displayText,
                          //   onPress: () => {},
                          //   unitMode: UnitMode.text,
                          //   showHelp: false,
                          // )
                          );
                    })
                : new Draggable(
                    onDragStarted: () =>
                        widget.tile == ShakeCell.right ? {} : widget.onStart(),
                    onDraggableCanceled: (v, g) =>
                        widget.tile == ShakeCell.right
                            ? {}
                            : widget.onCancel(v, g),
                    data: widget.code,
                    feedback: new Container(),
                    maxSimultaneousDrags: 1,
                    child: SizedBox(
                      height: widget.maxWidth,
                      width: widget.maxWidth,
                      child: RaisedButton(
                        splashColor: Theme.of(context).primaryColor,
                        highlightColor: Theme.of(context).primaryColor,
                        color:
                            widget.vflag == true ? Colors.blue : Colors.white,
                        onPressed: () => {},
                        child: Text("${widget.text}",
                            style:
                                new TextStyle(fontSize: widget.maxWidth / 4)),
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(
                                color: Colors.blueAccent,
                                width: widget.maxWidth * 0.0075),
                            borderRadius: new BorderRadius.all(
                                new Radius.circular(16.0))),
                      ),
                    )

                    //     new UnitButton(
                    //   highlighted: widget.vflag,
                    //   text: _displayText,
                    //   onPress: () => {},
                    //   unitMode: UnitMode.text,
                    //   showHelp: false,
                    // ),
                    )));
  }
}
