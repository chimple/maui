import 'dart:ui';
import 'package:flutter/material.dart';
import 'draw_convert.dart';
import 'dart:convert';

class DrawPadController {
  _DrawPadDelegate _delegate;

  void clear() => _delegate?.clear();
  String send() => _delegate?.send();
  multiColor(colorValue) => _delegate?.multiColor(colorValue);
  multiWidth(widthValue) => _delegate?.multiWidth(widthValue);
  undo() => _delegate?.undo();
}

abstract class _DrawPadDelegate {
  void clear();
  String send();
  multiColor(colorValue);
  multiWidth(widthValue);
  undo();
}

class MyDrawPage extends StatefulWidget {
  DrawPadController controller;
  String drawJson;

  MyDrawPage(this.drawJson, this.controller);

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
  var width = 4.0;
  DrawPadController _controller;
  MyHomePageState(this._controller);
  DrawPainting _currentPainter;

  void initState() {
    _controller._delegate = this;
  }

  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);

  @override
  Widget build(BuildContext context) {
    print("data of choice in drawww isss ${widget.drawJson}");
    // MediaQueryData media = MediaQuery.of(context);
    // print({"this is mediaaa2:": media.size});

    return new LayoutBuilder(builder: (context, constraints) {
      var _height = constraints.maxHeight;
      var _width = constraints.maxWidth;
      _currentPainter = new DrawPainting(_drawLineProperty, _height, _width);
      // print({"this is drawing area height :": constraints.maxHeight});
      // print({"this is drawing area width :": constraints.maxWidth});

      // print({"this is constraints of drawing component": constraints});
      //, color, width);

      return new Container(
          // margin: new EdgeInsets.all(5.0),
          child: new Card(
        child: new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: new GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  RenderBox referenceBox = context.findRenderObject();
                  Offset localPosition =
                      referenceBox.globalToLocal(details.globalPosition);

                  Position convertedIntoPercentage = new Position(
                      localPosition.dx / _width, localPosition.dy / _height);
                  // print({
                  //   "convert into percentage is : ": convertedIntoPercentage
                  // });
                  double tolerence = 0.08;
                  if (_drawLineProperty.length < 1) {
                    _drawLineProperty = new List.from(_drawLineProperty)
                      ..add(new DrawLineProperty(
                          convertedIntoPercentage, color, width));
                  } else {
                    if (_drawLineProperty.last._position != null) {
                      if (_drawLineProperty.last._position.x + tolerence >
                              convertedIntoPercentage.x &&
                          convertedIntoPercentage.x >
                              _drawLineProperty.last._position.x - tolerence &&
                          _drawLineProperty.last._position.y + tolerence >
                              convertedIntoPercentage.y &&
                          convertedIntoPercentage.y >
                              _drawLineProperty.last._position.y - tolerence) {
                        _drawLineProperty = new List.from(_drawLineProperty)
                          ..add(new DrawLineProperty(
                              convertedIntoPercentage, color, width));
                        // print(
                        //     {"the value is added ....": "point is tolerable"});
                      }
                    } else {
                      _drawLineProperty = new List.from(_drawLineProperty)
                        ..add(new DrawLineProperty(
                            convertedIntoPercentage, color, width));
                    }
                  }
                });
              },
              onPanEnd: (DragEndDetails details) {
                _drawLineProperty.add(new DrawLineProperty(null, color, width));
              },
              child: new RepaintBoundary(
                child: new CustomPaint(
                  painter: _currentPainter,
                  // size: Size.infinite,
                  isComplex: true,
                  willChange: false,
                ),
              )),
        ),
      ));
    });
  }

  void clear() {
    setState(() {
      _drawLineProperty.clear();
      print({"this is clear methode": _drawLineProperty});
    });
  }

  void undo() {
    print({"the undo before state": " callinggg"});
    setState(() {
      for (int i = _drawLineProperty.length - 2; i >= 0; i--) {
        if (_drawLineProperty[i]._position != null) {
          _drawLineProperty.removeAt(i);
        } else {
          _drawLineProperty.removeLast();
          if (_drawLineProperty.length == 1) _drawLineProperty.clear();
          break;
        }
      }
    });
  }

  String send() {
    List<DrawLineProperty> drawLinePropertyArray = _drawLineProperty;

    var colorRef = drawLinePropertyArray[0]._color.value;
    var widthRef = drawLinePropertyArray[0]._width;
    List<Draw> drawList = [];
    List<Position> position = [];
    var drawTracker = 1;

    for (var i = 0; i < drawLinePropertyArray.length; i++) {
      DrawLineProperty current = drawLinePropertyArray[i];
      if (current._color.value == colorRef && current._width == widthRef) {
        if (current._position != null) {
          position.add(new Position(current._position.x, current._position.y));
        } else
          position.add(new Position(null, null));
      } else if (current._color.value != colorRef ||
          current._width != widthRef) {
        position.add(new Position(null, null));
        drawList.add(new Draw(colorRef, widthRef, position: position));
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
    var isSendActive = true;
    if (drawTracker != drawList.length && drawLinePropertyArray.length > 0) {
      isSendActive = position.length != 1 ? true : false;
      drawList.add(new Draw(colorRef, widthRef, position: position));
    }

    CanvasProperty canvasProperty = new CanvasProperty(drawList);

    final drawJsonVal = _encode(canvasProperty);
    // print({"the drawJson is : ": drawJsonVal.toString()});

//    var decode = json.decode(drawJson);
//    print({"the object is : ": decode});
//    var _output = decode;

    var getLastPosition = drawList[drawList.length - 1]
        .position[drawList[drawList.length - 1].position.length - 1]
        .x;
// return drawJsonVal;

    if (getLastPosition == null && isSendActive) {
      return drawJsonVal;
      // setState(() {
      //          widget.drawJson = drawJsonVal;
      //         //  print("data of choice isss ${widget.drawJson}");
      //       });
      // print("data of choice isss ${widget.choice}");
    }
  }

  List<Position> getAllPoints(List<DrawLineProperty> drawLineProperty) {
    List<Position> points = [];
    for (int i = 0; i < drawLineProperty.length; i++) {
      points.add(drawLineProperty[i]._position);
    }
    return points;
  }

  void multiColor(colorValue) {
    print({"I am getting final color here  ": colorValue});
    setState(() {
      color = new Color(colorValue);
    });
  }

  void multiWidth(widthValue) {
    setState(() {
      width = widthValue;
    });
  }
}

class DrawPainting extends CustomPainter {
  List<DrawLineProperty> drawLineProperty = [];
  // Size sizeMedia = new Size(0.0, 0.0);
  var _height = 0.0;
  var _width = 0.0;

  DrawPainting(drawLineProperty, _height, _width) {
    this.drawLineProperty = drawLineProperty;
    this._height = _height;
    this._width = _width;
    // this.sizeMedia = sizeMedia;
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

    Paint paint = new Paint()..strokeCap = StrokeCap.round;
    // print({"sizeMedia of paint is in draw is ": sizeMedia});
    print({"size of paint is in draw is ": size});
    for (int i = 0; i < drawLineProperty.length - 1; i++) {
      if (drawLineProperty[i]._position != null &&
          drawLineProperty[i + 1]._position != null &&
          (drawLineProperty[i]._position.x * _width >= 0 &&
              drawLineProperty[i]._position.y * _height >= 0 &&
              drawLineProperty[i]._position.x * _width < size.width &&
              drawLineProperty[i]._position.y * _height < size.height) &&
          (drawLineProperty[i + 1]._position.x * _width >= 0 &&
              drawLineProperty[i + 1]._position.y * _height >= 0 &&
              drawLineProperty[i + 1]._position.x * _width < size.width &&
              drawLineProperty[i + 1]._position.y * _height < size.height)) {
        paint.color = drawLineProperty[i]._color;
        paint.strokeWidth = drawLineProperty[i]._width;

        var currentPixel = new Offset(drawLineProperty[i]._position.x * _width,
            drawLineProperty[i]._position.y * _height);
        var nextPixel = new Offset(drawLineProperty[i + 1]._position.x * _width,
            drawLineProperty[i + 1]._position.y * _height);

        canvas.drawLine(currentPixel, nextPixel, paint);
//        canvas.drawCircle(currentPixel, 8.0, paint);
//        canvas.drawCircle(nextPixel, 8.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawPainting oldDelegate) {
    return true;
  }
}
