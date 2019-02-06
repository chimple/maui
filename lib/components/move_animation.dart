import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class MoveContainer extends StatefulWidget {
  final int coinCount;
  List<int> starValue;
  int index;
  Offset offset;
  final AnimationController animationController;
  final double duration;
  int starCount;

  MoveContainer(
      {Key key,
      this.index,
      this.coinCount,
      this.offset,
      this.starValue,
      this.starCount,
      this.animationController,
      this.duration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyMoveContainer();
  }
}

class _MyMoveContainer extends State<MoveContainer>
    with TickerProviderStateMixin {
  GlobalKey _globalKey2 = new GlobalKey();
  Animation<Offset> rotate;
  Animation<double> _width;
  Animation<double> _height;
  List<Offset> _offsetOffAllDottedCircle = [];
  AnimationController _controller;
  Animation<EdgeInsets> movement;
  Animation<Offset> _offset;
  Offset begin = Offset(0.0, 0.0);
  Offset end = Offset(100, 200.0);
  double myEnd;
  Offset local;
  var countOpacity = 1.0;
  var size = 0.0;
  var extraSize = 0.0;
  double start;
  double ending;
  MediaQueryData media;
  int index = 100;
  double animationDuration = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((s) {
      _afterLayout();
    });

    // start = (widget.duration * widget.starCount) * 3.toDouble();
    // ending = (start + widget.duration) * 2500;
    // Offset endOffset = Offset(ending, 0.0);
     final int totalDuration = 4000;
    _controller = AnimationController(
        vsync: this, duration: new Duration(milliseconds: totalDuration));
    animationDuration = totalDuration / (100 * (totalDuration / widget.starCount));
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 4),
    // );
    // print("start and end iss     $start     ,,,,, .... $end");
    // _offset =
    //    Tween<Offset>(begin: begin / 100, end: -(widget.offset) / 100)
    //         .animate(_controller);
    _width = Tween<double>(
      begin: 0,
      end: -40,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    _width.addListener(() {
    // setState(() {
    extraSize = _width.value+ _controller.value+4;
    // });
    });
    _controller.forward();
    
  }

  void _afterLayout() {
    final RenderBox renderBoxRed =
        _globalKey2.currentContext.findRenderObject();
    Offset offset = -renderBoxRed.globalToLocal(Offset.zero);
    begin = offset;
    print("ofsetsssssssssssssssssssssssssssisss  $begin");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    start = (animationDuration * widget.index).toDouble();
    // myEnd = (start + widget.duration).toDouble();
    Size media = MediaQuery.of(context).size;
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return Stack(
            children: <Widget>[
              _Animated(
                scale: Tween<Offset>(
                        begin: begin / 100, end: (widget.offset) / 100)
                    .animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      start,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ),
                child: Container(
                  key: _globalKey2,
                  height: media.height * 0.12 + extraSize,
                  width: media.width * 0.12 + extraSize,
                  // transform: Matrix4.identity()..rotateZ(extraSize*.05),
                  child: FlareActor(
                    "assets/coin.flr",
                    animation: "rotate",
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class _Animated extends AnimatedWidget {
  final Widget child;
  _Animated({
    Key key,
    this.child,
    Animation<Offset> scale,
  }) : super(key: key, listenable: scale);
  // TODO: implement listenable
  Animation<Offset> get listenable => super.listenable;
  double get translateX {
    // print(listenable.value);
    double x = listenable.value.dx * 100;
    double val = x;
    // print(x);
    // final val = sin(x / 2) * 100;
    // double val = -sqrt(-x * 2) * 50;

    return val;
  }

  double get translateY {
    double val = listenable.value.dy * 100;
    // print(listenable.value);
    return val;
  }

  double get translateZ {
    double val = listenable.value.dx * 100;
    // print(val);
    // print(-listenable.value.dx);
    if (val <= 1.0)
      return 1.0;
    else
      return val;
  }

  @override
  Widget build(BuildContext context) {
    // final Matrix4 mat =
    //     new Matrix4.translationValues(translateX, translateY, 0.0);

    // return Transform(transform: mat, child: child);
    return _SingleChild(
      child: child,
      offset: Offset(
        translateZ,
        translateY,
      ),
    );
  }
}

class _SingleChild extends SingleChildRenderObjectWidget {
  final Widget child;
  final Offset offset;
  _SingleChild({this.child, this.offset}) : super(child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    print('redner box');
    return _RenderObject(offset: offset);
  }

  @override
  void updateRenderObject(BuildContext context, _RenderObject renderObject) {
    super.updateRenderObject(context, renderObject..offsetUpdate = offset);
  }
}

class _RenderObject extends RenderProxyBox {
  final Offset offset;
  _RenderObject({RenderBox child, this.offset})
      : assert(offset != null),
        _offset = offset,
        super(child);
  Offset _offset;
  set offsetUpdate(Offset of) {
    _offset = of;
    markNeedsPaint();
  }

  @override
  void paint(context, offset) {
    if (child != null) {
      offset = _offset;
      context.paintChild(child, offset);
    }
  }
}
