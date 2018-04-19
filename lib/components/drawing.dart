import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:json_annotation/json_annotation.dart';
import 'draw_convert.dart';
import 'dart:convert';

class DrawPadController {
  _DrawPadDelegate _delegate;

  void clear() => _delegate?.clear();

  send() => _delegate?.send();

  multiColor(colorValue) => _delegate?.multiColor(colorValue);

  multiWidth(widthValue) => _delegate?.multiWidth(widthValue);

  undo() => _delegate?.undo();
}

abstract class _DrawPadDelegate {
  void clear();

  send();

  multiColor(colorValue);

  multiWidth(widthValue);

  undo();
}

class MyDrawPage extends StatefulWidget {
  DrawPadController controller;

  MyDrawPage(this.controller, {Key key}) : super(key: key);

  State<StatefulWidget> createState() {
    return new MyHomePageState(this.controller);
  }
}

class DrawLineProperty {
  Position _position = null;
  var _color = new Color(0xff000000);
  var _width = 5.0;

  DrawLineProperty(Position position, color, width) {
    this._position = position;
    this._color = color;
    this._width = width;
  }
}

class MyHomePageState extends State<MyDrawPage> implements _DrawPadDelegate {

  List<DrawLineProperty> _drawLineProperty = [];

//  List<Offset> _points = [];
  var color = new Color(0xff000000);
  var width = 8.0;
  DrawPadController _controller;

  MyHomePageState(controller) {
    this._controller = controller;
  }

  DrawPainting _currentPainter;

  void initState() {
    _controller._delegate = this;
  }


  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);


  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print({"this is mediaaa2:": media.size});

    _currentPainter =
    new DrawPainting(_drawLineProperty, media.size); //, color, width);
    return new Container(
      margin: new EdgeInsets.all(5.0),
      decoration: new BoxDecoration(
        color: const Color(0xFFF1F8E9),
        boxShadow: [new BoxShadow(
          color: Colors.green,
          blurRadius: 5.0,
        ),
        ],
        border: new Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: new ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: new GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox referenceBox = context.findRenderObject();
              Offset localPosition = referenceBox.globalToLocal(
                  details.globalPosition);

              var x = localPosition.dx / media.size.width;
              print({"x value in percentage is : ": x});
              Position convertedIntoPercentage = new Position(
                  x, localPosition.dy / media.size.height);
              print({"convert into percentage is : ": convertedIntoPercentage});
              _drawLineProperty = new List.from(_drawLineProperty)
                ..add(new DrawLineProperty(
                    convertedIntoPercentage, color, width));
            });
          },
          onPanEnd: (DragEndDetails details) {
            _drawLineProperty.add(
                new DrawLineProperty(null, color, width));
          },
          child: new CustomPaint(
            painter: _currentPainter,

          ),
        ),
      ),
    );
  }

  void clear() {
    setState(() {
      _drawLineProperty.clear();
      print({"this is clear methode": _drawLineProperty});
    });
  }

  void undo() {
    setState(() {
      for (int i = _drawLineProperty.length - 2; i >= 0; i--) {
        if (_drawLineProperty[i]._position != null) {
          _drawLineProperty.removeAt(i);
        } else {
          _drawLineProperty.removeLast();
          var point = getAllPoints(_drawLineProperty);
          print("this is Undo methode");
          break;
        }
      }
    });
  }

  void send() {
    List<DrawLineProperty> drawLinePropertyArray = _drawLineProperty;
    print({"the data is : " : drawLinePropertyArray});

    var colorRef = drawLinePropertyArray[0]._color.value;
    var widthRef = drawLinePropertyArray[0]._width;
    List<Draw> drawList = [];
    List<Position> position = [];
    var drawTracker = 1;

    for (var i = 0; i < drawLinePropertyArray.length; i++) {

      DrawLineProperty current = drawLinePropertyArray[i];
      if (current._color.value == colorRef && current._width == widthRef) {

        if (current._position != null)
          position.add(new Position(current._position.x, current._position.y));
        else
          position.add(new Position(null, null));

      } else if (current._color.value != colorRef || current._width != widthRef) {
        drawList.add(new Draw(colorRef, widthRef, position:position));
        drawTracker++;

        colorRef = current._color.value;
        widthRef = current._width;
        position = [];

        if (current._position != null)
          position.add(new Position(current._position.x, current._position.y));
        else
          position.add(new Position(null, null));
      }
    }

    if (drawTracker != drawList.length && drawLinePropertyArray.length > 0) {
      drawList.add(new Draw(colorRef, widthRef, position:position));
    }

    CanvasProperty canvasProperty = new CanvasProperty(drawList);

    final drawJson = _encode(canvasProperty);
    print({"the drawJson is : ": drawJson.toString()});

    var decode = json.decode(drawJson);
    print({"the object is : ": decode});



  }

  List<Position> getAllPoints(List<DrawLineProperty> drawLineProperty) {
    List<Position> points = [];
    for (int i = 0; i < drawLineProperty.length; i++) {
      points.add(drawLineProperty[i]._position);
    }
    return points;
  }

  void multiColor(colorValue) {
    // print({"I am getting final color here  " : colorValue});
    setState(() {
      color = new Color(colorValue);
//      width = 20.0;
    });
  }

  void multiWidth(widthValue) {
    //  print({"I am getting final width here  " : widthValue});
    setState(() {
      width = widthValue;
    });
  }

//  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

}

class DrawPainting extends CustomPainter {
  List<DrawLineProperty> drawLineProperty = [];
  Size sizeMedia = new Size(0.0, 0.0);

  DrawPainting(drawLineProperty, sizeMedia) {
    this.drawLineProperty = drawLineProperty;
    this.sizeMedia = sizeMedia;
  }


  void getAllPoints(List<DrawLineProperty> drawLineProperty) {
    List<Position> points = [];
    for (int i = 0; i < drawLineProperty.length; i++) {
      points.add(drawLineProperty[i]._position);
      print({points[i].x: points[i].y});
    }
  }

  void paint(Canvas canvas, Size size) {
//    print("this is paint ,methodeeee");
//    print({"the drawLine points are : " : getAllPoints(drawLineProperty)});


    Paint paint = new Paint()
      ..strokeCap = StrokeCap.round;
    print({"sizeMedia of paint is in draw is ": sizeMedia});
    print({"size of paint is in draw is ": size});
    for (int i = 0; i < drawLineProperty.length - 1; i++) {

      if (drawLineProperty[i]._position != null &&
          drawLineProperty[i + 1]._position != null &&
          drawLineProperty[i]._position.x * sizeMedia.width >= 0 &&
          drawLineProperty[i]._position.y * sizeMedia.height >= 0 &&
          (drawLineProperty[i]._position.x * sizeMedia.width >= 0 &&
              drawLineProperty[i]._position.y * sizeMedia.height >= 0 &&
              drawLineProperty[i]._position.x * sizeMedia.width < size.width &&
              drawLineProperty[i]._position.y * sizeMedia.height <
                  size.height) &&
          (drawLineProperty[i + 1]._position.x * sizeMedia.width >= 0 &&
              drawLineProperty[i + 1]._position.y * sizeMedia.height >= 0 &&
              drawLineProperty[i + 1]._position.x * sizeMedia.width <
                  size.width &&
              drawLineProperty[i + 1]._position.y * sizeMedia.height <
                  size.height)) {
        paint.color = drawLineProperty[i]._color;
        paint.strokeWidth = drawLineProperty[i]._width;

        var currentPixel = new Offset(
            drawLineProperty[i]._position.x * sizeMedia.width,
            drawLineProperty[i]._position.y * sizeMedia.height);
        var nextPixel = new Offset(
            drawLineProperty[i + 1]._position.x * sizeMedia.width,
            drawLineProperty[i + 1]._position.y * sizeMedia.height);

        canvas.drawLine(currentPixel, nextPixel, paint);
//        canvas.drawCircle(currentPixel, 8.0, paint);
        canvas.drawCircle(nextPixel, 8.0, paint);
      }
    }

//    List<Offset> position= [];
//    for(var element in drawLineProperty)
//      position.add(element._position);
//
//    paint.strokeWidth = 5.0;
//    canvas.drawPoints(PointMode.points,position , paint);

  }

  bool shouldRepaint(DrawPainting oldDelegate) {
    return true;
  }
}




