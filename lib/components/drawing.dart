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
  Offset _position = null;
  var _color = new Color(0xff000000);
  var _width = 5.0;

  DrawLineProperty(position, color, width) {
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
//    List<DrawLineProperty> drawLineProperty = [];
//    List drawPoint = [];
//    for (int i = 0; i < drawLineProperty.length; i++)
//      drawPoint.add(drawLineProperty[i]._position);
//    print({"the full data position is : ": drawPoint});

//    List<Position> position1 = [];
//    List<Position> position2 = [];
//    List<Position> position3 = [];
//
//    position1.add(new Position(101.0, 121.0));
//    position1.add(new Position(102.0, 122.0));
//    position1.add(new Position(103.0, 123.0));
//    position2.add(new Position(104.0, 124.0));
//    position2.add(new Position(105.0, 125.0));
//    position2.add(new Position(106.0, 126.0));
//    position3.add(new Position(107.0, 127.0));
//    position3.add(new Position(108.0, 128.0));
//    position3.add(new Position(109.0, 129.0));
//    position3.add(new Position(110.0, 130.0));
//    position1.add(new Position(111.0, 131.0));
//    position2.add(new Position(112.0, 132.0));
//
//
//    List<Draw> draw = [];
//    draw.add(new Draw(0xff000000, 8.0, position: position1));
//    draw.add(new Draw(0xff000001, 9.0, position: position2));
//    draw.add(new Draw(0xff000002, 10.0, position: position3));
//    print({"initial object is": draw});
//
//    CanvasProperty canvasProperty = new CanvasProperty(draw);
//
//    final drawJson = _encode(canvasProperty);
//    print({"the object convert into json formate : ": drawJson});
//
//    var decode = JSON.decode(drawJson);
//    print({"the decode value is : 1": decode});
//    print({"the decode value is : 1": decode['draw'][0]['width']});

    _controller._delegate = this;
  }


  String _encode(Object object) =>
      const JsonEncoder.withIndent(' ').convert(object);


  @override
  Widget build(BuildContext context) {
    _currentPainter = new DrawPainting(_drawLineProperty); //, color, width);
//    MediaQueryData media = MediaQuery.of(context);
//    print({"this is mediaaa:": media.size});
    return new Container(
      margin: new EdgeInsets.all(5.0),
//        height: media.size.height* 0.335,
//        width: media.size.width,

//      height: 250.0, width: 400.0,
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
//          onPanDown: (DragDownDetails details) {
//            print({"on pan down is : " : details});
//            setState(() {
//              RenderBox referenceBox = context.findRenderObject();
//              Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
//              _drawLineProperty = new List.from(_drawLineProperty)..add(new DrawLineProperty(localPosition,color,width));
//            });
//          },
          onPanUpdate: (DragUpdateDetails details) {
            setState(() {
              RenderBox referenceBox = context.findRenderObject();
              Offset localPosition = referenceBox.globalToLocal(
                  details.globalPosition);
              _drawLineProperty = new List.from(_drawLineProperty)
                ..add(new DrawLineProperty(localPosition, color, width));
            });
          },
          onPanEnd: (DragEndDetails details) {
            _drawLineProperty.add(
                new DrawLineProperty(null, Colors.black, 5.0));
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
      print("this is clear methode");
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
    List<Draw> draw = [];
    List<Position> position = [];

    for (int i = 0; i < _drawLineProperty.length; i++) {
      if (_drawLineProperty[i]._position != null &&
          _drawLineProperty[i]._color.value == _drawLineProperty[i+1]._color.value
          && _drawLineProperty[i]._width ==  _drawLineProperty[i+1]._width) {

        position.add(new Position(_drawLineProperty[i]._position.dx,
            _drawLineProperty[i]._position.dy));
        draw.add(new Draw(
            _drawLineProperty[i]._color.value, _drawLineProperty[i]._width,
            position: position));

         if(_drawLineProperty[i]._position == null){
           position.add(new Position(null,null));
           draw.add(new Draw(
               _drawLineProperty[i]._color.value, _drawLineProperty[i]._width,
               position: position));
      }

      }

    }

    CanvasProperty canvasProperty = new CanvasProperty(draw);
    final drawJson = _encode(canvasProperty);
    print({"the drawJson is : ": drawJson});

//    var decode = JSON.decode(drawJson);
//    print({"the object is : ": decode});
  }

  List<Offset> getAllPoints(List<DrawLineProperty> drawLineProperty) {
    List<Offset> points = [];
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


  DrawPainting(drawLineProperty) {
    this.drawLineProperty = drawLineProperty;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..strokeCap = StrokeCap.round;

print({"size of paint is": size});
    for (int i = 0; i < drawLineProperty.length - 1; i++) {
      if (drawLineProperty[i]._position != null &&
          drawLineProperty[i + 1]._position != null &&
          (drawLineProperty[i]._position.dx >= 0 &&
              drawLineProperty[i]._position.dy >= 0 &&
              drawLineProperty[i]._position.dx < size.width &&
              drawLineProperty[i]._position.dy < size.height) &&
          (drawLineProperty[i + 1]._position.dx >= 0 &&
              drawLineProperty[i + 1]._position.dy >= 0 &&
              drawLineProperty[i + 1]._position.dx < size.width &&
              drawLineProperty[i + 1]._position.dy < size.height)) {

            paint.color = drawLineProperty[i]._color;
            paint.strokeWidth = drawLineProperty[i]._width;

          canvas.drawLine(drawLineProperty[i]._position, drawLineProperty[i + 1]._position, paint);
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




