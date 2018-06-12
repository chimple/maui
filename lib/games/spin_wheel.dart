import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttery/gestures.dart';
import '../components/spins.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

final Color GRADIENT_TOP1 = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM1 = const Color(0xFFE8E8E8);

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

class _SpinWheelState extends State<SpinWheel> {
  var onDragCordStarted, onDragCordUpdated;
  double rotationPercent = 0.0;
  double rotationPercent1 = 0.0;
  Duration selectedTime, startDragTime;
  final maxTime = const Duration(minutes: 10);
  final currentTime = new Duration(minutes: 0);
  double _percentRotate;
  List<String> _smallerCircleData = [
    ' 1',
    '3',
    '7',
    '19',
    '12',
    '45',
    '53',
    '11',
  ];

  // List<String> _bigerCircleData = [
  //   1,
  //   3,
  //   7,
  //   19,
  //   12,
  //   45,
  //   53,
  //   11,
  // ];
  List<double> _dataAngle;
  var _angle;
  //List<int> _index;
  _onDragStart(PolarCoord cord) {
    print("Drag Start here:: $cord");
    onDragCordStarted = cord;
    _angle = cord.angle;
    startDragTime = currentTime;
    setState(() {
      rotationPercent = dragEnd;
    });
    //dragEnd=0.0;
  }

  var angleDiff;
  PolarCoord dragUpdate;

  _onDragUpdate(PolarCoord dragCord) {
    angleDiff = dragCord;
    print("On Drag Updated:: ${angleDiff}");

    onDragCordUpdated = dragCord;
    if (onDragCordStarted != null) {
      angleDiff = onDragCordStarted.angle - dragCord.angle;
      angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
      final anglePercent = angleDiff / (2 * pi);
      //  final timeDiffInSec = (anglePercent * maxTime.inSeconds).round();
      // selectedTime =
      // new Duration(seconds: startDragTime.inSeconds + timeDiffInSec);
      setState(() {
        rotationPercent = angleDiff + dragEnd; //angleDiff + dragEnd;
      });
    }
  }

  var dragStart = 0.0;
  var dragEnd = 0.0;
  var dragEnd1 = 0.0;
  _onDragEnd() {
    //setState(() {
    dragEnd = rotationPercent;
    //});
    //compareTheangle(angleDiff);
    print("started ${(_angle / (2 * pi) * 360)}");
    print("end ${dragUpdate.angle}");
    print('drag end here:: ${angleDiff}');
    // var s = onDragCordStarted - onDragCordUpdated;
    print("sassssssssssjjks $onDragCordStarted");
  }

  void compareTheangle(PolarCoord dragEnd) {
    if (angleDiff.angle == 22.0) {
      print('saaaaaaaaaaaa');
    }
  }

  _onDragStart1(PolarCoord cord) {
    print("Drag Start here:: $cord");
    onDragCordStarted = cord;
    startDragTime = currentTime;
    setState(() {
      rotationPercent1 = dragEnd1;
    });
  }

  _onDragUpdate1(PolarCoord dragCord) {
    print("On Drag Start here:: $dragCord");
    if (onDragCordStarted != null) {
      var angleDiff = onDragCordStarted.angle - dragCord.angle;
      angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
      final anglePercent = angleDiff / (2 * pi);
      final timeDiffInSec = (anglePercent * maxTime.inSeconds).round();
      selectedTime =
          new Duration(seconds: startDragTime.inSeconds + timeDiffInSec);

      setState(() {
        //new TickerFuture.complete();
        rotationPercent1 = angleDiff + dragEnd1;
      });
    }
  }

  _onDragEnd1() {
    setState(() {
      dragEnd1 = rotationPercent1;
    });
  }

  double _screenSize;
  Animation animation;
  AnimationController controller;
  double _constAngle=45.0;
  @override
  void initState() {
    //Size size=MediaQuery.of(context).size;
    // _screenSize=size.width;
    //sleep(const Duration(seconds: 1));
    print('after 1 sec::');
    setState(() {
      rotationPercent = 0.0;
      rotationPercent1 = 0.0;
    });
    _smallerCircleData.shuffle();
    for (int i = 0; i < _smallerCircleData.length; i++) {
      if (i == 0)
        _dataAngle[i] = 22.5;
      else
        _dataAngle[i] = 22.5 + _constAngle;
        _constAngle=_constAngle*2;
    }
    super.initState();
  }

  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  @override
  Widget build(BuildContext context) {
    double _sizeOfWheel;
    Size size1 = MediaQuery.of(context).size;

    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLanscape = orientation == Orientation.landscape;
    if (isLanscape) {
      size1 = new Size(size1.height, size1.height);
    }
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, Colors.green[200], rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, Colors.blue[200], rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, Colors.yellow[200], rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, Colors.green[200], rankKey: 'Q6'),
          new CircularSegmentEntry(500.0, Colors.blue[200], rankKey: 'Q7'),
          new CircularSegmentEntry(500.0, Colors.yellow[200], rankKey: 'Q8'),
        ],
        rankKey: 'Quarterly Profits',
      )
    ];
    List<CircularStackEntry> data1 = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(500.0, Colors.lightGreenAccent[100],
              rankKey: 'Q1'),
          new CircularSegmentEntry(500.0, Colors.blue[100], rankKey: 'Q2'),
          new CircularSegmentEntry(500.0, Colors.blue[400], rankKey: 'Q3'),
          new CircularSegmentEntry(500.0, Colors.pinkAccent[100],
              rankKey: 'Q4'),
          new CircularSegmentEntry(500.0, Colors.red[100], rankKey: 'Q5'),
          new CircularSegmentEntry(500.0, Colors.pink[100], rankKey: 'Q6'),
          new CircularSegmentEntry(500.0, Colors.blue[100], rankKey: 'Q7'),
          new CircularSegmentEntry(500.0, Colors.yellow[100], rankKey: 'Q8'),
        ],
        rankKey: 'Quarterly Profits',
      )
    ];
    double _constant;
    return new LayoutBuilder(builder: (context, constraints) {
      final bool isPortrait = orientation == Orientation.portrait;
      // print('Screen size:::  .....${constraints},${constraints}');
      if (isPortrait) {
        // _sizeOfWheel = constraints.maxWidth + 50;
        _constant = 100.0;
      } else {
        // if(constraints.maxWidth>constraints.maxHeight )
        // _sizeOfWheel = constraints.maxHeight + 50;
        // else
        // _sizeOfWheel=constraints.maxWidth+50;

        _constant = 5.0;
      }
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
      //print("real sie afkjf f$_size");

      if (flag == 0) print("charaf safsafsasaf $_chartKey");
      return new Stack(
        children: <Widget>[
          new Center(
            child: new Transform(
              // transformHitTests: ,
              origin: new Offset(0.0, 0.0),
              transform: new Matrix4.rotationZ(-rotationPercent),
              alignment: Alignment.center,
              child: new AnimatedCircularChart(
                  key: _chartKey,
                  //startAngle: 90.0,
                  edgeStyle: SegmentEdgeStyle.flat,
                  size: size1,
                  initialChartData: data,
                  chartType: CircularChartType.Pie),
            ),
          ),
          new Center(
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
                  ),
                )),
          )),
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
