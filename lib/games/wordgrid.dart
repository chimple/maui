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
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/gameaudio.dart';

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

enum Status { Draggable, First, Dragtarget }
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
  List<int> tempindex = [];
  List<bool> _visibleflag = [];
  bool stopdrag = false;
  var cdtemp;
  var progress = 0;
  int endflag = 0;
  int code;
  int lastclick;
  int tries = 0;
  List<Offset> _pointssend = <Offset>[];
  List<ShakeCell> _shakeCells = [];
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
        while (len < data.item1.length) {
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
        if (cdletters.length != data.item1.length) eflag = 1;
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
    _shakeCells =
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

  Widget _buildItem(int index, String text, Status status, ShakeCell tile,
      Offset offset, bool vflag) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        code: code,
        offset: offset,
        vflag: vflag,
        onStart: () {
          if (!stopdrag) {
            setState(() {
              stopdrag = true;
              temp.add(text);
              tempindex.add(index);
              _pointssend.add(offset);
              lastclick = index;
              _visibleflag[index] = true;
              _statuses[index] = Status.First;
              for (var i = 0; i < newletters.length; i++) {
                if (_statuses[i] == Status.Draggable && index != i) {
                  _statuses[i] = Status.Dragtarget;
                }
              }
            });
          }
        },
        onwill: (data) {
          if (data == code && _visibleflag[index] == false) {
            var x, y;
            if (lastclick == _size ||
                lastclick == _size + _size ||
                lastclick == _size + _size + _size) {
              x = lastclick;
            } else if (lastclick == _size - 1 ||
                lastclick == _size + _size - 1 ||
                lastclick == _size + _size + _size - 1) {
              y = lastclick;
            }

            if ((index == lastclick + 1 && y != lastclick) ||
                (index == lastclick - 1 && x != lastclick) ||
                (index == lastclick + _size) ||
                (index == lastclick - _size)) {
              _statuses[tempindex[0]] = Status.Dragtarget;
              setState(() {
                lastclick = index;
                temp.add(text);
                tempindex.add(index);
                _pointssend.add(offset);
                _visibleflag[index] = true;
              });
              return true;
            }
          } else if (data == code &&
              _visibleflag[index] == true &&
              tempindex.length > 1) {
            if (index == tempindex[tempindex.length - 2]) {
              setState(() {
                _visibleflag[tempindex.last] = false;
                tempindex.removeLast();
                temp.removeLast();
                _pointssend.removeLast();
                lastclick = tempindex.last;
              });
              return true;
            } else
              return false;
          }
          return false;
        },
        onCancel: (v, g) {
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
            tempindex = [];
            tries += 4;
            setState(() {
              for (var i = 0; i < _visibleflag.length; i++)
                _visibleflag[i] == true ? _shakeCells[i] = ShakeCell.Right : i;
              widget.onScore(-4);
            });
            new Future.delayed(const Duration(milliseconds: 800), () {
              setState(() {
                stopdrag = false;
                _pointssend = [];
                _shakeCells = newletters
                    .map((a) => ShakeCell.InActive)
                    .toList(growable: false);
                _statuses = newletters
                    .map((a) => Status.Draggable)
                    .toList(growable: false);
                _visibleflag =
                    newletters.map((a) => false).toList(growable: false);
              });
            });
          } else {
            if (((40 ~/ totalgame) - tries) < 1) {
              widget.onScore(4);
            } else
              widget.onScore((40 ~/ totalgame) - tries);
            widget.onProgress(1.0);
            endflag = 1;
            new Future.delayed(const Duration(milliseconds: 350), () {
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
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
      double fullwidth = (_size * buttonConfig.width) + (_size * buttonPadding);
      double removeallpaddingh = constraints.maxWidth - fullwidth;
      double startpointx = removeallpaddingh / 2;
      double removeallpaddingv = constraints.maxHeight - fullwidth;
      double startpointy = removeallpaddingv / 2;
      double yaxis = startpointy + (buttonConfig.height);
      double xaxis = startpointx + (buttonConfig.width / 2);
      Offset startpoint = new Offset(xaxis, yaxis);

      List<Offset> offsets1 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);
      yaxis = yaxis + buttonConfig.width + buttonPadding;
      xaxis = xaxis;
      double ystart = yaxis;
      double xstart =
          (xaxis + xaxis + (maxWidth / 1.4)) - (hPadding + buttonPadding);
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets2 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);

      yaxis = yaxis + buttonConfig.width + buttonPadding;
      xaxis = xaxis;
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets3 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);
      yaxis = yaxis + buttonConfig.width + buttonPadding;
      xaxis = xaxis;
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets4 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);

      List<Offset> offsets = offsets1 + offsets2 + offsets3 + offsets4;
      var coloris = Theme.of(context).primaryColor;
      if (_isShowingFlashCard) {
        return FractionallySizedBox(
            widthFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.7 : 0.65,
            heightFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.4 : 0.8,
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
                    tempindex = [];
                    stopdrag = false;
                    _pointssend = [];
                    tries = 0;
                  });
                }));
      }
      var j = 0;
      return new Stack(children: [
        new Container(
          child: _buildpoint(_pointssend, coloris, xstart, ystart),
        ),
        new Column(
          children: [
            new LimitedBox(
                maxHeight: maxHeight,
                child: new Material(
                    color: Colors.orange,
                    elevation: 4.0,
                    textStyle: new TextStyle(
                        color: Colors.white,
                        fontSize: buttonConfig.fontSize / 1.3),
                    child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(buttonPadding / 2.0),
                            child: UnitButton(
                              text: words,
                              bgImage: words,
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
                                  j,
                                  e,
                                  _statuses[j],
                                  _shakeCells[j],
                                  offsets[j],
                                  _visibleflag[j++])))
                          .toList(growable: false),
                    )))
          ],
        ),
      ]);
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
    var flag = 0;
    print("hello canvas is ....${size.height}");
    var paint = new Paint()
      ..color = coloris
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 9.0;
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
      this.status,
      this.tile,
      this.offset,
      this.code,
      this.vflag,
      this.onStart,
      this.onCancel,
      this.onwill})
      : super(key: key);
  final String text;
  Status status;
  ShakeCell tile;
  final Offset offset;
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
                    onAccept: (int d) => (widget.tile == ShakeCell.Right ||
                            widget.status == Status.First)
                        ? {}
                        : widget.onCancel(v, o),
                    onWillAccept: (int data) =>
                        (widget.tile == ShakeCell.Right ||
                                widget.status == Status.First)
                            ? {}
                            : widget.onwill(data),
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new Material(
                          elevation: widget.vflag == true ? 8.0 : 0.0,
                          color: Colors.transparent,
                          child: new UnitButton(
                            highlighted: widget.vflag,
                            text: _displayText,
                            onPress: () => {},
                            unitMode: UnitMode.text,
                            showHelp: false,
                          ));
                    })
                : new Draggable(
                    onDragStarted: () =>
                        widget.tile == ShakeCell.Right ? {} : widget.onStart(),
                    onDraggableCanceled: (v, g) =>
                        widget.tile == ShakeCell.Right
                            ? {}
                            : widget.onCancel(v, g),
                    maxSimultaneousDrags: 1,
                    data: widget.code,
                    feedback: new Container(),
                    child: new UnitButton(
                      highlighted: widget.vflag,
                      text: _displayText,
                      onPress: () => {},
                      unitMode: UnitMode.text,
                      showHelp: false,
                    ))));
  }
}
