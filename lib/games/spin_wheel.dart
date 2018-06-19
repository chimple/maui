import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttery/gestures.dart';
import 'package:maui/components/shaker.dart';
import '../components/spins.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

final Color GRADIENT_TOP = const Color(0xFFe4001b);
final Color GRADIENT_BOTTOM = const Color(0xFFc00040);

final Color GRADIENT_TOP1 = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM1 = const Color(0xFFE8E8E8);

class WheelFunction {
  static void rotationDirection(
      double dragStart, double dragEnd, double counterClock, double clockWise) {
    print("angle Diffe::$counterClock");
  }
}

class SpinWheel extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  Function function;
  int gameCategoryId;
  bool isRotated;
  SpinWheel(
      {key,
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
  List<int> _wheelColor = [
    0XFFFF7676,
    0XFFEDC23B,
    0XFFAD85F9,
    0XFF77DB65,
    0XFF66488C,
    0XFFDD6154,
    0XFFFFCE73,
    0XFFD64C60,
    0XFFDD4785,
    0XFF48AECC,
    0XFFE66796,
    0XFFFF7676,
    0XFFEDC23B,
    0XFFAD85F9,
    0XFF77DB65,
    0XFF66488C,
    0XFFDD6154,
  ];
  List<int> _colors = [];
  List<String> _smallerCircleData = [
    '1',
    '3',
    '7',
    '19',
    '12',
    '45',
    '53',
    '11',
  ];
  List<String> _containerData = [
    '1',
    '3',
    '7',
    '19',
    '12',
    '45',
    '53',
    '11',
  ];

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
      _clockWisel,
      _endAngle,
      _angleDiff,
      _constAngle;
  int _indexOfContainerData = 0;
  String _text = '';
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  List<String> _wheelData = [];
  @override
  void initState() {
    _colors = _wheelColor;
    print("collr $_wheelColor");
    print("color $_colors");
    super.initState();
    controller1 = new AnimationController(
        duration: Duration(milliseconds: 400), vsync: this);
    controller = new AnimationController(
        duration: Duration(milliseconds: 100), vsync: this);
    shakeAnimate = new Tween(begin: -3.0, end: 3.0).animate(controller);
    noAnimation = new Tween(begin: -0.0, end: 0.0).animate(controller);
    animatoin = new CurvedAnimation(parent: controller1, curve: Curves.easeIn);
    controller1.addStatusListener((status) {});
    controller1.forward();
    _initBoard();
  }

  _initBoard() {
    _smallerCircleData.shuffle();
    _containerData.shuffle();
    _wheelData = _containerData;
    //print("data:: $_wheelData, $_containerData",);
    _indexOfContainerData = _smallerCircleData.indexOf(_wheelData[0]);
    _slice[_indexOfContainerData] = true;
    setState(() {
      rotationPercent = 0.0;
      _text = _wheelData[0];
    });
    print("index of slice active: $_indexOfContainerData");
    print("print data:: ${_text}");
  }

  @override
  void didUpdateWidget(SpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      //_wheelColor.clear();
      reset();
      _initBoard();
    }
  }

  void reset() {
    _countGameEnd = 0;
    for (int i = 0; i < _slice.length; i++) {
      _slice[i] = false;
    }
    for (int i = 0; i < _wheelColor.length; i++) _wheelColor[i] = _colors[i];
    dragEnd = 0.0;
    rotationPercent = 0.0;
    angleDiff = 0.0;

    setState(() {
      List<CircularStackEntry> data = _generateChartData(100.0);
      _chartKey.currentState.updateData(data);
    });
    print("color alal $_wheelColor");
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
    _endAngle = dragCord;
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
    var _angleDiffClock = (_angleDiffAntiCockWise / (2 * pi) * 360);
    WheelFunction.rotationDirection(
        _angleOnDragStard, _angleOnDragEnd, _angleDiff, _angleDiffClock);
    compareTheangle();
  }

  void _decreaseAngle(double _angle) {
    _constAngle = (_angle / (2 * pi) * 360);
  }

  void compareTheangle() {
    //0
    if (_angleDiff >= 10.0 && _angleDiff <= 40.0 && _slice[0] == true) {
      print("Slice0::");
      setState(() {
        _wheelColor[0] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = .375;
      });
      _slice[0] = null;
      _decreaseAngle(rotationPercent);
      _changeData();
    } //1
    else if (_angleDiff >= 45.0 && _angleDiff <= 85.0 && _slice[1] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[1] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 1.125;
      });
      _slice[1] = null;

      _changeData();
    }
    //2
    else if (_angleDiff >= 95.0 && _angleDiff <= 130.0 && _slice[2] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[2] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 1.875;
      });
      _slice[2] = null;
      _changeData();
    }
    //3
    else if (_angleDiff >= 140.0 && _angleDiff <= 175.0 && _slice[3] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[3] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 2.75;
      });
      _slice[3] = null;
      _changeData();
    }
    //4
    else if (_angleDiff >= 185.0 && _angleDiff <= 215.0 && _slice[4] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[4] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 3.5;
      });
      _slice[4] = null;
      _changeData();
    }
    //5
    else if (_angleDiff >= 225.0 && _angleDiff <= 265.0 && _slice[5] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[5] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 4.25;
      });
      _slice[5] = null;
      _changeData();
    }
    //6
    else if (_angleDiff >= 275.0 && _angleDiff <= 315.0 && _slice[6] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[6] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 5.1;
      });
      _slice[6] = null;
      _changeData();
    }
    //7
    else if (_angleDiff >= 315.0 && _angleDiff <= 355.0 && _slice[7] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[7] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 5.9;
      });
      _slice[7] = null;
      _changeData();
    } else {
      _shake();
      new Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          doShake = false;
          List<CircularStackEntry> _data = _generateChartData(100.0);
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
  void _changeData() {
    new Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        if (_index == 8) _index = 0;
        _text = _wheelData[_index++];
        _slice[_smallerCircleData.indexOf(_text)] = true;
        // List<CircularStackEntry> _data = _generateChartData(100.0);
        // _chartKey.currentState.updateData(_data);
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
    // if(_wheelData.isEmpty)
    // widget.onEnd;
  }

  int _countGameEnd = 0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<CircularStackEntry> data;
  List<CircularStackEntry> _generateChartData(double value) {
    data = [
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, new Color(_wheelColor[0]),
              rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[1]),
              rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[2]),
              rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[3]),
              rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[4]),
              rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[5]),
              rankKey: 'Q6'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[6]),
              rankKey: 'Q7'),
          new CircularSegmentEntry(500.0, new Color(_wheelColor[7]),
              rankKey: 'Q8'),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];

    return data;
  }

  bool doShake = true;
  @override
  Widget build(BuildContext context) {
    double _sizeOfWheel;
    Size size2 = MediaQuery.of(context).size;
    ;
    Size size1 = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLanscape = orientation == Orientation.landscape;
    size1 = new Size(size1.height * .6, size1.height * .6);
    size2 = new Size(size2.height * .6 + 15.0, size2.height * .6 + 15.0);
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
                        initialChartData: _generateChartData(100.0),
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
                            initialChartData: _generateChartData(100.0),
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
                              // height: size1.width*.80,
                              // width: size1.width*.80,
                              child: new CustomPaint(
                            painter: OuterCircle(
                              ticksPerSection: rotationPercent,
                              sizePaint: _constant,
                              data: _smallerCircleData,
                              //sizeOfWheel:
                            ),
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
    });
  }
}
