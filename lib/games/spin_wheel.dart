import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttery/gestures.dart';
import '../components/spins.dart';

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
    // setState(() {
    //   //rotationPercent = dragStart;
    // });
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
    //rotationPercent
    // setState(() {
    //   dragEnd = rotationPercent;
    // });
  }

  _onDragStart1(PolarCoord cord) {
    print("Drag Start here:: $cord");
    onDragCordStarted = cord;
    startDragTime = currentTime;
    setState(() {
      rotationPercent1 = cord.angle + .1;
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

  double dragEnd1=0.0;
  _onDragEnd1() {
    //rotationPercent
    setState(() {
      dragEnd = rotationPercent1;
    });
  }

  Animation animation;
  AnimationController controller;
  @override
  void initState() {
    // TODO: implement initState
    sleep(const Duration(seconds: 1));
    print('after 1 sec::');
    setState(() {
      rotationPercent = 0.0;
      rotationPercent1 = 0.0;
    });
    super.initState();
  }

  @override
  void didUpdateWidget(SpinWheel covariant) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio1, aspectRatio2, aspectRatio3, aspectRatio4;
    double _ht, _wd;
    Size media = MediaQuery.of(context).size;
    _wd = media.width;
    _ht = media.height;
    print("Screen size:: $media");
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    // if (isLandscape) {
    //_ht = media.height / 16;
    // _ht = media.width/50;
    aspectRatio1 = 1.0;
    aspectRatio2 = 1.830;
    aspectRatio3 = 5.500;
    aspectRatio4 = 18.90;
    // } else {
    //   //_ht = media.width/40;
    //   //_ht =110.0;
    //   aspectRatio1 = 1.0;
    //   aspectRatio2 = 1.530;
    //   aspectRatio3 = 3.700;
    //   aspectRatio4 = 12.0;
    //   _wd = _wd / aspectRatio2;
    //   print("width :: $_wd");
    // }
    final a = 30.0;
    return new Flex(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        direction: Axis.vertical,
        children: <Widget>[
          new Expanded(
            flex: 2,
            child: new Container(
              padding: new EdgeInsets.symmetric(vertical: a),
              color: Colors.yellowAccent,
              width: double.infinity,
              child: new Center(
                child: new Text(
                  '1',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
          ),
          new Expanded(
            flex: 8,
            child: new Center(
              // body: new Center(
              //   child: new Container(
              //     width: double.infinity,
              child: new Stack(
                children: <Widget>[
                  new Center(
                      child: new AspectRatio(
                    aspectRatio: aspectRatio1,
                    // child: new Transform.rotate(
                    //   angle: -rotationPercent,
                    child: new Container(
                        margin: const EdgeInsets.all(2.0),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: new LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.center,
                              colors: [
                                GRADIENT_TOP,
                                GRADIENT_BOTTOM,
                              ],
                            ),
                            boxShadow: [
                              new BoxShadow(
                                color: const Color(0x44000000),
                                blurRadius: 3.0,
                                spreadRadius: 1.0,
                                offset: const Offset(0.0, 1.0),
                              )
                            ]),
                        child: new RadialDragGestureDetector(
                            onRadialDragStart: _onDragStart,
                            onRadialDragUpdate: _onDragUpdate,
                            onRadialDragEnd: _onDragEnd,
                            child: new Container(
                              // padding: const EdgeInsets.all(60.0),
                              // height: _ht,
                              //width: _wd,
                              child: new CustomPaint(
                                painter: OuterCircle(
                                  ticksPerSection: rotationPercent,
                                ),
                              ),
                            ))),
                    // ),
                  )),
                  new Center(
                    // padding: const EdgeInsets.all(10.0),
                    child: new AspectRatio(
                      aspectRatio: aspectRatio2,
                      child: new Container(
                          // height: double.infinity,
                          margin: isLandscape == true
                              ? const EdgeInsets.symmetric(horizontal: 150.0)
                              : const EdgeInsets.symmetric(horizontal: 70.0),
                          // height: double.infinity/aspectRatio2,
                          //width: _wd/aspectRatio2,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: new LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.center,
                                colors: [
                                  GRADIENT_TOP,
                                  GRADIENT_BOTTOM,
                                ],
                              ),
                              boxShadow: [
                                new BoxShadow(
                                    color: const Color(0x44000000),
                                    blurRadius: 3.0,
                                    spreadRadius: 3.0,
                                    offset: const Offset(0.0, 1.0))
                              ]),
                          child: new RadialDragGestureDetector(
                              onRadialDragStart: _onDragStart1,
                              onRadialDragUpdate: _onDragUpdate1,
                              onRadialDragEnd: _onDragEnd1,
                              child: new Container(
                                margin: const EdgeInsets.all(1.0),
                                //margin: const EdgeInsets.all(100.0),
                                //  margin: ,
                                // height: double.infinity,
                                // width: _wd/aspectRatio2,
                                child: new CustomPaint(
                                  painter: InnerCircle(
                                    ticksPerSection1: rotationPercent1,
                                  ),
                                ),
                              ))),
                    ),
                  ),
                  new Center(
                    // padding: const EdgeInsets.all(10.0),
                    child: new AspectRatio(
                      aspectRatio: aspectRatio3,
                      child: new Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: new LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.center,
                              colors: [
                                GRADIENT_TOP,
                                GRADIENT_BOTTOM,
                              ],
                            ),
                            boxShadow: [
                              new BoxShadow(
                                  color: const Color(0x44000000),
                                  blurRadius: 3.0,
                                  spreadRadius: 3.0,
                                  offset: const Offset(0.0, 1.0))
                            ]),
                      ),
                    ),
                  ),
                  new Center(
                    child: new AspectRatio(
                      aspectRatio: aspectRatio4,
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
                  ),
                ],
              ),

              //   ),

              // ),
            ),
          ),
        ]);
  }
}

// class ArrowPainter extends CustomPainter {
//   final Paint dialArrowPaint;
//   final double rotationPercent;

//   ArrowPainter({this.rotationPercent}) : dialArrowPaint = new Paint() {
//     dialArrowPaint.color = Colors.black;
//     dialArrowPaint.style = PaintingStyle.fill;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.save();

//     final radius = size.height / 2;
//     canvas.translate(size.width / 2, 0.0);
//     canvas.rotate(0.0);

//     Path path = new Path();
//     path.moveTo(0.0, -170.0);
//     path.lineTo(10.0, -30.0);
//     path.lineTo(-10.0, -30.0);
//     path.close();

//     canvas.drawPath(path, dialArrowPaint);

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class OuterTickerPaint extends CustomPainter {
//   final LONG_TICK = 50.0;
//   final SHORT_TICK = 4.0;
//   List<int> outerCircle = [1, 10, 3, 2, 3, 4, 15, 25, 3, 32, 5, 6, 6, 7, 4];
//   final tickCount;
//   final ticksPerSection;
//   final ticksInset;
//   final tickPaint;
//   final textPainter;
//   final textStyle;
//   final imagePainter;
//   OuterTickerPaint({
//     this.tickCount = 35,
//     this.ticksPerSection = 0.0,
//     this.ticksInset = 0.0,
//   })  : tickPaint = new Paint(),
//         imagePainter = new Image.asset(
//           'assets\indian_child.png',
//         ),
//         textPainter = new TextPainter(
//           textScaleFactor: 1.0,
//           textAlign: TextAlign.center,
//           textDirection: TextDirection.ltr,
//         ),
//         textStyle = const TextStyle(
//           color: Colors.black,
//           fontFamily: 'BebasNeue',
//           fontSize: 20.0,
//         ) {
//     tickPaint.color = Colors.black;
//     tickPaint.strokeWidth = 1.5;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.translate(size.width / 2, size.height / 2);

//     canvas.save();
//     canvas.rotate(-ticksPerSection);
//     final radius = size.width / 2;
//     print("Outer Container:: $size");
//     for (var i = 0; i < 20; ++i) {
//       final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
//       if (i % 2 == 0) {
//         canvas.drawLine(
//           new Offset(0.0, 0.0),
//           new Offset(0.0, -radius),
//           tickPaint,
//         );
//       } else {
//         canvas.save();
//         canvas.translate(-0.0, -(size.width / 2.5));

//         textPainter.text = new TextSpan(
//           text: '$i',
//           style: textStyle,
//         );
//         // imagePainter.image = new Image.asset(
//         //   imagePainter,
//         //   fit: BoxFit.cover,
//         //   scale: .2,
//         //   height: 10.0,
//         //   width: 10.0,
//         // );

//         textPainter.layout();

//         canvas.rotate(-2 * pi / 2);
//         textPainter.paint(
//           canvas,
//           new Offset(
//             0.0,
//             textPainter.height / 2,
//           ),
//         );

//         canvas.restore();
//       }
//       canvas.rotate(2 * pi / 20);
//     }

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class InnerTickePaint extends CustomPainter {
//   final LONG_TICK = 50.0;
//   final SHORT_TICK = 4.0;

//   final tickCount;
//   final ticksPerSection1;
//   final ticksInset;
//   final tickPaint;
//   final textPainter;
//   final textStyle;

//   InnerTickePaint({
//     this.tickCount = 35,
//     this.ticksPerSection1 = 0.0,
//     this.ticksInset = 0.0,
//   })  : tickPaint = new Paint(),
//         textPainter = new TextPainter(
//           textAlign: TextAlign.center,
//           textDirection: TextDirection.ltr,
//         ),
//         textStyle = const TextStyle(
//           color: Colors.black,
//           fontFamily: 'BebasNeue',
//           fontSize: 20.0,
//         ) {
//     tickPaint.color = Colors.black;
//     tickPaint.strokeWidth = 1.5;
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.translate(size.width / 2, size.height / 2);

//     canvas.save();
//     canvas.rotate(-ticksPerSection1);
//     final radius = size.width / 2;
//     print("Outer Container:: $size");
//     for (var i = 0; i < 20; ++i) {
//       //final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
//       if (i % 2 == 0) {
//         canvas.drawLine(
//           new Offset(0.0, 0.0),
//           new Offset(0.0, -size.height / 2),
//           tickPaint,
//         );
//       } else {
//         canvas.save();
//         canvas.translate(-0.0, -(size.height/ 3.5));

//         textPainter.text = new TextSpan(
//           text: '$i',
//           style: textStyle,
//         );
//         textPainter.layout();

//         canvas.rotate(-2 * pi / 2);
//         textPainter.paint(
//           canvas,
//           new Offset(
//             0.0,
//             textPainter.height / 2,
//           ),
//         );

//         canvas.restore();
//       }
//       canvas.rotate(2 * pi / 20);
//     }

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
