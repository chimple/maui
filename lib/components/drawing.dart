import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawPadController {
  _DrawPadDelegate _delegate;
  void clear() => _delegate?.clear();
  toPng() => _delegate?.getPng();
  send() => _delegate?.send();

}

abstract class _DrawPadDelegate {

  void clear();
  getPng();
  send();

}

class MyDrawPage extends StatefulWidget {
  final DrawPadController controller;
  MyDrawPage(this.controller);

  State<StatefulWidget> createState() {
    return new MyHomePageState(controller);
  }
}

class MyHomePageState extends DrawPadBase with State<MyDrawPage> implements _DrawPadDelegate {

  List<Offset> _points = [];
  DrawPadController _controller;
  MyHomePageState(this._controller);

  DrawPainting _currentPainter;
  void initState() {
    _controller._delegate = this;
    print("this is ..........");

  }

  @override
  Widget build(BuildContext context) {
    _currentPainter = new DrawPainting(_points);

    return new Container(
      margin: new EdgeInsets.all(5.0),
      height: 350.0, width: 400.0,
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

              Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
              _points = new List.from(_points)..add(localPosition);
//              print("manuu");
              print(_points);
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
          child: new CustomPaint(
            painter: _currentPainter,

          ),
        ),
      ),
    );
  }


  void clear() {
    super.clear();
    if (mounted) {
      setState(() {
        _points = [];
        print({"this is clear _points":_points});
      });
    }
  }


  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class DrawPainting extends CustomPainter {
  List<Offset> points = [];
  Canvas _lastCanvas;
  Size _lastSize;
  DrawPainting(points){
//    print({"the data of point getting form parent : ": points});
    this.points = points;
  }

//  ui.Image getPng() {
//    if (_lastCanvas == null) {
//      return null;
//    }
//    if (_lastSize == null) {
//      return null;
//    }
//    var recorder = new ui.PictureRecorder();
//    var origin = new Offset(0.0, 0.0);
//    var paintBounds = new Rect.fromPoints(_lastSize.topLeft(origin), _lastSize.bottomRight(origin));
//    var canvas = new Canvas(recorder, paintBounds);
//    paint(canvas, _lastSize);
//    var picture = recorder.endRecording();
//    return picture.toImage(_lastSize.width.round(), _lastSize.height.round());
//  }

  void paint(Canvas canvas, Size size) {
    print({"the main paint is called .... ": {"size" : size}});
    _lastCanvas = canvas;
    _lastSize = size;
//    print({"the size value is this ": size});
//    print({"the height value is this ": size.height});
//    print({"the width value is this ": size.width});
//    print({"the points value is this ": points});

    Paint paint = new Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

//    var path = new Path();

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&
          points[i + 1] != null &&
          (points[i].dx >= 0 &&
              points[i].dy >= 0 &&
              points[i].dx < size.width &&
              points[i].dy < size.height) &&
          (points[i + 1].dx >= 0 &&
              points[i + 1].dy >= 0 &&
              points[i + 1].dx < size.width &&
              points[i + 1].dy < size.height)){
        canvas.drawLine(points[i], points[i + 1], paint);
      }

    }
  }

  bool shouldRepaint(DrawPainting other) => other.points != points;
}
abstract class DrawPadBase {
  final List _data = [];

  List points = [];
  bool isEmpty;

  drawPadBase() {
    this.clear();
  }


  void clear() {
    _data.clear();
    reset();
    isEmpty = true;
    print("this is clear to clear the drawing.....");
  }


  void reset() {
    points.clear();
  }
}