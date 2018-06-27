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
    dialArrowPaint.color = Colors.green;
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
    canvas.drawShadow(path, Colors.green, 30.0, true);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  // final LONG_TICK = 50.0;
  // final SHORT_TICK = 4.0;
  final int noOfSlice;
  int maxChar;
  List<String> data = [];
  double sizePaint;

  final double rotationPercent;
  final rotation;
  final tickPaint;
  final textPainter;
  final textStyle;

  CirclePainter({
    this.maxChar,
    this.noOfSlice,
    this.data,
    this.sizePaint: 0.0,
    this.rotation = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textScaleFactor: 1.30,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ) {
    tickPaint.strokeWidth = 2.5;
  }
  double _angle, _radiun, radius, _baseLength, _fontSize, _wFactor;
  String _maxString = '';
  @override
  void paint(Canvas canvas, Size size) {
    _maxString = data[0];
    for (int i = 1; i < data.length; i++) {
      if (_maxString.length < data[i].length) {
        _maxString = data[i];
      }
    }
    int _wLength = 'w'.allMatches(_maxString.toLowerCase()).length;
    print("max len string:: ${_wLength}");
    if (_wLength > 0) {
      _wFactor = 2.5 / _wLength.toDouble();
    } else {
      _wFactor = 1.0;
    }
    radius = size.width / 2;
    _angle = 360 / (noOfSlice * 2.0);
    _radiun = (_angle * pi) / 180;
    _baseLength = 2 * radius * sin(_radiun);
    print("_angle :: $_angle");
    print("radius :: ${2*radius*sin(_radiun)}");
    _fontSize = _wFactor * (_baseLength * 1.24) / (maxChar);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(-rotation);

    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.lineTo(-2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.close();
    int incr = 0;
    for (var i = 0; i < noOfSlice * 2; ++i) {
      if (i % 2 == 0) {
        canvas.drawLine(
            new Offset(0.0, 0.0), new Offset(0.0, radius - 4.2), tickPaint);
      } else {
        canvas.save();
        canvas.translate(-0.0, -((size.width) / 3));
        String _text = data[incr];
        textPainter.text = new TextSpan(
          text: _text,
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black,
            fontFamily: 'BebasNeue',
            fontSize: _fontSize,
          ),
        );
        incr++;

        textPainter.layout();

        canvas.rotate(-pi * 2);
        textPainter.paint(
          canvas,
          new Offset(
            -((5.2 * _text.length) * _baseLength) / 117.0,
            -(size.height / 7.200),
          ),
        );
        canvas.restore();
      }
      canvas.rotate(2 * pi / (noOfSlice.toDouble() * 2));
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
      this.noOfSlice,
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
  final int noOfSlice;
  final path;
  final tickPaint;
  double rotation = 0.0;
  final RenderBox renderBox;
  final RenderBox parentRender;
  final BoxFit boxfit;

  ui.Image img;
  ui.Rect rect, inputSubrect, outputSubrect;
  Size imageSize;
  FittedSizes sizes;
  double radius, baseLength;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    radius = size.width / 2;
    baseLength = radius * sin((360 / noOfSlice * 2) * pi / 180);
    print("size of the image canvas : $size");
    // print("size of canvas imageCanvas:: ${size.width},${size.height}");
    int c = 0;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-rotation);

    for (var i = 0; i < noOfSlice * 2; ++i) {
      if (i % 2 == 0) {
        canvas.drawLine(
          new Offset(0.0, 0.0),
          new Offset(0.0, size.width / 2 - 4.2),
          tickPaint,
        );
      } else {
        //canvas.rotate(pi);
        canvas.save();
        canvas.translate(-0.0, -((size.width) / 2.2));
        if (images[c] != null) {
          rect =
              ui.Offset(size.width / 15, size.width / 8) & new Size(0.0, 0.0);
          //rect = ui.Offset.zero & new Size(size.height, size.height);
          imageSize = new Size(size.width, size.width);
          sizes = applyBoxFit(boxfit, imageSize,
              new Size(size.width / 2 * .45, size.width / 2 * .45));
          inputSubrect =
              Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
          outputSubrect = Alignment.center.inscribe(sizes.destination, rect);

          canvas.drawImageRect(
              images[c], inputSubrect, outputSubrect, new Paint());
        }
        //canvas.rotate(2 * pi/2);
        canvas.restore();
        c++;
      }
      canvas.rotate(2 * pi / (noOfSlice * 2.0));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) {
    return true;
  }
}
