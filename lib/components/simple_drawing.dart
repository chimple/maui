import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';

class Painter extends StatefulWidget {
  final PaintController paintController;

  Painter(PaintController paintController)
      : this.paintController = paintController,
        super(key: new ValueKey<PaintController>(paintController));

  @override
  _PainterState createState() => new _PainterState();
}

class _PainterState extends State<Painter> {
  bool _finished;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _finished = false;
    widget.paintController._widgetFinish = _finish;
  }

  Size _finish() {
    setState(() {
      _finished = true;
    });
    return context.size;
  }

  Drag _handleOnStart(Offset position) {
    if (count < 1) {
      setState(() {
        count++;
      });
      return _DragHandler(_onPanUpdate, _onPanEnd, onCancel);
    }
    return null;
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    if (widget.paintController._pathHistory.getDragStatus()) {
      widget.paintController._pathHistory.updateCurrent(pos);
    } else {
      widget.paintController._pathHistory.add(pos);
    }
    widget.paintController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    widget.paintController._pathHistory.endCurrent();
    widget.paintController._notifyListeners();
    setState(() {
      count = 0;
    });
  }

  void onCancel() {
    widget.paintController._pathHistory.endCurrent();
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      key: Key("painting"),
      child: LayoutBuilder(builder: (context, box) {
        return ClipRect(
          child: RawGestureDetector(
            behavior: HitTestBehavior.opaque,
            gestures: <Type, GestureRecognizerFactory>{
              ImmediateMultiDragGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      ImmediateMultiDragGestureRecognizer>(
                () => ImmediateMultiDragGestureRecognizer(),
                (ImmediateMultiDragGestureRecognizer instance) {
                  instance..onStart = _handleOnStart;
                },
              ),
            },
            child: Container(
              child: CustomPaint(
                willChange: true,
                painter: new _PainterPainter(
                    widget.paintController._pathHistory,
                    repaint: widget.paintController),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _DragHandler extends Drag {
  _DragHandler(this.onUpdate, this.onEnd, this.onCancel);

  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;
  final Function onCancel;
  @override
  void update(DragUpdateDetails details) {
    onUpdate(details);
  }

  @override
  void end(DragEndDetails details) {
    onEnd(details);
  }

  @override
  void cancel() {
    onCancel();
    super.cancel();
  }
}

class _PainterPainter extends CustomPainter {
  final _PathHistory _path;

  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class _PathHistory {
  List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  bool _inDrag = false;

  _PathHistory() {
    _paths = new List<MapEntry<Path, Paint>>();
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = new Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(new MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  bool getDragStatus() {
    return _inDrag;
  }

  void draw(Canvas canvas, Size size) {
    for (MapEntry<Path, Paint> path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }
}

class PaintController extends ChangeNotifier {
  Color _drawColor = new Color.fromARGB(255, 0, 0, 0);
  Color _backgroundColor = new Color.fromARGB(255, 255, 255, 255);

  double _thickness = 1.0;
  _PathHistory _pathHistory;
  ValueGetter<Size> _widgetFinish;

  PaintController() {
    _pathHistory = new _PathHistory();
  }

  Color get drawColor => _drawColor;
  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = new Paint();
    paint.color = drawColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = thickness;
    paint.strokeJoin = StrokeJoin.round;
    _pathHistory.currentPaint = paint;
    notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}
