import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawPadController {
  _DrawPadDelegate _delegate;
  void clear() => _delegate?.clear();
  toPng() => _delegate?.getPng();
  send() => _delegate?.send();
  multiColor(colorValue) => _delegate?.multiColor(colorValue);
  multiWidth(widthValue) => _delegate?.multiWidth(widthValue);
  undo() => _delegate?.undo();
}

abstract class _DrawPadDelegate {

  void clear();
  getPng();
  send();
  multiColor(colorValue);
  multiWidth(widthValue);
  undo();
}

class MyDrawPage extends StatefulWidget {
  DrawPadController controller;
  MyDrawPage(controller){
    this.controller = controller;
  }

  State<StatefulWidget> createState() {
    return new MyHomePageState(this.controller);
  }
}

class DrawLineProperty{
  Offset _position = null;
  var _color = new Color(0xff000000);
  var _width = 5.0;

  DrawLineProperty(position , color , width){
    this._position = position;
    this._color = color;
    this._width = width;
  }
}


class MyHomePageState extends DrawPadBase with State<MyDrawPage> implements _DrawPadDelegate {

  List<DrawLineProperty> _drawLineProperty = [];

//  List<Offset> _points = [];
  var color = new Color(0xff000000);
  var width = 8.0;
  DrawPadController _controller;

  MyHomePageState(controller){
    this._controller = controller;
  }

  DrawPainting _currentPainter;
  void initState() {
    _controller._delegate = this;
    print("this is ..........");

  }

  @override
  Widget build(BuildContext context) {
    _currentPainter = new DrawPainting(_drawLineProperty);//, color, width);
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
        ),],
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
              var drawLineProperty = new DrawLineProperty(null,color,width);
              Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
              drawLineProperty._position = localPosition;
//              _points = new List.from(_points)..add(localPosition);
              print("manuu");
              print(drawLineProperty._position);
              _drawLineProperty.add(drawLineProperty);
            });
          },
          onPanEnd: (DragEndDetails details){
            _drawLineProperty.add(new DrawLineProperty(null, Colors.black, 5.0));
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
      print({"this is clear _points":_drawLineProperty});
    });
  }

  void undo(){
    setState(() {
      for(int i = _drawLineProperty.length-2; i >= 0 ; i--){
        if(_drawLineProperty[i]._position != null){
          _drawLineProperty.removeAt(i);
        }else{
          _drawLineProperty.removeLast();
          var point = getAllPoints(_drawLineProperty);
          break;
        }
      }
    });
  }

  List<Offset> getAllPoints(List<DrawLineProperty> drawLineProperty) {
    List<Offset> points = [];
    for(int i = 0 ; i < drawLineProperty.length ; i++){
      points.add(drawLineProperty[i]._position);
    }
    return points;
  }

  void multiColor(colorValue) {
    print({"I am getting final color here  " : colorValue});
    setState(() {
      color = new Color(colorValue);
//      width = 20.0;
    });
  }
  void multiWidth(widthValue) {
    print({"I am getting final width here  " : widthValue});
    setState(() {
      width = widthValue;
    });
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

}
class DrawPainting extends CustomPainter {
  List<DrawLineProperty> drawLineProperty = [];

//  List<Offset> points = [];
//  var colors = Colors.black;
//  var width = 8.0;
  Canvas _lastCanvas;
  Size _lastSize;
  DrawPainting(drawLineProperty){
    this.drawLineProperty = drawLineProperty;
  }

  void paint(Canvas canvas, Size size) {
    print({"the main paint is called .... ": {"size" : size}});
    _lastCanvas = canvas;
    _lastSize = size;

    Paint paint = new Paint()
      ..strokeCap = StrokeCap.round;

    List drawPoint = [];
    for(int i = 0 ; i < drawLineProperty.length ;i++)
      drawPoint.add(drawLineProperty[i]._position);

    print({"the full data position is : " : drawPoint});

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
              drawLineProperty[i + 1]._position.dy < size.height)){

        paint.color = drawLineProperty[i]._color;
        paint.strokeWidth = drawLineProperty[i]._width;
        canvas.drawLine(drawLineProperty[i]._position, drawLineProperty[i + 1]._position, paint);
      }
    }
  }

  bool shouldRepaint(DrawPainting oldDelegate) {
    return true;
  }
}

abstract class DrawPadBase {

}


