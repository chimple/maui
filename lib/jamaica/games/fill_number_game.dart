import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/jamaica/state/game_utils.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

class FillNumberGame extends StatefulWidget {
  final OnGameOver onGameOver;
  final List<int> serialData;

  const FillNumberGame({
    key,
    this.serialData,
    this.onGameOver,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => new FillNumberGameState();
}

enum Status { active, draggable, dragtarget, first }
enum ShakeCell { right, inActive }

class FillNumberGameState extends State<FillNumberGame> {
  var sumOfClickValue = 0,
      sublistNumberSum = 0,
      k = 0,
      countNullValue = 0,
      displayAns = 0,
      subListNumber = 3,
      flag = 0,
      scorCount = 0;
  bool start = false;
  List<int> tempindex = [];
  final int _size = 4;
  static int size = 4;
  List<int> _allLetters;
  List<int> _shuffledLetters = [];
  List<int> _copyVal = [];
  List<int> clicks = [];
  List addingIndex = [];
  List<int> _letters;
  String addClickValue = '';
  String nulstring = '';
  List<int> clickAns = [];
  List<Status> _statuses;
  List<Offset> _pointssend = <Offset>[];
  List<ShakeCell> shakeCells = [];
  List subListset = [];
  List<bool> _visibleflag = [];
  int lastclick;
  var code;
  var temp = 0;
  @override
  void initState() {
    super.initState();
    _allLetters = widget.serialData;

    print("shanthus data is $_allLetters");
    _allLetters.forEach((e) {
      _copyVal.add(e);
    });

    for (var i = 0; i < _copyVal.length; i += _size * _size) {
      _shuffledLetters
          .addAll(_copyVal.skip(i).take(_size * _size).toList(growable: true));
    }
    _letters = _shuffledLetters.sublist(0, _size * _size);
    shakeCells =
        _letters.map((a) => ShakeCell.inActive).toList(growable: false);
    _statuses = _letters.map((a) => Status.draggable).toList(growable: false);
    _visibleflag = _letters.map((a) => false).toList(growable: false);
    var rng = new Random();
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }

    subListset = _shuffledLetters.sublist(0, 4);
    for (num e in subListset) {
      sublistNumberSum += e;
    }
    displayAns = sublistNumberSum;
    subListset.removeRange(0, subListset.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildItem(
      int index,
      int text,
      Status status,
      ShakeCell tile,
      Offset offset,
      bool vflag,
      double maxHeight,
      double maxWidth,
      List<Offset> listOffsets) {
    print("..offsets are...$offset");
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
        if (!start && text != null) {
          setState(() {
            print('nikkkkkkkkkkkkkk');
            print("..offsets are..in start....$offset");
            temp = index;
            _pointssend.removeRange(0, _pointssend.length);
            clickAns.add(text);
            addClickValue = '$text';
            start = true;
            addingIndex.add(index);
            tempindex.add(index);
            lastclick = index;
            _visibleflag[index] = true;
            if (_visibleflag[index] == true) {
              setState(() {
                Offset netOffset = Offset(
                    offset.dx + maxHeight / 2, offset.dy + maxHeight / 2);
                _pointssend.add(netOffset);
              });
            }

            sumOfClickValue = sumOfClickValue + text;
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
        print("..offsets are..in onwill  .$offset");
        var lineflag = 0;
        var x;
        var y;
        var countline = 0;
        for (var j = 0; j < _letters.length; j++) {
          if (_visibleflag[j] == false) {
            lineflag = 1;
            countline++;
          }
        }
        if (lineflag == 1 && countline == _letters.length ||
            clickAns.length == 0) {
          _pointssend.removeRange(0, _pointssend.length);
          countline = 0;
        }

        if (data == code && _visibleflag[index] == false && text != null) {
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
            _statuses[tempindex[0]] = Status.dragtarget;
            if (addClickValue == '') {
              addClickValue = '$text';
            } else {
              addClickValue = '$addClickValue' + '+' + '$text';
            }
            setState(() {
              sumOfClickValue = sumOfClickValue + text;
              addingIndex.add(index);
              lastclick = index;
              tempindex.add(index);

              clickAns.add(text);
              _visibleflag[index] = true;
              if (_visibleflag[index] == true) {
                setState(() {
                  Offset netOffset = Offset(
                      offset.dx + maxHeight / 2, offset.dy + maxHeight / 2);
                  _pointssend.add(netOffset);
                  // _pointssend.add(offset);
                });
              }
            });

            return true;
          }
        } else if (data == code &&
            _visibleflag[index] == true &&
            tempindex.length > 1) {
          print("object....tempindex..lenth..::${tempindex.length}");

          if (index == tempindex[tempindex.length - 2]) {
            print("befor un do points .....is...::$_pointssend");
            print("length points isss.......::${_pointssend.length}");
            setState(() {
              addClickValue = addClickValue.replaceRange(
                  addClickValue.length - 2, addClickValue.length, '');

              _pointssend.removeLast();
              _visibleflag[tempindex.last] = false;
              tempindex.removeLast();
              sumOfClickValue = sumOfClickValue - clickAns.last;
              clickAns.removeLast();

              lastclick = tempindex.last;

              addingIndex.removeLast();
            });

            return true;
          } else
            return false;
        }
        return false;
      },
      onCancel: (v, g) {
        setState(() {
          _pointssend.removeRange(0, _pointssend.length);

          if (sumOfClickValue == displayAns) {
            setState(() {
              start = false;
            });
            flag = 1;
            addClickValue = '$addClickValue' + '=$sumOfClickValue';
            setState(() {
              _pointssend.removeRange(0, _pointssend.length);
            });
            tempindex.removeRange(0, tempindex.length);
            // new Future.delayed(const Duration(milliseconds: 250), () {
            // widget.onScore(((40 - tries) ~/ totalgame));

            scorCount = scorCount + 1;

            for (var i = 0; i < addingIndex.length; i++) {
              _letters[addingIndex[i]] = null;
            }

            sumOfClickValue = 0;

            _letters.forEach((e) {
              if (e == null) {
                countNullValue = countNullValue + 1;
              }
            });
            addClickValue = nulstring;
            if (addClickValue == null) {
              setState(() {
                addClickValue = nulstring;
              });
            }
            _letters.removeWhere((value) => value == null);
            // for (var i = 0; i < countNullValue; i++) {
            //   _letters.add(null);
            //   // _letters.insert(0, null);
            // }

            subListset.removeRange(0, subListset.length);

            sublistNumberSum = 0;
            subListset = _letters.sublist(0, subListNumber);
            subListNumber++;

            subListset.forEach((e) {
              if (e == null) {}
            });
            print("my calling onennd value is $k");
            subListset.removeWhere((value) => value == null);
            k = subListset.length;

            print("thid is the vlaue of length is valu$k");
            for (num e in subListset) {
              sublistNumberSum += e;
            }
            print("thhhiiiiiiisssss isss shanthuuuu$subListset");
            displayAns = sublistNumberSum;

            countNullValue = 0;

            _statuses =
                _letters.map((a) => Status.draggable).toList(growable: false);
            _visibleflag = _letters.map((a) => false).toList(growable: false);
            addingIndex.removeRange(0, addingIndex.length);

            // });
//future delay not using here
            k = _letters[4];
            print("helllo this letters$k");
            if (_letters[subListNumber] == null) {
              setState(() {
                k = 0;
                displayAns = 0;
                addClickValue = nulstring;
                sumOfClickValue = 0;
                clicks.removeRange(0, clicks.length);
                addingIndex.removeRange(0, addingIndex.length);
                _letters.removeRange(0, _letters.length);
                _shuffledLetters.removeRange(0, _shuffledLetters.length);
                tempindex = [];
                clickAns = [];
                lastclick = -1;
                _pointssend = [];
              });
              // new Future.delayed(const Duration(milliseconds: 250), () {
              start = false;
              widget.onGameOver(10);
              scorCount = scorCount;
              _pointssend.removeRange(0, _pointssend.length);
              // });
            }

            subListset.removeRange(0, subListset.length);
          } else {
            setState(() {
              _pointssend = [];
              start = false;
              tempindex = [];

              clickAns = [];
              addingIndex.removeRange(0, addingIndex.length);
              for (var i = 0; i < _visibleflag.length; i++)
                _visibleflag[i] == true ? shakeCells[i] = ShakeCell.right : i;

              new Future.delayed(const Duration(milliseconds: 250), () {
                setState(() {
                  shakeCells = _letters
                      .map((a) => ShakeCell.inActive)
                      .toList(growable: false);
                  _statuses = _letters
                      .map((a) => Status.draggable)
                      .toList(growable: false);
                  _visibleflag =
                      _letters.map((a) => false).toList(growable: false);

                  addClickValue = nulstring;
                  sumOfClickValue = 0;
                });
              });
            });
          }
          setState(() {
            _pointssend = [];
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);

    print("height of emulator is......::...${media.size.height}");
    return new LayoutBuilder(builder: (context, constraints) {
      var j = 0;

      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 2);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      // _height = 4 * maxHeight + (2 * vPadding) + (2 * buttonPadding);
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;

      // double fullwidth = (_size * maxWidth) + (_size * (2 * buttonPadding));
      // double removeallpaddingh = constraints.maxWidth - fullwidth;
      // double startpointx = removeallpaddingh / 2;
      // double removeallpaddingv = constraints.maxHeight - fullwidth;
      // double startpointy = removeallpaddingv / 2;
      // double yaxis = startpointy + (maxHeight) + (maxHeight / 2);
      // double y0 = yaxis;
      // double xaxis = startpointx + (maxWidth / 2);
      // Offset startpoint = new Offset(xaxis, yaxis);
      // List<Offset> offsets1 =
      //     calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      // yaxis = yaxis + maxWidth + buttonPadding;
      // double y1 = yaxis;
      // double ystart = y1 - y0;
      // xaxis = xaxis;
      // double xstart =
      //     (xaxis + xaxis + (maxWidth / 1.4)) - (hPadding + buttonPadding);
      // startpoint = new Offset(xaxis, yaxis);
      // List<Offset> offsets2 =
      //     calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      // yaxis = yaxis + maxWidth + buttonPadding;
      // xaxis = xaxis;
      // startpoint = new Offset(xaxis, yaxis);
      // List<Offset> offsets3 =
      //     calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
      // yaxis = yaxis + maxWidth + buttonPadding;
      // xaxis = xaxis;
      // startpoint = new Offset(xaxis, yaxis);
      // List<Offset> offsets4 =
      //     calculateOffsets(buttonPadding, startpoint, _size, maxWidth);

      // List<Offset> offsets = offsets1 + offsets2 + offsets3 + offsets4;
      // var coloris = Theme.of(context).primaryColor;
      if (addClickValue == null) {
        setState(() {
          addClickValue = '';
        });
      }
      return new Stack(
        children: [
          new Container(
            constraints: new BoxConstraints.expand(),
            height: media.size.height,
            child: new Column(
              children: <Widget>[
                new LimitedBox(
                    maxHeight: maxHeight,
                    child: new Material(
                        color: Colors.grey,
                        elevation: 4.0,
                        textStyle: new TextStyle(
                            color: Colors.white,
                            fontSize: maxHeight / 2,
                            letterSpacing: 8.0),
                        child: new Container(
                          padding: EdgeInsets.all(buttonPadding),
                          child: new Center(
                              child: SizedBox(
                            height: maxWidth,
                            width: maxWidth,
                            child: RaisedButton(
                              splashColor: Theme.of(context).primaryColor,
                              highlightColor: Theme.of(context).primaryColor,
                              shape: new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blueAccent,
                                      width: maxWidth * 0.0075),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(16.0))),
                              onPressed: () => {},
                              child: Text(
                                "$displayAns",
                                style: new TextStyle(fontSize: maxWidth / 4),
                              ),
                            ),
                          )
                              //     new UnitButton(
                              //   text: "$displayAns",
                              //   primary: true,
                              // )
                              ),
                        ))),
                new LimitedBox(
                    maxHeight: maxHeight,
                    child: new Material(
                        color: Colors.grey,
                        elevation: 4.0,
                        textStyle: new TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: maxHeight / 2,
                            letterSpacing: 8.0),
                        child: new Container(
                          padding: EdgeInsets.all(buttonPadding),
                          child: new Center(
                            child: addClickValue == null
                                ? new Text("$nulstring")
                                : new Text(addClickValue,
                                    style: new TextStyle(
                                        fontSize: maxWidth / 4,
                                        color: Colors.white)),
                          ),
                        ))),
                Container(
                  height: constraints.maxHeight,
                  child: Stack(children: [
                    //                  new Container(
                    //   child: _buildpoint(_pointssend, Colors.blue, xstart, ystart),
                    // ),
                    _buildGrideView(context, _letters, _statuses, maxHeight,
                        maxWidth, _visibleflag),
                  ]),
                ),
                // Stack(children: [
                //   new Padding(
                //       padding: EdgeInsets.symmetric(
                //           vertical: vPadding, horizontal: hPadding),
                //       child: new ResponsiveGridView(
                //         rows: _size,
                //         cols: _size,
                //         maxAspectRatio: 1.0,
                //         children: _letters
                //             .map((e) => new Padding(
                //                 padding: EdgeInsets.all(buttonPadding),
                //                 child: _buildItem(
                //                     j,
                //                     e,
                //                     _statuses[j],
                //                     shakeCells[j],
                //                     offsets[j],
                //                     _visibleflag[j++],
                //                     maxHeight,
                //                     maxWidth)))
                //             .toList(growable: false),
                //       )),
                // ]),
              ],
            ),
          ),
        ],
      );
    });
  }

  List<Offset> calculateOffsets(
      double d, Offset startpoint, int size, double maxWidth) {
    double x0 = startpoint.dx;
    double y0 = startpoint.dy;
    List<Offset> offsets = new List(size);

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
        x = x0 + d + maxWidth;
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

  Widget _buildGrideView(
      BuildContext context,
      List<int> letters,
      List<Status> statuses,
      double maxHeight,
      double maxWidth,
      List<bool> visibleflag) {
    List<Widget> tiles = [];
    MediaQueryData media = MediaQuery.of(context);
    double width = media.size.width;
    double height = media.size.height;
    final hPadding = pow(width / 150.0, 2);
    final vPadding = pow(height / 150.0, 2);

    double maxWidth = (width - hPadding * 2) / _size;
    double maxHeight = (height - vPadding * 2) / (_size + 2);

    final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

    print("button padding is......$buttonPadding");
    // _height = 4 * maxHeight + (2 * vPadding) + (2 * buttonPadding);
    maxWidth -= buttonPadding * 2;
    maxHeight -= buttonPadding * 2;

    double fullwidth = (_size * maxWidth) + (_size * (2 * buttonPadding));
    double removeallpaddingh = width - fullwidth;
    double startpointx = removeallpaddingh / 2;
    double removeallpaddingv =
        height - (_size * maxHeight) + (_size * (2 * buttonPadding));
    double startpointy = removeallpaddingv / 2;
    double yaxis = maxHeight / 2;
    //  + (maxHeight) + (maxHeight / 2);
    print("what is.. comming p .....y axis..$startpointy");
    double y0 = yaxis;
    double xaxis = startpointx;
    // + (maxWidth / 2);
    Offset startpoint = new Offset(xaxis, yaxis);
    List<Offset> offsets1 =
        calculateOffsets(buttonPadding, startpoint, _size, maxWidth);
    yaxis = yaxis + maxWidth + buttonPadding;
    double y1 = yaxis;
    double ystart = y1 - y0;
    xaxis = xaxis;
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

    List<Offset> listOffsets = offsets1 + offsets2 + offsets3 + offsets4;

    for (int i = 0, j = listOffsets.length - 1; i < letters.length; j--, i++) {
      tiles.add(Positioned(
        left: listOffsets[j].dx,
        top: listOffsets[j].dy,
        child: _buildItem(i, letters[i], _statuses[i], shakeCells[i],
            listOffsets[j], _visibleflag[i], maxHeight, maxWidth, listOffsets),
      ));
    }

    return Stack(children: [
      new Container(
        height: media.size.height - 270.0,
        child: _buildpoint(_pointssend, Colors.blue, xstart, ystart),
      ),
      new Padding(
        padding: EdgeInsets.symmetric( vertical: vPadding,horizontal: hPadding),
        child: Stack(children: tiles),
      )
    ]);
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
  const MyButton(
      {Key key,
      this.text,
      this.index,
      this.status,
      this.tile,
      this.offset,
      this.code,
      this.vflag,
      this.onStart,
      this.maxWidth,
      this.maxHeight,
      this.onCancel,
      this.onwill})
      : super(key: key);

  final int text;
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
  Animation<double> animationRight, animation, animationWrong, animationDance;
  int _displayText;
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
          if (!widget.text.isNaN) {
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
  void dispose() {
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('99999999999999   ${widget.status}');
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
                          shape: widget.text == null
                              ? RoundedRectangleBorder(side: BorderSide.none)
                              : new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blueAccent,
                                      width: widget.maxWidth * 0.0075),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(16.0))),
                          child: SizedBox(
                            height: widget.maxWidth,
                            width: widget.maxWidth,
                            child: widget.text == null
                                ? Container()
                                : RaisedButton(
                                    splashColor: Theme.of(context).primaryColor,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    color: widget.vflag == true
                                        ? Colors.blue
                                        : Colors.white,
                                    onPressed: () => {},
                                    child: Text(
                                      "${widget.text}",
                                      style: new TextStyle(
                                          fontSize: widget.maxWidth / 4),
                                    ),
                                    shape: new RoundedRectangleBorder(
                                        side: new BorderSide(
                                            color: Colors.blueAccent,
                                            width: widget.maxWidth * 0.0075),
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(16.0))),
                                  ),
                          ));
                    })
                : new Draggable(
                    onDragStarted: () =>
                        widget.tile == ShakeCell.right ? {} : widget.onStart(),
                    onDraggableCanceled: (v, g) =>
                        widget.tile == ShakeCell.right
                            ? {}
                            : widget.onCancel(v, g),
                    data: widget.code,
                    maxSimultaneousDrags: 1,
                    feedback: new Container(),
                    child: SizedBox(
                      height: widget.maxWidth,
                      width: widget.maxWidth,
                      child: widget.text == null
                          ? Container()
                          : RaisedButton(
                              splashColor: Theme.of(context).primaryColor,
                              highlightColor: Theme.of(context).primaryColor,
                              color: widget.vflag == true
                                  ? Colors.blue
                                  : Colors.white,
                              onPressed: () => {},
                              child: Text(
                                "${widget.text}",
                                style: new TextStyle(
                                    fontSize: widget.maxWidth / 4),
                              ),
                              shape: new RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: Colors.blueAccent,
                                      width: widget.maxWidth * 0.0075),
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(16.0))),
                            ),
                    ))));
  }
}
