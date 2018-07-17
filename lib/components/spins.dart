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

class TextPainters extends CustomPainter {
  TextPainters({
    this.maxString,
    this.maxChar,
    @required this.noOfSlice,
    @required this.data,
    this.rotation = 0.0,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textScaleFactor: 1.30,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ) {
    tickPaint.strokeWidth = 2.5;
  }
  final int noOfSlice;
  final int maxChar;
  List<String> data = [];

  final rotation, tickPaint, textStyle;
  final textPainter;
  final String maxString;
  double _angle, _radiun, radius, _baseLength, _fontSize, _wFactor;
  @override
  void paint(Canvas canvas, Size size) {
    double _uperCaseConstant = 0.0;
    if (maxString.toUpperCase() == maxString.toUpperCase()) {
      _uperCaseConstant = 8.0;
    }
    double _const = 0.0;
    if (noOfSlice == 2) {
      _const = -25.0;
    } else if (noOfSlice == 4) {
      _const = -16.0;
    } else if (noOfSlice == 6) {
      _const = -8.0;
    } else if (noOfSlice == 8) {
      _const=-10.0;
    }
    int _wLength = 'w'.allMatches(maxString.toLowerCase()).length;
    _wLength = 'm'.allMatches(maxString.toLowerCase()).length;
    // print("max len string w:: ${data}");
    if (_wLength > 0) {
      _wFactor = 2.5 / _wLength.toDouble();
    } else {
      _wFactor = 1.5;
    }
    radius = size.width / 2;
    _angle = 360 / (noOfSlice * 2.0);
    _radiun = (_angle * pi) / 180;
    _baseLength = 2 * radius * sin(_radiun);
    // print("_angle :: $_angle");
    // print("radius :: ${2*radius*sin(_radiun)}");
    _fontSize =  (_baseLength * .24) / (maxChar*_wFactor*.2);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    canvas.rotate(-rotation);

    Path path = new Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.lineTo(-2 * pi * size.width / 2 / 16, size.width / 2 - 20);
    path.close();
    int incr = 0;
    if (data.isNotEmpty)
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
              fontSize: maxChar > 1 ? _fontSize : _baseLength*.2,
            ),
          );
          incr++;

          textPainter.layout();

          canvas.rotate(-pi * 2);
          textPainter.paint(
            canvas,
            new Offset(
              -((3.50 * _text.length) * _baseLength) / (117.50)+_wLength*2,
              -(size.height / 7.800 + _const),
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
      @required this.noOfSlice,
      @required this.images,
      @required this.rotation,
      this.boxfit = BoxFit.contain})
      :
        // : path = new Path()
        //     ..addOval(new Rect.fromCircle(
        //       center: new Offset(75.0, 75.0),
        //       radius: 40.0,
        //     )),
        tickPaint = new Paint() {
    tickPaint.strokeWidth = 2.5;
  }
  final int noOfSlice;
  //final path;
  final tickPaint;
  double rotation = 0.0;

  final BoxFit boxfit;

  ui.ImageByteFormat img;
  ui.Rect rect, inputSubrect, outputSubrect;
  Size imageSize;
  FittedSizes sizes;
  double radius,
      _x,
      _y,
      _angle,
      _radiun,
      _baseLength,
      _imageCircleradius,
      _incircleRadius,
      _imageOffset = 0.0,
      _imageSizeConst = 0.0;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    print("image data:: $images");
    radius = size.width / 2;
    _angle = 360 / (noOfSlice * 2.0);
    _radiun = (_angle * pi) / 180;
    _baseLength = 2 * radius * sin(_radiun);
    _incircleRadius = (_baseLength / 2) * tan(_radiun);
    if (noOfSlice == 4) {
      _imageOffset = 30.0;
      _imageSizeConst = 30.0;
      _x = 4.00;
      _y = 2.90;
    } else if (noOfSlice == 6) {
      _imageOffset = 20.0;
      _x = 8.0;
      _y = 4.0;
    } else if (noOfSlice == 8) {
      _imageOffset = 40.0;
      _imageSizeConst = 30.0;
      _x = 10.0;
      _y = 5.0;
    }

    //print("circle radisu:: $_incircleRadius");

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-rotation);
    //print("canvas size:: ${size.width}");
    //print("size of canvas ::${size.width * 2}");
    int incr = 0;
    rect = ui.Offset((size.width / _x), size.width / _y) & new Size(0.0, 0.0);

    imageSize = new Size(size.width*1.5 , size.width *1.5);
    sizes = applyBoxFit(boxfit, imageSize,
        new Size(size.width / 2 * .50+_incircleRadius*1.1, size.width / 2 * .50+_incircleRadius*1.1));
    inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    outputSubrect = Alignment.center.inscribe(sizes.destination, rect);
    if (images.length == noOfSlice)
      for (var i = 1; i <= noOfSlice * 2; ++i) {
        if (i % 2 != 0) {
          canvas.drawLine(
            new Offset(0.0, 0.0),
            new Offset(0.0, size.width / 2 - 4.2),
            tickPaint,
          );
        } else {
          canvas.save();
          canvas.translate(-0.0, -((size.width) / 2.2));
          ui.Image image = images[incr];
          if (image != null) {
            canvas.drawImageRect(
                image, inputSubrect, outputSubrect, new Paint());
          }

          canvas.restore();
          incr++;
        }
        canvas.rotate(2 * pi / (noOfSlice * 2.0));
      }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
