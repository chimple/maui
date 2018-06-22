import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttery/gestures.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import '../components/spins.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:ui' as ui show Image;
import 'dart:ui' as ui show instantiateImageCodec, Codec, FrameInfo;

class SpinWheel extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  bool isRotated;
  UnitMode unitMode;
  GameConfig gameConfig;
  SpinWheel(
      {key,
      this.unitMode,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.function,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);
  @override
  _SpinWheelState createState() => new _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> with TickerProviderStateMixin {
  List<Color> _wheelColor = [
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFFFFFFF),
    Color(0XFFA46DBA),
    Color(0XFFA292FF),
  ];
  Color _black = Color(0XFF00000);
  List<String> _circleData = [],
      _smallCircleData = [],
      _shuffleCircleData1 = [],
      _shuffleCircleData2 = [];

  Map<String, String> _data = {
    'A': 'a',
    'B': 'Ball',
    '6': 'six',
    'D': 'Dog',
    '1': 'one',
    'F': 'Fan',
    '3': 'Three',
    'H': 'Hen',
  };
  Map<String, String> _allData = new Map<String, String>();
  List<bool> _slice = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> _sliceCopy = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  Animation shakeAnimate, noAnimation, animatoin;
  AnimationController controller, controller1;

  double rotationPercent = 0.0, rotationPercent1 = 0.0, angleDiff;
  Duration selectedTime, startDragTime;
  final maxTime = const Duration(minutes: 10);
  final currentTime = new Duration(minutes: 0);

  var _angleDiffAntiCockWise = 0.0,
      onDragCordUpdated,
      onDragCordStarted,
      _angleOnDragEnd = 0.0,
      _angleOnDragStard = 0.0,
      dragStart = 0.0,
      dragEnd = 0.0,
      dragEnd1 = 0.0,
      dragUpdate = 0.0,
      _angleDiff,
      _constAngle;
  int _indexOfContainerData = 0, _numberOfSlice = 8, _activeIndex;
  String _text = '';
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  List<ui.Image> images = new List<ui.Image>();
  List<String> _imageData = [
    'assets/hoodie/reflex_happy.png',
    'assets/hoodie/abacus_happy.png',
    'assets/hoodie/bingo_happy.png',
    'assets/hoodie/calculate_numbers_happy.png',
    'assets/hoodie/casino_happy.png',
    'assets/hoodie/circle_words_happy.png',
    'assets/hoodie/clue_game_happy.png',
    'assets/hoodie/clue_game_happy.png',
    'assets/hoodie/clue_game_happy.png',
    'assets/hoodie/casino_happy.png',
    'assets/hoodie/circle_words_happy.png',
    'assets/hoodie/clue_game_happy.png',
    'assets/hoodie/clue_game_happy.png',
  ];
  //List<ui.Image> asas;
  @override
  void initState() {
    print("sasfffsa ${widget.unitMode}");
    super.initState();

    controller1 = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);
    controller = new AnimationController(
        duration: Duration(milliseconds: 100), vsync: this);
    shakeAnimate = new Tween(begin: -4.0, end: 4.0).animate(controller);
    noAnimation = new Tween(begin: -0.0, end: 0.0).animate(controller);
    animatoin =
        new CurvedAnimation(parent: controller1, curve: Curves.easeInOut);
    controller1.addStatusListener((status) {});
    controller1.forward();

    print("all data from list::$images");
    _initBoard();
  }

  Future<ui.Image> load(String asset) async {
    print("print asset value:: $asset");
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void didUpdateWidget(SpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration && widget.iteration != 2) {
      _indexOfContainerData = 0;
      _circleData.clear();
      _smallCircleData.clear();
      _shuffleCircleData1.clear();
      _shuffleCircleData2.clear();
      reset();
    }
  }

  _initBoard() async {
    for (int i = 0; i < 8; i++) {
      load(_imageData[i]).then((i) {
        images.add(i);
      });
    }
   // _allData = await fetchPairData(widget.gameConfig.gameCategoryId, 8);
    _data.forEach((k, v) {
      _circleData.add(k);
      _shuffleCircleData1.add(k);
      _smallCircleData.add(v);
      _shuffleCircleData2.add(v);
    });
    _shuffleCircleData1.shuffle();
    _shuffleCircleData2.shuffle();
    setState(() {
      rotationPercent = 0.0;
      _text = _shuffleCircleData2[0];
    });
    _activeIndex = _smallCircleData.indexOf(_text);
    int a = _shuffleCircleData1.indexOf(_circleData[_activeIndex]);
    _slice[a] = true;
  }

  void reset() {
    _data.forEach((k, v) {
      _circleData.add(k);
      _shuffleCircleData1.add(k);
      _smallCircleData.add(v);
      _shuffleCircleData2.add(v);
    });
    _shuffleCircleData1.shuffle();
    _shuffleCircleData2.shuffle();
    controller1.forward();
    _countGameEnd = 0;
    for (int i = 0; i < 8; i++) {
      _slice[i] = _sliceCopy[i];
    }
    dragEnd = 0.0;
    angleDiff = 0.0;
    setState(() {
      rotationPercent = 0.0;
      _text = _shuffleCircleData2[0];
    });
    _activeIndex = _smallCircleData.indexOf(_text);
    int a = _shuffleCircleData1.indexOf(_circleData[_activeIndex]);
    _slice[a] = true;
    if (_numberOfSlice == 2) {
    } else if (_numberOfSlice == 4) {
    } else if (_numberOfSlice == 6) {
    } else if (_numberOfSlice == 8) {
      for (int i = 0; i < 8; i++) {
        setState(() {
          _wheelColor[0] = Color(0XFF48AECC);
          _wheelColor[1] = Color(0XFFE66796);
          _wheelColor[2] = Color(0XFFFF7676);
          _wheelColor[3] = Color(0XFFEDC23B);
          _wheelColor[4] = Color(0XFFAD85F9);
          _wheelColor[5] = Color(0XFF77DB65);
          _wheelColor[6] = Color(0XFF66488C);
          _wheelColor[7] = Color(0XFFDD6154);
          List<CircularStackEntry> data =
              _generateChartData(200.0, Colors.pink);

          _chartKey.currentState.updateData(data);
        });
      }
    }

    print("color codes::$_wheelColor");
  }

  _onDragStart(PolarCoord cord) {
    onDragCordStarted = cord;
    _angleOnDragStard = (cord.angle / (2 * pi) * 360);
    startDragTime = currentTime;
    setState(() {
      rotationPercent = dragEnd;
    });
  }

  _onDragUpdate(PolarCoord dragCord) {
    onDragCordUpdated = dragCord;
    if (onDragCordStarted != null) {
      angleDiff = onDragCordStarted.angle - dragCord.angle;
      angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
      _angleDiffAntiCockWise = -dragCord.angle + onDragCordStarted.angle;

      _angleDiffAntiCockWise = _angleDiffAntiCockWise <= 0
          ? _angleDiffAntiCockWise
          : (_angleDiffAntiCockWise - (2 * pi));

      _angleDiff = angleDiff;

      setState(() {
        rotationPercent = angleDiff + dragEnd; //angleDiff + dragEnd;
      });
    }
    _angleOnDragEnd = (dragCord.angle / (2 * pi) * 360);
  }

  _onDragEnd() {
    print("Drag Start here:: ${_angleOnDragStard}");
    print("Drag End here:: ${_angleOnDragEnd}");
    dragEnd = rotationPercent;
    _angleDiff = (angleDiff / (2 * pi) * 360);

    compareTheangle();
  }

  void compareTheangle() {
    //0
    if (_angleDiff >= 10.0 && _angleDiff <= 40.0 && _slice[0] == true) {
      print("Slice0::");

      _slice[0] = null;

      _changeData(0, .375);
    } //1
    else if (_angleDiff >= 45.0 && _angleDiff <= 85.0 && _slice[1] == true) {
      print("Slice1::");

      _slice[1] = null;

      _changeData(1, 1.125);
    }
    //2
    else if (_angleDiff >= 95.0 && _angleDiff <= 130.0 && _slice[2] == true) {
      print("Slice1::");

      _slice[2] = null;
      _changeData(2, 1.875);
    }
    //3
    else if (_angleDiff >= 140.0 && _angleDiff <= 175.0 && _slice[3] == true) {
      print("Slice1::");

      _slice[3] = null;
      _changeData(3, 2.75);
    }
    //4
    else if (_angleDiff >= 185.0 && _angleDiff <= 215.0 && _slice[4] == true) {
      print("Slice1::");

      _slice[4] = null;
      _changeData(4, 3.5);
    }
    //5
    else if (_angleDiff >= 225.0 && _angleDiff <= 265.0 && _slice[5] == true) {
      print("Slice1::");

      _slice[5] = null;
      _changeData(5, 4.25);
    }
    //6
    else if (_angleDiff >= 275.0 && _angleDiff <= 315.0 && _slice[6] == true) {
      print("Slice1::");

      _slice[6] = null;
      _changeData(6, 5.1);
    }
    //7
    else if (_angleDiff >= 315.0 && _angleDiff <= 355.0 && _slice[7] == true) {
      print("Slice1::");
      _slice[7] = null;
      _changeData(7, 5.9);
    } else {
      _shake();
      new Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          doShake = false;
          List<CircularStackEntry> _data =
              _generateChartData(100.0, Colors.pink);
          _chartKey.currentState.updateData(_data);
          dragEnd = 0.0;
          rotationPercent = 0.0;
          angleDiff = 0.0;
          _slice[_indexOfContainerData] = false;
        });
      });
    }
  }

  void _shake() {
    controller.addStatusListener((status) {
      controller.duration.inSeconds;
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      } else if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });
    controller.forward();
    doShake = true;
  }

  int _index = 1;
  void _changeData(int indx, double angle) {
    new Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _wheelColor[indx] = new Color(0XFF8FBC8F);
        List<CircularStackEntry> data = _generateChartData(200.0, Colors.pink);
        _chartKey.currentState.updateData(data);
        rotationPercent = angle;
      });
    });
    new Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        _text = _shuffleCircleData2[++_indexOfContainerData];
        _activeIndex = _smallCircleData.indexOf(_text);
        print("index of samll circle: ${_circleData[_activeIndex]}");
        int a = _shuffleCircleData1.indexOf(_circleData[_activeIndex]);
        _slice[a] = true;

        _chartKey.currentState.updateData(data);
      });
    });
    print("slice no::$_index");
    if (_countGameEnd == 7) {
      new Future.delayed(Duration(seconds: 2), () {
        widget.onEnd();
      });
    }
    _countGameEnd++;
    print("game count $_countGameEnd");
  }

  int _countGameEnd = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CircularStackEntry> data;
  List<CircularStackEntry> _generateChartData(double value, Color c) {
    data = [
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, c, rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q6'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q7'),
          new CircularSegmentEntry(500.0, c, rankKey: 'Q8'),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];

    return data;
  }

  bool doShake = true;
  bool test = true;
  @override
  Widget build(BuildContext context) {
    double _sizeOfWheel;
    Size size2 = MediaQuery.of(context).size;
    //Image image= new Image(image: AssetImage('assets/hoodie/draw_challenge_happy.png'),);
    Size size1 = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLanscape = orientation == Orientation.landscape;
    size1 = new Size(size1.height * .6, size1.height * .6);
    size2 = new Size(size2.height * .6 + 7.0, size2.height * .6 + 7.0);
    double _constant;
    return new LayoutBuilder(builder: (context, constraints) {
      final bool isPortrait = orientation == Orientation.portrait;
      Size _size;
      int flag = 0;
      if (constraints.maxHeight > constraints.maxWidth) {
        _sizeOfWheel = constraints.maxWidth;
        _size = new Size(_sizeOfWheel + .20 * _sizeOfWheel,
            _sizeOfWheel + _sizeOfWheel * .20);
      } else {
        _sizeOfWheel = constraints.maxHeight;
        _size = new Size(
            _sizeOfWheel - _sizeOfWheel * .2, _sizeOfWheel - _sizeOfWheel * .2);
      }

      if (flag == 0)
        return new Flex(
          direction: Axis.vertical,
          children: <Widget>[
            new Expanded(
              flex: 1,
              child: new Text(''),
            ),
            new Expanded(
              flex: 2,
              child: new Container(
                width: size1.width,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(20.0),
                  gradient:
                      new LinearGradient(colors: [Colors.pink, Colors.red]),
                  color: Colors.red,
                ),
                child: new Shake(
                  animation: doShake == true ? shakeAnimate : noAnimation,
                  child: new Container(
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        gradient: new LinearGradient(
                          tileMode: TileMode.mirror,
                          colors: [Colors.blue, Colors.green],
                          //begin:
                        )),
                    child: new Center(
                        child: new Text(
                      _text,
                      style: new TextStyle(
                        fontSize: 30.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: new Text(''),
            ),
            new Expanded(
              flex: 5,
              child: new Stack(
                children: <Widget>[
                  new Center(
                    child: new ScaleTransition(
                      scale: animatoin,
                      child: new AnimatedCircularChart(
                        size: size2,
                        duration: Duration(milliseconds: 1),
                        initialChartData:
                            _generateChartData(100.0, Colors.black),
                        chartType: CircularChartType.Radial,
                        edgeStyle: SegmentEdgeStyle.round,
                      ),
                    ),
                  ),
                  new Center(
                    child: new Transform(
                      // transformHitTests: ,
                      origin: new Offset(0.0, 0.0),
                      transform: new Matrix4.rotationZ(-rotationPercent),
                      alignment: Alignment.center,
                      child: new ScaleTransition(
                        scale: animatoin,
                        child: new AnimatedCircularChart(
                            duration: Duration(milliseconds: 1),
                            // percentageValues: false,
                            key: _chartKey,
                            edgeStyle: SegmentEdgeStyle.flat,
                            size: size1,
                            initialChartData:
                                _generateChartData(100.0, Colors.white),
                            chartType: CircularChartType.Pie),
                      ),
                    ),
                  ),
                  new Center(
                      child: new ScaleTransition(
                    scale: animatoin,
                    child: new Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        //color: Colors.red
                      ),
                      height: size1.width * .8,
                      width: size1.width * .8,
                      child: new RadialDragGestureDetector(
                          onRadialDragStart: _onDragStart,
                          onRadialDragUpdate: _onDragUpdate,
                          onRadialDragEnd: _onDragEnd,
                          child: new Container(
                              child: new CustomPaint(
                            painter: widget.unitMode == UnitMode.image
                                ? OuterCircle(
                                    ticksPerSection: rotationPercent,
                                    sizePaint: _constant,
                                    data: _shuffleCircleData1,
                                  )
                                : ClippedPainter(
                                    images: images, rotation: rotationPercent),
                          ))),
                    ),
                  )),
                  new ScaleTransition(
                    scale: animatoin,
                    child: new Center(
                      child: new Center(
                        child: new CustomPaint(
                          painter: ArrowPainter(sizeArrow: size2),
                        ),
                      ),
                    ),
                  ),
                  new ScaleTransition(
                    scale: animatoin,
                    child: Center(
                      child: new Container(
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            //color: Colors.white,
                            gradient: new LinearGradient(
                                colors: [Colors.blue, Colors.pink])),
                        height: size1.width * .15,
                        width: size1.width * .15,
                      ),
                    ),
                  )
                ],
              ),
            ),
            new Expanded(
              flex: 1,
              child: new Text(''),
            )
          ],
        );
      else {}
      // return Center(
      //   child: new ClipOval(
      //       clipper: ,),
      // );
    });
  }
}
