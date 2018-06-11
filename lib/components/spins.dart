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
    print("safsaaaaaaaaaaaaaaa $radius");
    Rect myRect = const Offset(0.0, 0.0) & const Size(100.0, 110.0);

    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(2 * pi * 100 / 16, 90.0);
    path.lineTo(-2 * pi * 100 / 16, 90.0);
    //path.arcTo(myRect, 0.0, 30.0, true);
    path.close();
    canvas.drawPath(path, dialArrowPaint);
  
    for (var i = 0; i < 16; ++i) {
      if (i % 2 == 0) {
        // canvas.drawLine(
        //   new Offset(0.0, 0.0),
        //   new Offset(0.0,radius-sizePaint+70),
        //   tickPaint,
        // );
        path.close();
        canvas.drawPath(path, dialArrowPaint);
      } else {
        canvas.save();
        canvas.translate(-0.0, -((size.width) / 3));

        // imagePainter.image = new Image.asset(
        //   imagePainter,
        //   fit: BoxFit.cover,
        //   scale: .2,
        //   height: 10.0,
        //   width: 10.0,
        // );

        canvas.rotate(2 * pi / 2);

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

class OuterCircle extends CustomPainter {
  final LONG_TICK = 50.0;
  final SHORT_TICK = 4.0;
  double sizePaint;
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
    this.sizePaint: 0.0,
    this.tickCount = 35,
    this.ticksPerSection = 0.0,
    this.ticksInset = 0.0,
  })  : tickPaint = new Paint(),
        traingle = new Paint(),
        image = new Image.asset(
          'assets\indian_child.png',
        ),
        textPainter = new TextPainter(
          maxLines: 10,
          //ellipsis:'sa',
          textScaleFactor: 1.30,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ),
        buttonStyle = new Container(
          width: 30.0,
          height: 30.0,
        ) {
    tickPaint.color = Colors.red;

    tickPaint.strokeWidth = 0.5;
    traingle.color = Colors.red[100];
    traingle.style = PaintingStyle.fill;

    // image.hieght=30.0;
    // image.width=40.0;
  }
  // List<Color> _color = [
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue
  // ];
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(-ticksPerSection);
    final radius = size.height / 2;
    //const var radiud=size.height / 2;
    Rect myRect = const Offset(0.0, 0.0) & Size(size.width / 2, size.width / 2);
    print("Outer Container:: $size");
    print("Outer Container width:: ${size.width}");
    print("Outer Container hieght:: ${size.height}");
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.lineTo(-2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    //path.addArc(myRect, 0.0, 2*pi*16);

    path.close();
   // canvas.drawPath(path, tickPaint);
    for (var i = 0; i < 16; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      if (i % 2 == 0) {
        // canvas.drawLine(
        //   new Offset(0.0, 0.0),
        //   new Offset(0.0,radius-sizePaint+70),
        //   tickPaint,
        // );

        // path.close();
        canvas.drawCircle(new Offset(0.0, 0.0), 2*pi/16/i, tickPaint);
        //canvas.drawPath(path, tickPaint);
      } else {
        canvas.save();
        canvas.translate(-0.0, -((size.width) / 3));

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
            (textPainter.height) / 2,
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
  double sizePaint;
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
          textDirection: TextDirection.rtl,
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
    print("Inner Container:: $size");
    for (var i = 0; i < 16; ++i) {
      //final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;
      if (i % 2 == 0) {
        // canvas.drawLine(
        //   new Offset(0.0, 0.0),
        //   new Offset(0.0, radius),
        //   tickPaint,
        // );
      } else {
        canvas.save();
        canvas.translate(-0.0, -(size.width / 4));

        textPainter.text = new TextSpan(
          text: '$i',
          style: textStyle,
        );
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
