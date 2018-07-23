import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/Shaker.dart';

import '../components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/gameaudio.dart';

class Connectdots extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Connectdots(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new ConnectdotsState();
}

enum Status { Active, Visible, Disappear, Draggable, Dragtarget, First }
enum ShakeCell { Right, InActive, Dance, CurveRow }

class ConnectdotsState extends State<Connectdots> {
  var i = 0;

  //var count=0;
  List<bool> _visibleflag = [];

  final int _size = 4;
  static int size = 4;
  var j = size;
  var n = size;
  var m = size;
  var k = 0;
  var count1 = 0;
  //var count2=0;
  var count3 = 0;
  var count6 = 0;
  var count4 = 0;
  //var count5=0;
  bool start = false;
  var count0 = 0;
  int totalgame = 2;
  var r;
  var rand;
  var code;
  List<String> numbers = [];
  List<String> forAns = [];

  List<String> _shuffledLetters = [];

  List _copyAns = [];

  List<String> _letters;

  List<String> _todnumber = [];
  List<Status> _statuses;
  List<String> _letterex = [];
  List<int> tempindex = [];
  bool _isLoading = true;
  var z = 0;
  int tries = 0;
  int lastclick;
  List<Offset> _pointssend = <Offset>[];
  Tuple2<List<String>, List<String>> consecutive;
  var temp = 0;

  List<ShakeCell> _ShakeCells = [];
  @override
  void initState() {
    super.initState();
    print("hello this should come first...");
    _initBoard();
  }

  void _initBoard() async {
    print("data is seecond");
    print("itratin is ....::...${widget.iteration}");

    setState(() => _isLoading = true);
    consecutive = await fetchConsecutiveData(widget.gameCategoryId, 7, 9);
    print("hello this is the data od gamecategory ${widget.gameCategoryId}");

    print("this data is coming from fetchng ${consecutive.item1}");

    consecutive.item1.forEach((e) {
      _copyAns.add(e);
    });

    var rnge = new Random();
    for (var i = 0; i < 1; i++) {
      rand = rnge.nextInt(2);
    }
    if (rand == 1) {
      consecutive.item1.forEach((e) {
        numbers.add(e);
      });
      consecutive.item2.forEach((v) {
        numbers.add(v);
      });
    } else {
      consecutive.item2.forEach((e) {
        numbers.add(e);
      });
      consecutive.item1.forEach((v) {
        numbers.add(v);
      });
    }
    print("suffle data is in my numbers is $numbers");

    print("sorted numbers are $numbers ");

    for (var i = 0; i < numbers.length; i += _size * _size) {
      _shuffledLetters
          .addAll(numbers.skip(i).take(_size * _size).toList(growable: true));
    }
    _statuses = numbers.map((a) => Status.Draggable).toList(growable: false);
    _ShakeCells =
        numbers.map((a) => ShakeCell.InActive).toList(growable: false);

    print(_shuffledLetters);

    var todnumbers = new List.generate(m, (_) => new List(n));
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        count3 = j + 1 + count1;

        //  count3= count2+j+1+count1;
        print("print something in forloop");
        _shuffledLetters.sublist(count1, count3).forEach((e) {
          todnumbers[i][j] = e;
        });

        print("value of 2d is each time $todnumbers");
      }
      count1 = count3;
    }
    for (var i = 1; i < size; i++) {
      if (i % 2 != 0) {
        Iterable letdo = todnumbers[i].reversed;
        var fReverse = letdo.toList();

        print("value of 2d is $todnumbers");

        print("RRRRRR $fReverse");
        todnumbers[i].setRange(0, size, fReverse.map((e) => e));
        print("value o ooppps$todnumbers");
      }
    }

    todnumbers.forEach((e) {
      e.forEach((v) {
        _todnumber.add(v);
      });
    });

    print("2d value is in my oops is$_todnumber");

    var todcolnumbers = new List.generate(m, (_) => new List(n));
    for (var i = 0; i < size; i++) {
      if (i % 2 != 0) {
        print("this treacing $count6");
        print("this treacing 2count$count4");

        for (var j = size - 1; j >= 0; j--) {
          count6 = 1 + count4;

          print("this jjjj is $j");

          _shuffledLetters.sublist(count4, count6).forEach((e) {
            todcolnumbers[j][i] = e;
          });

          print("value of 2d is cols each time $todcolnumbers");
          count4 = count6;
        }
      } else {
        for (var j = 0; j < size; j++) {
          count6 = j + 1 + count4;
          // count6= count2+j+1+count4;
          print("print something in forloop");
          _shuffledLetters.sublist(count4, count6).forEach((e) {
            todcolnumbers[j][i] = e;
          });

          print("value of 2d is cols each time $todcolnumbers");
        }
      }
      count4 = count6;
    }

    todcolnumbers.forEach((e) {
      e.forEach((v) {
        _letterex.add(v);
      });
    });

    var rng = new Random();
    for (var i = 0; i < 1; i++) {
      r = rng.nextInt(4);
    }
    if (r == 4) {
      r = r - 1;
    }
    print("hello sir $r");

    switch (r) {
      case 0:
        {
          _letters = _todnumber;
        }
        break;
      case 1:
        {
          Iterable _number4 = _todnumber.reversed;
          var fruitsInReverset = _number4.toList();
          _letters = fruitsInReverset;
        }
        break;

      case 2:
        {
          _letters = _letterex;
        }
        break;
      case 3:
        {
          Iterable _number4 = _letterex.reversed;
          var fruitsInReverset = _number4.toList();
          _letters = fruitsInReverset;
        }
        break;
    }
    _ShakeCells =
        _letters.map((a) => ShakeCell.InActive).toList(growable: false);

    _statuses = _letters.map((a) => Status.Draggable).toList(growable: false);
    _visibleflag = _letters.map((a) => false).toList(growable: false);
    code = rng.nextInt(499) + rng.nextInt(500);
    while (code < 100) {
      code = rng.nextInt(499) + rng.nextInt(500);
    }
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(Connectdots oldWidget) {
    print("object...iterartion in connect dots");
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
        index: index,
        status: status,
        tile: tile,
        offset: offset,
        vflag: vflag,
        code: code,
        onStart: () {
          if (!start) {
            setState(() {
              print('nikkkkkkkkkkkkkk');
              temp = index;
              start = true;
              forAns.add(text);
              tempindex.add(index);
              _pointssend.add(offset);
              lastclick = index;
              _visibleflag[index] = true;
              _statuses[index] = Status.First;
              for (var i = 0; i < _letters.length; i++) {
                if (_statuses[i] == Status.Draggable && index != i) {
                  _statuses[i] = Status.Dragtarget;
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
              _statuses[temp] = Status.Dragtarget;
              setState(() {
                lastclick = index;
                forAns.add(text);
                tempindex.add(index);
                _statuses[tempindex[0]] = Status.Dragtarget;
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
                forAns.removeLast();
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
        //         if (status == Status.Active) {
        //           if(text==_copyAns[i])
        //           {

        //             setState(() {
        //                 _pointssend.add(offset);
        //               _statuses[index] = Status.Visible;
        //               widget.onScore(1);count0++;
        //                       widget.onProgress((count0) / (_copyAns.length-1));

        //             });
        //             print("length is${_copyAns.length}");

        //           i++;
        //               print("hey this onend$i");

        //            if(i==_copyAns.length)
        //             {
        //                 k=0;
        //                 count0=count0-1;

        //   count1=0;

        //   count3=0;
        //   count6=0;
        //   count4=0;
        //  //count5=0;
        //  _pointssend.removeRange(0, _pointssend.length);
        //  _todnumber.removeRange(0, _todnumber.length);
        //               _letters.removeRange(0, _letters.length);

        //                _letterex.removeRange(0, _letterex.length);
        //                numbers.removeRange(0, numbers.length);

        //  _shuffledLetters.removeRange(0, _shuffledLetters.length);

        //                new Future.delayed(const Duration(milliseconds: 250),
        //                           () {

        //                         widget.onEnd();

        //                       });
        //             }

        //           }
        //           else{
        //               setState(() {
        //              _ShakeCells[index] = ShakeCell.Right;
        //              print("hello shake cell list$_ShakeCells");
        //                new Future.delayed(const Duration(milliseconds: 400), () {
        //                 setState(() {
        //                    widget.onScore(-1);

        //                   _ShakeCells[index] = ShakeCell.InActive;
        //                 });
        //               });

        //             });
        //           }
        //         }

        onCancel: (v, g) {
          print("object both value we have to checking ....$forAns.....::");
          print(
              "object both value we have to checking ....${consecutive.item1}.....::");
          int flag = 0;
          setState(() {
            start = false;
            if (forAns.length == consecutive.item1.length) {
              for (int i = 0; i < forAns.length; i++) {
                print("object.....:::.${forAns[i]}");
                if (forAns[i] == consecutive.item1[i]) {
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
              widget.onScore(20);

              setState(() {
                widget.onProgress(1.0);

                count1 = 0;
                forAns = [];
                count3 = 0;
                count6 = 0;
                count4 = 0;
                //count5=0;
                _pointssend.removeRange(0, _pointssend.length);
                _todnumber.removeRange(0, _todnumber.length);
                _letters.removeRange(0, _letters.length);

                _letterex.removeRange(0, _letterex.length);
                numbers.removeRange(0, numbers.length);

                _shuffledLetters.removeRange(0, _shuffledLetters.length);

                new Future.delayed(const Duration(milliseconds: 250), () {
                  start = false;
                  widget.onEnd();
                });
              });
            }
            if (flag == 1) {
              widget.onScore(-1);
              print("object....shanking thing is...:$_visibleflag");
              setState(() {
                forAns = [];

                for (var i = 0; i < _visibleflag.length; i++)
                  _visibleflag[i] == true
                      ? _ShakeCells[i] = ShakeCell.Right
                      : i;
              });
              new Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  _ShakeCells = _letters
                      .map((a) => ShakeCell.InActive)
                      .toList(growable: false);
                  _statuses = _letters
                      .map((a) => Status.Draggable)
                      .toList(growable: false);
                  _visibleflag =
                      _letters.map((a) => false).toList(growable: false);
                  _pointssend = [];
                });
              });
            }

            //     new Future.delayed(const Duration(milliseconds: 800), () {
            //   setState(() {
            //     _ShakeCells = _letters
            //         .map((a) => ShakeCell.InActive)
            //         .toList(growable: false);
            //     _statuses = _letters
            //         .map((a) => Status.Draggable)
            //         .toList(growable: false);
            //     _visibleflag =
            //         _letters.map((a) => false).toList(growable: false);
            //   });
            // }); // _ShakeCells = _letters
            //     .map((a) => ShakeCell.InActive)
            //     .toList(growable: false);
            // _statuses = _letters
            //     .map((a) => Status.Draggable)
            //     .toList(growable: false);
            // _visibleflag =
            //     _letters.map((a) => false).toList(growable: false);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    print("MyTableState.build");
    print("MyTableState.build");

    MediaQueryData media = MediaQuery.of(context);
    print("hello data coming or not in widgets is $_letters");

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    print("how head to head is working");
    var j = 0;

    return new LayoutBuilder(builder: (context, constraints) {
      print("this is where the its comming full");
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      print(
          "object horizantal padding....:$hPadding.....vpadding : ..$vPadding");
      print("object button padding ......:$buttonPadding");
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;

      double fullwidthofscreen = _size * (maxWidth + buttonPadding + hPadding);
      print(
          "object full screen width is ......:$fullwidthofscreen..........=${media.size.height}");
      double buttonarea = maxWidth * maxHeight;
      print("object....buttonarea .......:$buttonarea");
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);

      AppState state = AppStateContainer.of(context).state;
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
      double fullwidth = (_size * buttonConfig.width) + (_size * buttonPadding);
      double removeallpaddingh = constraints.maxWidth - fullwidth;
      double startpointx = removeallpaddingh / 2;
      double removeallpaddingv = constraints.maxHeight - fullwidth;
      double startpointy = removeallpaddingv / 2;

      double yaxis = startpointy + (buttonConfig.height / 2);

      double xaxis = startpointx + (buttonConfig.width / 2);

      print("object..x axis start point is in.....:$xaxis.........$yaxis");
      print(
          ".....maxheight of button...:$maxHeight........max height is :...$vPadding");
      print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
      Offset startpoint = new Offset(xaxis, yaxis);

      List<Offset> offsets1 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);
      yaxis = yaxis + buttonConfig.width + buttonPadding;
      double y1 = yaxis;

      xaxis = xaxis;
      double x1 = xaxis;
      double ystart = yaxis;
      double xstart =
          (xaxis + xaxis + (maxWidth / 1.4)) - (hPadding + buttonPadding);
      print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets2 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);

      yaxis = yaxis + buttonConfig.width + buttonPadding;

      xaxis = xaxis;
      print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets3 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);
      yaxis = yaxis + buttonConfig.width + buttonPadding;
      xaxis = xaxis;
      print("object....:xaxis ..:$xaxis.......y axis...:$yaxis");
      startpoint = new Offset(xaxis, yaxis);
      List<Offset> offsets4 = calculateOffsets(
          buttonPadding, startpoint, _size, buttonConfig.width);

      List<Offset> offsets = offsets1 + offsets2 + offsets3 + offsets4;
      // print("object....startpointaxis is.....$startpointx");
      // print("object button height ....:${state.buttonHeight}.. button width.....:${state.buttonWidth}");
      var coloris = Theme.of(context).primaryColor;
      return new Stack(children: [
        new Container(
          child: _buildpoint(_pointssend, coloris, xstart, ystart),
        ),
        new Padding(
            padding:
                EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
            child: new ResponsiveGridView(
              rows: _size,
              cols: _size,
              //    maxAspectRatio: 1.0,
              children: _letters
                  .map((e) => new Padding(
                      padding: EdgeInsets.all(buttonPadding),
                      child: _buildItem(j, e, _statuses[j], _ShakeCells[j],
                          offsets[j], _visibleflag[j++])))
                  .toList(growable: false),
            )),
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
    var flag = 0;
    print("hello canvas is ....${size.height}");
    var paint = new Paint()
      ..color = coloris
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      print("object....i values varying from 0th position......$i");
      print("object......points offsets is......$points");
      print("object.....points.....::${points[points.length-1]}");

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
      this.onStart,
      this.onCancel,
      this.onwill})
      : super(key: key);

  final String text;
  int index;
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
    print('99999999999999   ${widget.status}');
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
                          elevation: widget.vflag == true ? 10.0 : 0.0,
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
                    data: widget.code,
                    feedback: new Container(),
                    maxSimultaneousDrags: 1,
                    child: new UnitButton(
                      highlighted: widget.vflag,
                      text: _displayText,
                      onPress: () => {},
                      unitMode: UnitMode.text,
                      showHelp: false,
                    ))));
  }
}
