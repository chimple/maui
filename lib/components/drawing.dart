import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class MyDrawingPage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyDrawingPage> {
  List<Offset> _points = [];
  DrawPainting currentPainter;
  @override
  Widget build(BuildContext context) {
    currentPainter = new DrawPainting(_points);

    return new Container(
//      padding: new EdgeInsets.all(20.0),
      height: 350.0, width: 400.0,
//      color: Colors.yellow,
      margin: new EdgeInsets.all(5.0),
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
              print("manuu");
              print(_points);
            });
          },
          onPanEnd: (DragEndDetails details) => _points.add(null),
          child: new CustomPaint(
            painter: currentPainter,

//            child: new ConstrainedBox(
//              constraints: new BoxConstraints.expand(),
//
//            ),
          ),
        ),
      ),
    );
  }
}

class DrawPainting extends CustomPainter {
  List<Offset> points = [];
  Canvas _lastCanvas;
  Size _lastSize;
  DrawPainting(this.points);

  ui.Image getPng() {
    if (_lastCanvas == null) {
      return null;
    }
    if (_lastSize == null) {
      return null;
    }
    var recorder = new ui.PictureRecorder();
    var origin = new Offset(0.0, 0.0);
    var paintBounds = new Rect.fromPoints(
        _lastSize.topLeft(origin), _lastSize.bottomRight(origin));
    var canvas = new Canvas(recorder, paintBounds);
//    print({"the recxeeeeeeeeeee value is this ": canvas});
    paint(canvas, _lastSize);
    var picture = recorder.endRecording();
    return picture.toImage(200, 200);
    print({"the recxeeeeeeeeeee value is this ": picture});
//    Image.toByteData();
  }

  void paint(Canvas canvas, Size size) {
    _lastCanvas = canvas;
    _lastSize = size;
    print({"the size value is this ": size});
    print({"the height value is this ": size.height});
    print({"the width value is this ": size.width});
    print({"the canvas value is this ": canvas});
//    print({"the recx value is this ": getPng()});

    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    var path = new Path();

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&points[i + 1] != null &&
          (points[i].dx >= 0 &&
              points[i].dy >= 0 &&
              points[i].dx < size.width &&
              points[i].dy < size.height) &&
          (points[i + 1].dx >= 0 &&
              points[i + 1].dy >= 0 &&
              points[i + 1].dx < size.width &&
              points[i + 1].dy < size.height))
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(DrawPainting other) => other.points != points;
}
