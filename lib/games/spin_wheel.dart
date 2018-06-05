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
  PolarCoord onDragCordStarted, onDragCordUpdated;
  double rotationPercent = 0.0;
  double rotationPercent1 = 0.0;
  Duration selectedTime, startDragTime;
  final maxTime = const Duration(minutes: 10);
  final currentTime = new Duration(minutes: 0);
  double _percentRotate;
  _onDragStart(PolarCoord cord) {
    print("Drag Start here:: $cord");
    onDragCordStarted = cord;
    // var start = cord.angle;
    var angleDiff = onDragCordStarted.angle - cord.angle;
    angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
    final anglePercent = angleDiff / (2 * pi);
    //  final timeDiffInSec = (anglePercent * maxTime.inSeconds).round();
    // selectedTime =
    // new Duration(seconds: startDragTime.inSeconds + timeDiffInSec);
    setState(() {
      rotationPercent = dragEnd;
    });
  }

  _onDragUpdate(PolarCoord dragCord) {
    print("On Drag Updated:: $dragCord");
    if (onDragCordStarted != null) {
      var angleDiff = onDragCordStarted.angle - dragCord.angle;
      angleDiff = angleDiff >= 0 ? angleDiff : angleDiff + (2 * pi);
      final anglePercent = angleDiff / (2 * pi);
      //  final timeDiffInSec = (anglePercent * maxTime.inSeconds).round();
      // selectedTime =
      // new Duration(seconds: startDragTime.inSeconds + timeDiffInSec);
      setState(() {
        rotationPercent = angleDiff + dragEnd;
      });
    }
  }

  var dragStart = 0.0;
  var dragEnd = 0.0;
  _onDragEnd() {
    setState(() {
      dragEnd = rotationPercent;
    });
  }

  _onDragStart1(PolarCoord cord) {
    print("Drag Start here:: $cord");
    onDragCordStarted = cord;
    startDragTime = currentTime;
    setState(() {
      rotationPercent1 = dragEnd;
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
        new TickerFuture.complete();
        rotationPercent1 = angleDiff + dragEnd1;
      });
    }
  }

  double dragEnd1 = 0.0;
  _onDragEnd1() {
    setState(() {
      dragEnd = rotationPercent1;
    });
  }
  double _screenSize;
  Animation animation;
  AnimationController controller;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _sizeOfWheel;
    final Orientation orientation = MediaQuery.of(context).orientation;
    List<CircularStackEntry> data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(1000.0, Colors.red[200], rankKey: 'Q1'),
          new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
          new CircularSegmentEntry(1000.0, Colors.blue[200], rankKey: 'Q3'),
          new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
          new CircularSegmentEntry(1000.0, Colors.red[200], rankKey: 'Q1'),
          new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
          new CircularSegmentEntry(1000.0, Colors.blue[200], rankKey: 'Q3'),
          new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
        ],
        rankKey: 'Quarterly Profits',
      )
    ];
    List<CircularStackEntry> data1 = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(1000.0, Colors.lightGreenAccent[100],
              rankKey: 'Q1'),
          new CircularSegmentEntry(1000.0, Colors.blue[100], rankKey: 'Q2'),
          new CircularSegmentEntry(1000.0, Colors.blue[400], rankKey: 'Q3'),
          new CircularSegmentEntry(1000.0, Colors.pinkAccent[100],
              rankKey: 'Q4'),
          new CircularSegmentEntry(1000.0, Colors.red[100], rankKey: 'Q1'),
          new CircularSegmentEntry(1000.0, Colors.pink[100], rankKey: 'Q2'),
          new CircularSegmentEntry(1000.0, Colors.blue[100], rankKey: 'Q3'),
          new CircularSegmentEntry(1000.0, Colors.yellow[100], rankKey: 'Q4'),
        ],
        rankKey: 'Quarterly Profits',
      )
    ];
    double _constant;
    return new LayoutBuilder(builder: (context, constraints) {
      final bool isPortrait = orientation == Orientation.portrait;
      print(
          'Screen size:::  .....${constraints},${constraints}');
      if (isPortrait) {
        _sizeOfWheel = constraints.maxWidth;
        _constant = 100.0;
      } else {
        _sizeOfWheel = constraints.maxHeight;
        _constant = 5.0;
      }
      return new Stack(
        children: <Widget>[
          new Center(
            child: new Transform(
              transform: new Matrix4.rotationZ(-rotationPercent),
              alignment: Alignment.center,
              child: new Container(
                child: new AnimatedCircularChart(
                    size: new Size(_sizeOfWheel, _sizeOfWheel),
                    initialChartData: data,
                    chartType: CircularChartType.Pie),
              ),
            ),
          ),
          new Center(
              child: new Container(
                decoration: new BoxDecoration(
                  shape: BoxShape.circle
                ),
                height: _sizeOfWheel,
                width: _sizeOfWheel,
            child: new RadialDragGestureDetector(
                onRadialDragStart: _onDragStart,
                onRadialDragUpdate: _onDragUpdate,
                onRadialDragEnd: _onDragEnd,
                child: new Container(
                  height: _sizeOfWheel-120,
                width: _sizeOfWheel-120,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle
                  ),
                  //margin: const EdgeInsets.all(1.0),
                  child: new CustomPaint(
                    
                    painter: OuterCircle(
                      ticksPerSection: rotationPercent,
                      sizePaint: _constant,
                    ),
                  ),
                )),
          )),
          new Center(
            child: new Transform(
              transform: new Matrix4.rotationZ(-rotationPercent1),
              alignment: Alignment.center,
              child: new Container(
                child: new AnimatedCircularChart(
                    size: new Size((_sizeOfWheel) * .6, (_sizeOfWheel) * .6),
                    initialChartData: data1,
                    chartType: CircularChartType.Pie),
              ),
            ),
          ),
          new Center(
              child: new Container(
                  height: (_sizeOfWheel) / 2,
                  width: (_sizeOfWheel) / 2,
                  child: new RadialDragGestureDetector(
                      onRadialDragStart: _onDragStart1,
                      onRadialDragUpdate: _onDragUpdate1,
                      onRadialDragEnd: _onDragEnd1,
                      child: new Container(
                        margin: const EdgeInsets.all(1.0),
                        child: new CustomPaint(
                          painter: InnerCircle(
                            ticksPerSection1: rotationPercent1,
                          ),
                        ),
                      )))),
          new Center(
            child: new Container(
              height: double.infinity,
              width: double.infinity,
              child: new Center(
                child: new CustomPaint(
                  painter: ArrowPainter(),
                ),
              ),
            ),
          ),
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
    //     // new Center(
    //     //   child: new AspectRatio(
    //     //     aspectRatio: aspectRatio4,
    //     //     child: new Container(
    //     //       height: double.infinity,
    //     //       width: double.infinity,
    //     //       child: new Center(
    //     //         child: new CustomPaint(
    //     //           painter: ArrowPainter(),
    //     //         ),
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),
    //   ],
    // );
  }
}
