import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class Drawing extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;

  Drawing({key, this.onScore, this.onProgress, this.onEnd, this.iteration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DrawScreen();
}

class DrawScreen extends State<Drawing> {
  DrawScreen({this.points, this.currentPainter, this.getPng});

  List<Offset> points;
  final VoidCallback currentPainter;
  final getPng;

  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/apple.png');
    var image = new Image(image: assetsImage, width: 150.0, height: 150.0);

    return new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new Column(children: <Widget>[
            image,
            new Text("APPLE",
                style:
                    new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                    child: new Text("Clear"),
                    color: Colors.blue,
                    onPressed: onClear,
                  ),
                  new RaisedButton(
                      child: new Text("Undo"),
                      color: Colors.blue,
                      onPressed: null),
                  new RaisedButton(
                    child: new Text("Send"),
                    color: Colors.blue,
                    onPressed: getPngImage,
                  ),
                ]),
          ]),
          new Column(
//                      child:  new Container(
//                        color: Colors.red,

//                          height: 200.0,
//                          width: 200.0,
            children: <Widget>[
              new FittedBox(
                fit: BoxFit.fill,
                // otherwise the logo will be tiny
                child: new MyHomePage(),
              ),
            ],
          ),
//                    ),
        ]));
  }

  onClear() {
    if (mounted) {
      setState(() {
//        widget.points = [];
      });
      print("btnnnnn");
      print(points);
    }
  }

  getPngImage() {
    print("savinggggg");
//    return currentPainter.getPng();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Offset> _points = [];
  DrawPainting currentPainter;
  @override
  Widget build(BuildContext context) {
    currentPainter = new DrawPainting(_points);

    return new Container(
//      padding: new EdgeInsets.all(20.0),
      height: 350.0, width: 400.0,
      color: Colors.yellow,
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
      ..strokeWidth = 10.0;

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
              points[i].dy < size.height))
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(DrawPainting other) => other.points != points;
}
