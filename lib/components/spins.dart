import 'dart:math';
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
    this.wmCount,
    @required this.dataSize,
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
  final int dataSize;
  final int maxChar, wmCount;
  List<String> data = [];

  final rotation, tickPaint;
  final textPainter;
  final String maxString;
  double _angle,
      _radiun,
      radius,
      _baseLength,
      _fontSize,
      _wmFactor,
      _lengthOfString,
      _const = 0.0,
      _constX = .1;
  @override
  void paint(Canvas canvas, Size size) {
    print('all data:: $data');
    double _uperCaseConstant = 0.0;
    if (maxString.toUpperCase() == maxString) {
      if (dataSize == 4) {
        _constX = .39;
        _uperCaseConstant = 60.0;
      } else if (dataSize == 6) {
      } else if (dataSize == 8) {}
    } else {}
    if (dataSize == 2) {
      _const = -23.0;
    } else if (dataSize == 4) {
      _const = -16.0;
      _uperCaseConstant = 30.0;
    } else if (dataSize == 6) {
      _const = -8.0;
    } else if (dataSize == 8) {
      _const = -10.0;
    }
    radius = size.width / 2;
    _angle = 360 / (dataSize * 2.0);
    _radiun = (_angle * pi) / 180;
    _baseLength = 2 * radius * sin(_radiun);
    _fontSize = ((_baseLength * .8) / maxChar) - wmCount * 1.2;
    _lengthOfString = (_fontSize * dataSize) - wmCount * 1.2;
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
      for (var i = 0; i < dataSize * 2; ++i) {
        if (i % 2 == 0) {
          canvas.drawLine(
              new Offset(0.0, 0.0), new Offset(0.0, radius - 4.2), tickPaint);
        } else {
          double _offset = size.width / 14 +
              4 * data[incr].length +
              _uperCaseConstant +
              wmCount * 4.2;
          if (maxChar == 1) {
            _offset = size.height / 12;
          }
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
              fontSize: maxChar > 1 ? _fontSize : _baseLength * .2,
            ),
          );

          textPainter.layout();
          canvas.rotate(-pi * 2);
          textPainter.paint(
            canvas,
            new Offset(
              -(_offset),
              -(size.height / 7.500 + _const),
            ),
          );

          incr++;
          canvas.restore();
        }
        canvas.rotate(2 * pi / (dataSize.toDouble() * 2));
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
      @required this.dataSize,
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
  final int dataSize;
  final tickPaint;
  final BoxFit boxfit;
  ui.Rect rect, inputSubrect, outputSubrect;
  Size _imageSize;
  FittedSizes __fittedSize;
  double radius,
      rotation = 0.0,
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
    _angle = 360 / (dataSize * 2.0);
    _radiun = (_angle * pi) / 180;
    _baseLength = 2 * radius * sin(_radiun);
    _incircleRadius = (_baseLength / 2) * tan(_radiun);
    if (dataSize == 4) {
      _imageOffset = 30.0;
      _imageSizeConst = 30.0;
      _x = 8.60;
      _y = 4.10;
    } else if (dataSize == 6) {
      _imageOffset = 20.0;
      _x = 10.60;
      _y = 5.60;
    } else if (dataSize == 8) {
      _imageOffset = 40.0;
      _imageSizeConst = 30.0;
      _x = 12.90;
      _y = 6.60;
    }
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-rotation);
    int incr = 0;
    rect = ui.Offset((size.width / _x), size.width / _y) & new Size(0.0, 0.0);

    _imageSize = new Size(size.width * 1.5, size.width * 1.5);
    __fittedSize = applyBoxFit(
        boxfit,
        _imageSize,
        new Size(size.width / 2 * .50 + _incircleRadius * .8,
            size.width / 2 * .50 + _incircleRadius * .8));
    inputSubrect = Alignment.center
        .inscribe(__fittedSize.source, Offset.zero & _imageSize);
    outputSubrect = Alignment.center.inscribe(__fittedSize.destination, rect);
    if (images.length == dataSize && images.isNotEmpty)
      for (var i = 1; i <= dataSize * 2; ++i) {
        if (i % 2 != 0) {
          canvas.drawLine(
            new Offset(0.0, 0.0),
            new Offset(0.0, size.width / 2 - 4.2),
            tickPaint,
          );
        } else {
          canvas.save();
          canvas.translate(-0.0, -((size.width) / 2.2));
          ui.Image _image = images[incr];
          if (_image != null) {
            canvas.drawImageRect(
                _image, inputSubrect, outputSubrect, new Paint());
          }

          canvas.restore();
          incr++;
        }
        canvas.rotate(2 * pi / (dataSize * 2.0));
      }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
