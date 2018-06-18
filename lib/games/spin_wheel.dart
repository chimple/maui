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

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  void initState() {
    super.initState();
    controller1 = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this);
    controller = new AnimationController(
        duration: Duration(milliseconds: 100), vsync: this);
    shakeAnimate = new Tween(begin: -2.0, end: 2.0).animate(controller);
    noAnimation = new Tween(begin: -0.0, end: 0.0).animate(controller);
    animatoin = new CurvedAnimation(parent: controller1, curve: Curves.easeIn);
    controller1.addStatusListener((status) {});
    controller1.forward();
    _initBoard();
  }

  _initBoard() {
    for (int i = 0; i < _slice.length; i++) {
      _slice[i] = false;
    }
    setState(() {
      rotationPercent = 0.0;
      rotationPercent1 = 0.0;
    });
    _smallerCircleData.shuffle();
    _containerData.shuffle();
    for (int i = 0; i < _smallerCircleData.length; i++) {
      print("");
    }
    setState(() {
      ///  List<CircularStackEntry> _data = _generateChartData(100.0);
      //_chartKey.currentState.updateData(_data);
    });
    _indexOfContainerData = _smallerCircleData.indexOf(_containerData[0]);
    _slice[_indexOfContainerData] = true;
    print("index of sllice active: $_indexOfContainerData");
  }

  @override
  void didUpdateWidget(SpinWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
      // List<CircularStackEntry> data = _generateChartData(1.0);
      // _chartKey.currentState.updateData(data);
    }
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
    if (_angleDiff >= 20.0 && _angleDiff <= 30.0 && _slice[0] == true) {
      print("Slice0::");
      setState(() {
        _wheelColor[0] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = .375;
      });
      _slice[0] = false;
      _decreaseAngle(rotationPercent);
      _changeData();
    } //1
    else if (_angleDiff >= 61.0 && _angleDiff <= 79.0 && _slice[1] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[1] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 1.125;
      });
      _slice[1] = false;

      _changeData();
    }
    //2
    else if (_angleDiff >= 100.0 && _angleDiff <= 121.0 && _slice[2] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[2] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 1.875;
      });
      _slice[2] = false;
      _changeData();
    }
    //3
    else if (_angleDiff >= 145.0 && _angleDiff <= 165.0 && _slice[3] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[3] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 2.75;
      });
      _slice[3] = false;
      _changeData();
    }
    //4
    else if (_angleDiff >= 190.0 && _angleDiff <= 210.0 && _slice[4] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[4] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 3.5;
      });
      _slice[4] = false;
      _changeData();
    }
    //5
    else if (_angleDiff >= 230.0 && _angleDiff <= 255.0 && _slice[5] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[5] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 4.25;
      });
      _slice[5] = false;
      _changeData();
    }
    //6
    else if (_angleDiff >= 275.0 && _angleDiff <= 300.0 && _slice[6] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[6] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 5.1;
      });
      _slice[6] = false;
      _changeData();
    }
    //7
    else if (_angleDiff >= 320.0 && _angleDiff <= 345.0 && _slice[7] == true) {
      print("Slice1::");
      setState(() {
        _wheelColor[7] = 0XFF8FBC8F;
        List<CircularStackEntry> data = _generateChartData(100.0);
        _chartKey.currentState.updateData(data);
        rotationPercent = 5.9;
      });
      _slice[7] = false;
      _changeData();
    } else {
      _changeData();
      _shake();
      new Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          doShake = false;
          _slice[_indexOfContainerData] = false;
        });
      });
    }
  }

  void _shake() {
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.forward();
      } else if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });
    controller.forward();
    doShake = true;
  }

  void _changeData() {
    setState(() {
      _indexOfContainerData++;
      if (_indexOfContainerData == 8) {
        _indexOfContainerData = 0;
      }
      _slice[_smallerCircleData
          .indexOf(_containerData[_indexOfContainerData])] = true;
      List<CircularStackEntry> _data = _generateChartData(100.0);
      _chartKey.currentState.updateData(_data);
    });

    new Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        dragEnd = 0.0;
        rotationPercent = 0.0;
        angleDiff = 0.0;
        _chartKey.currentState.updateData(data);
      });
    });
    print("slice no::$_indexOfContainerData");
    for (int i = 0; i < _smallerCircleData.length; i++) {
      if (_slice[i] == true) {
        _countGameEnd++;
      }
    }
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
    Size size2= MediaQuery.of(context).size;;
    Size size1 = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLanscape = orientation == Orientation.landscape;
    size1 = new Size(size1.height * .6, size1.height * .6);
    size2= new Size(size2.height * .6+15.0, size2.height * .6+15.0);
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
                      _containerData[_indexOfContainerData],
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
                    child: new AnimatedCircularChart(
                      size: size2,
                      duration: Duration(milliseconds: 1),
                      initialChartData: _generateChartData(100.0),
                      chartType: CircularChartType.Radial,
                      edgeStyle: SegmentEdgeStyle.round,
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
                  new Center(
                    child: new Container(
                      height: size1.width,
                      width: size1.width,
                      child: new Center(
                        child: new CustomPaint(
                          painter: ArrowPainter(),
                        ),
                      ),
                    ),
                  ),
                  // new Center(
                  //   child: new Transform(
                  //     transform: new Matrix4.rotationZ(-rotationPercent1),
                  //     alignment: Alignment.center,
                  //     child: new Container(
                  //       child: new AnimatedCircularChart(
                  //           size: size1 * .5,
                  //           initialChartData: data1,
                  //           chartType: CircularChartType.Pie),
                  //     ),
                  //   ),
                  // ),
                  // new Center(
                  //   child: new FittedBox(
                  //     child: new Image.asset(
                  //       'assets/arrow.png',
                  //     //  scale: .4,
                  //       color:  Colors.blue,
                  //       height: _size.width/2
                  //     ),
                  //   ),
                  // ),
                  // new Center(
                  //     child: new Container(
                  //         height: size1.width * .80 * .50,
                  //         width: size1.width * .80 * .50,
                  //         child: new RadialDragGestureDetector(
                  //             onRadialDragStart: _onDragStart1,
                  //             onRadialDragUpdate: _onDragUpdate1,
                  //             onRadialDragEnd: _onDragEnd1,
                  //             child: new Container(
                  //               //height: size1.width,
                  //               //width: size1.width,
                  //               child: new CustomPaint(
                  //                 painter: InnerCircle(
                  //                   ticksPerSection1: rotationPercent1,
                  //                 ),
                  //               ),
                  //             )))),
                  // new Center(
                  //   child: new FittedBox(
                  //     child: new Image.asset(
                  //       'assets/arrow.png',
                  //       scale: .2,
                  //       color:  Colors.blue,
                  //       height: _size.width/2
                  //     ),
                  //   ),
                  // ),
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

    // if (i == 2) {}
    // return new Stack(
    //   children: <Widget>[
    //     new Center(
    //         child: new AspectRatio(
    //       aspectRatio: 1.0,
    //       child: new Container(
    //           margin: const EdgeInsets.all(2.0),
    //           decoration: new BoxDecoration(
    //               shape: BoxShape.circle,
    //               gradient: new LinearGradient(
    //                 begin: Alignment.center,
    //                 end: Alignment.center,
    //                 colors: [
    //                   GRADIENT_TOP,
    //                   GRADIENT_BOTTOM,
    //                 ],
    //               ),
    //               boxShadow: [
    //                 new BoxShadow(
    //                   color: const Color(0x44000000),
    //                   blurRadius: 3.0,
    //                   spreadRadius: 1.0,
    //                   offset: const Offset(0.0, 1.0),
    //                 )
    //               ]),
    //           child: new RadialDragGestureDetector(
    //               onRadialDragStart: _onDragStart,
    //               onRadialDragUpdate: _onDragUpdate,
    //               onRadialDragEnd: _onDragEnd,
    //               child: new Container(
    //                 // padding: const EdgeInsets.all(60.0),
    //                 // height: _ht,
    //                 //width: _wd,
    //                 child: new CustomPaint(
    //                   painter: OuterCircle(
    //                     ticksPerSection: rotationPercent,
    //                   ),
    //                 ),
    //               ))),
    //     )),

    //     new Center(
    //       //widthFactor: 100.0,
    //       // padding: const EdgeInsets.all(10.0),
    //       child: new Container(
    // height: double.infinity,
    // margin: isLandscape == true
    //     ? const EdgeInsets.symmetric(horizontal: 150.0)
    //     : const EdgeInsets.symmetric(horizontal: 70.0),
    //           // height: double.infinity/aspectRatio2,
    //           //width: _wd/aspectRatio2,
    //           decoration: new BoxDecoration(
    //               shape: BoxShape.circle,
    //               gradient: new LinearGradient(
    //                 begin: Alignment.center,
    //                 end: Alignment.center,
    //                 colors: [
    //                   GRADIENT_TOP,
    //                   GRADIENT_BOTTOM,
    //                 ],
    //               ),
    //               boxShadow: [
    //                 new BoxShadow(
    //                     color: const Color(0x44000000),
    //                     blurRadius: 3.0,
    //                     spreadRadius: 3.0,
    //                     offset: const Offset(0.0, 1.0))
    //               ]),
    //           child: new RadialDragGestureDetector(
    //               onRadialDragStart: _onDragStart1,
    //               onRadialDragUpdate: _onDragUpdate1,
    //               onRadialDragEnd: _onDragEnd1,
    //               child: new Container(
    //                 margin: const EdgeInsets.all(1.0),
    //                 //margin: const EdgeInsets.all(100.0),
    //                 //  margin: ,
    //                 // height: double.infinity,
    //                 // width: _wd/aspectRatio2,
    //                 child: new CustomPaint(
    //                   painter: InnerCircle(
    //                     ticksPerSection1: rotationPercent1,
    //                   ),
    //                 ),
    //               ))),
    //     ),
    //     new Center(
    //       // padding: const EdgeInsets.all(10.0),
    //       child: new Container(
    //         height: double.infinity,
    //         width: double.infinity,
    //         decoration: new BoxDecoration(
    //             shape: BoxShape.circle,
    //             gradient: new LinearGradient(
    //               begin: Alignment.center,
    //               end: Alignment.center,
    //               colors: [
    //                 GRADIENT_TOP,
    //                 GRADIENT_BOTTOM,
    //               ],
    //             ),
    //             boxShadow: [
    //               new BoxShadow(
    //                   color: const Color(0x44000000),
    //                   blurRadius: 3.0,
    //                   spreadRadius: 3.0,
    //                   offset: const Offset(0.0, 1.0))
    //             ]),
    //       ),
    //     ),
    // new Center(
    //   child: new AspectRatio(
    //     aspectRatio: aspectRatio4,
    //     child: new Container(
    //       height: double.infinity,
    //       width: double.infinity,
    //       child: new Center(
    //         child: new CustomPaint(
    //           painter: ArrowPainter(),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    //   ],
    // );
  }
}
