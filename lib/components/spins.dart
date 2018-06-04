import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final double rotationPercent;

  ArrowPainter({this.rotationPercent}) : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final radius = size.height / 2;
    canvas.translate(size.width / 2, 0.0);
    canvas.rotate(0.0);

    Path path = new Path();
    path.moveTo(0.0, -170.0);
    path.lineTo(10.0, -30.0);
    path.lineTo(-10.0, -30.0);
    path.close();

    canvas.drawPath(path, dialArrowPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class OuterCircle extends CustomPainter {
  final LONG_TICK = 50.0;
  final SHORT_TICK = 4.0;
  final Paint traingle;
  final double rotationPercent;
  List<int> outerCircle = [1, 10, 3, 2, 3, 4, 15, 25, 3, 32, 5, 6, 6, 7, 4];
  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final tickPaint;
  final textPainter;
  final textStyle;
  final image;
  final buttonStyle;
  OuterCircle({
    this.tickCount = 35,
    this.ticksPerSection = 0.0,
    this.ticksInset = 0.0,
  })  : tickPaint = new Paint(),
        traingle = new Paint(),
        image = new Image.asset(
          'assets\indian_child.png',
        ),
        textPainter = new TextPainter(
          textScaleFactor: 1.0,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ),
        buttonStyle= new Container(
          width: 30.0,
          height: 30.0,
        )
         {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 0.5;
    traingle.color = Colors.red[100];
    traingle.style = PaintingStyle.fill;
    // image.hieght=30.0;
    // image.width=40.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();
    canvas.rotate(-ticksPerSection);
    final radius = size.height / 2;
    print("Outer Container:: $size");
    for (var i = 0; i < 16; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      if (i % 2 == 0) {
        canvas.drawLine(
          new Offset(0.0, 00.0),
          new Offset(0.0, -radius + 40.0),
          tickPaint,
        );
      } else {
        canvas.save();
        canvas.translate(-0.0, -(size.width/3.5 ));

        textPainter.text = new TextSpan(
          text: '$i',
          style: textStyle,
        );
       
        // imagePainter.image = new Image.asset(
        //   imagePainter,
        //   fit: BoxFit.cover,
        //   scale: .2,
        //   height: 10.0,
        //   width: 10.0,
        // );

        textPainter.layout();

        canvas.rotate(2 * pi / 2);
        textPainter.paint(
          canvas,
          new Offset(
            0.0,
            textPainter.height / 2,
          ),
        );

        canvas.restore();
      }
      canvas.rotate(2 * pi / 16);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class InnerCircle extends CustomPainter {
  final LONG_TICK = 50.0;
  final SHORT_TICK = 4.0;

  final tickCount;
  final ticksPerSection1;
  final ticksInset;
  final tickPaint;
  final textPainter;
  final textStyle;

  InnerCircle({
    this.tickCount = 35,
    this.ticksPerSection1 = 0.0,
    this.ticksInset = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
          
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 0.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();
    canvas.rotate(-ticksPerSection1);
    final radius = size.width / 2;
    print("Outer Container:: $size");
    for (var i = 0; i < 16; ++i) {
      //final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      if (i % 2 == 0) {
        canvas.drawLine(
          new Offset(0.0, 0.0),
          new Offset(0.0, -size.height / 3),
          tickPaint,
        );
      } else {
        canvas.save();
        canvas.translate(-0.0, -(size.height / 5.9));

        textPainter.text = new TextSpan(
          text: '$i',
          style: textStyle,
        );
        textPainter.layout();

        canvas.rotate(-2 * pi / 2);
        textPainter.paint(
          canvas,
          new Offset(
            0.0,
            textPainter.height / 2,
          ),
        );

        canvas.restore();
      }
      canvas.rotate(2 * pi / 16);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
