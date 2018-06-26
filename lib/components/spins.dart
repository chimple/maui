import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:ui' as ui show Image;

class ArrowPainter extends CustomPainter {
  final Paint dialArrowPaint;
  final double rotationPercent;
  Size sizeArrow;
  ArrowPainter({
    this.rotationPercent,
    this.sizeArrow,
  }) : dialArrowPaint = new Paint() {
    dialArrowPaint.color = Colors.pink;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final radius = size.width;
    canvas.translate(radius, radius);
    Path path = new Path();
    path.moveTo(0.0, -sizeArrow.width * .31);
    path.lineTo(sizeArrow.width * .35 * .17, -0.0);
    path.lineTo(-sizeArrow.width * .35 * .17, -0.0);

    path.close();
    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.blue, 30.0, true);
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
  List<String> data;
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
  final buttonStyle;
  OuterCircle({
    this.data,
    this.sizePaint: 0.0,
    this.tickCount = 35,
    this.ticksPerSection = 0.0,
    this.ticksInset = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          maxLines: 10,
          textScaleFactor: 1.30,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ) {
    tickPaint.strokeWidth = 2.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(-ticksPerSection);
    final radius = size.width / 2;
    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.lineTo(-2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.close();
    int c = 0;
    for (var i = 0; i < 16; ++i) {
      if (i % 2 == 0) {
        canvas.drawLine(
          new Offset(0.0, 0.0),
          new Offset(0.0, radius - 4.2),
          tickPaint,
        );
      } else {
        canvas.save();
        canvas.translate(-0.0, -((size.width) / 3));
        String s = data[c];
        textPainter.text = new TextSpan(
          text: s,
          style: textStyle,
        );
        c++;

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

class ImagePainter extends CustomPainter {
  List<ui.Image> images = new List<ui.Image>();
  ImagePainter(
      {Key key,
      this.renderBox,
      this.parentRender,
      @required this.images,
      @required this.rotation,
      this.boxfit = BoxFit.contain})
      : path = new Path()
          ..addOval(new Rect.fromCircle(
            center: new Offset(75.0, 75.0),
            radius: 40.0,
          )),
        tickPaint = new Paint() {
    tickPaint.strokeWidth = 2.5;
  }
  final path;
  final tickPaint;
  double rotation = 0.0;
  final RenderBox renderBox;
  final RenderBox parentRender;
  final BoxFit boxfit;

  ui.Image img;
  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    int c = 0;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-rotation);

    for (var i = 0; i < 16; ++i) {
      if (i % 2 == 0) {
        canvas.drawLine(
          new Offset(0.0, 0.0),
          new Offset(0.0, size.width / 2 - 4.2),
          tickPaint,
        );
        //canvas.rotate(2 * pi / 2);
      } else {
        canvas.save();
        canvas.translate(-10.0, -((size.width) / 2.3));
        //canvas.clipPath(path);
        if (images[c] != null) {
          ui.Image img = images[c];
          final ui.Rect rect = ui.Offset.zero & new Size(200.0, 120.0);
          ;
          final Size imageSize = new Size(330.0, 230.0);
          FittedSizes sizes =
              applyBoxFit(boxfit, imageSize, new Size(100.0, 200.0));
          final Rect inputSubrect =
              Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
          final Rect outputSubrect =
              Alignment.center.inscribe(sizes.destination, rect);

          canvas.drawImageRect(img, inputSubrect, outputSubrect, new Paint());
        }
        canvas.rotate(2 * pi / 2);
        canvas.restore();
        c++;
      }
      canvas.rotate(2 * pi / 16);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }

  ui.Image getGrad(Size size) {
    var pictureRecorder = new ui.PictureRecorder();

    return pictureRecorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }
}
