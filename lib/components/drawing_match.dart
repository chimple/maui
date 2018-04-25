import 'dart:ui';
import 'package:flutter/material.dart';
import 'draw_convert.dart';
import 'dart:convert';

class DrawPadController {
  _DrawPadDelegate _delegate;

  void clear() => _delegate?.clear();
  send() => _delegate?.send();
  undo() => _delegate?.undo();
}
abstract class _DrawPadDelegate {
  void clear();
  send();
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
    return new LayoutBuilder(builder: (context, constraints) {
      print({"this is constraints of drawing component": constraints});
      MediaQueryData media = MediaQuery.of(context);
      print({"this is mediaaa2:": media.size});

      _currentPainter =
      new DrawPainting(_drawLineProperty, media.size); //, color, width);
      return new Container(
        height: constraints.maxHeight, width: constraints.maxWidth,
          margin: new EdgeInsets.all(5.0),
          child: new Card(
            child: new ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: new GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      RenderBox referenceBox = context.findRenderObject();
                      Offset localPosition = referenceBox.globalToLocal(
                          details.globalPosition);

                      Position convertedIntoPercentage = new Position(
                          localPosition.dx / media.size.width, localPosition.dy / media.size.height);
                      print({"convert into percentage is : ": convertedIntoPercentage});

                      double tolerence = 0.04;

                      if(_drawLineProperty.length < 1){
                        _drawLineProperty = new List.from(_drawLineProperty)
                          ..add(new DrawLineProperty(
                              convertedIntoPercentage, color, width));
                      }else{
                        if(_drawLineProperty.last._position != null){
                          if(_drawLineProperty.last._position.x+tolerence >  convertedIntoPercentage.x && convertedIntoPercentage.x >  _drawLineProperty.last._position.x-tolerence
                              && _drawLineProperty.last._position.y+tolerence >  convertedIntoPercentage.y && convertedIntoPercentage.y >  _drawLineProperty.last._position.y-tolerence){
                            _drawLineProperty = new List.from(_drawLineProperty)
                              ..add(new DrawLineProperty(
                                  convertedIntoPercentage, color, width));
                            print({"the value is added ...." : "point is tolerable"});
                          }
                        }else{
                          _drawLineProperty = new List.from(_drawLineProperty)
                            ..add(new DrawLineProperty(
                                convertedIntoPercentage, color, width));
                        }
                      }
                    });
                  },
                  onPanEnd: (DragEndDetails details) {
                    _drawLineProperty.add(
                        new DrawLineProperty(null, color, width));
                  },
                  child: new RepaintBoundary(
                    child: new CustomPaint(
                      painter: _currentPainter,
                      isComplex: true,
                      willChange: false,

                    ),
                  )
              ),
            ),
          )
      );
    }
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
          print("this is Undo");
          break;
        }
      }
    });
  }

  bool send() {
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
    var _output = decode;
    print("Rajesh Patillllllll");
    return true;
  }

  List<Position> getAllPoints(List<DrawLineProperty> drawLineProperty) {
    List<Position> points = [];
    for (int i = 0; i < drawLineProperty.length; i++) {
      points.add(drawLineProperty[i]._position);
    }
    return points;
  }

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
      }
    }


  }
  @override
  bool shouldRepaint(DrawPainting oldDelegate){
    return true;
  }

}




