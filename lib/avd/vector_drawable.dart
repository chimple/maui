import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:xmlstream/xmlstream.dart';

class VectorDrawable extends StatelessWidget {
  VectorDrawable({
    @required this.vectorDrawableXml
  }) : super();

  final String vectorDrawableXml;

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      painter: new VectorDrawablePainter(vectorDrawableXml: vectorDrawableXml),
      size: const Size(200.0, 200.0),
    );
  }
}

class VectorDrawablePainter extends CustomPainter {
  VectorDrawablePainter({
    @required this.vectorDrawableXml
  }) : super();

  final String vectorDrawableXml;

  @override
  void paint(Canvas canvas, Size size) {
    var xmlStreamer = new XmlStreamer(vectorDrawableXml);
    xmlStreamer.read().listen((e) => print("listen: $e"));
    var rect = Offset.zero & size;
    var gradient = new RadialGradient(
      center: const Alignment(0.7, -0.6),
      radius: 0.2,
      colors: [const Color(0xFFFFFF00), const Color(0xFF0099FF)],
      stops: [0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      new Paint()..shader = gradient.createShader(rect),
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);
  final List<Offset> points;
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }
  bool shouldRepaint(SignaturePainter other) => other.points != points;
}
class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}
class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
          referenceBox.globalToLocal(details.globalPosition);
          _points = new List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: new CustomPaint(painter: new SignaturePainter(_points)),
    );
  }
}