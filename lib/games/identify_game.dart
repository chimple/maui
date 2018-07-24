import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/loca.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/gameaudio.dart';

Map _decoded;
int _length = 0;

class IdentifyGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  IdentifyGame(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new _IdentifyGameState();
}

class _IdentifyGameState extends State<IdentifyGame>
    with TickerProviderStateMixin {
  List<AnimationController> _textControllers = new List<AnimationController>();
  List<Animation<double>> _animateText = new List<Animation<double>>();
  bool _isLoading = true;
  List<Widget> _paint = [];

  AnimationController _imgController;

  Animation<double> animateImage;

  void _initBoard() async {
    setState(() => _isLoading = true);

    _decoded = await json.decode(await fetchData());
    new Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        for (var i = 0; i < _decoded["number"]; i++) {
          _textControllers.add(new AnimationController(
              vsync: this, duration: new Duration(milliseconds: 500)));
          _animateText.add(new CurvedAnimation(
              parent: _textControllers[i], curve: Curves.elasticOut));
        }
        _imgController.forward();
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _renderChoice("text",900.0, 400.0, Orientation.landscape, 0.0, 0.0);
    _initBoard();
    print(">>>>>>>>>initstate.>>>$_decoded");
    _imgController = new AnimationController(
        duration: new Duration(
          milliseconds: 800,
        ),
        vsync: this);

    animateImage =
        new CurvedAnimation(parent: _imgController, curve: Curves.bounceOut);
  }

  @override
  void didUpdateWidget(IdentifyGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _paint = [];
      _textControllers = [];
      _animateText = [];
      _initBoard();
    }
  }

  void _renderChoice(String text, double height, double width,
      Orientation orientation, double X, double Y) {
    setState(() {
      _paint.add(
        new CustomPaint(
          painter: new Stickers(
            text: text,
            x: X,
            y: Y,
            height: height,
            width: width,
            orientation: orientation,
          ),
        ),
      );
    });
  }

  Widget _buildPaint(int i, Widget w) {
    _textControllers[i].forward();
    return new ScaleTransition(
      scale: _animateText[i],
      child: new RepaintBoundary(
        child: w,
      ),
    );
  }

  List<Widget> _createTextPaint(BuildContext context) {
    int i = 0;
    return _paint.map((f) => _buildPaint(i++, f)).toList(growable: true);
  }

  Widget _builtButton(BuildContext context, double maxHeight, double maxWidth,
      int cols, Orientation orientation) {
    print((_decoded["parts"] as List).length);
    int j = 0;
    int r = ((_decoded["parts"] as List).length / cols +
            ((((_decoded["parts"] as List).length % cols) == 0) ? 0 : 1))
        .toInt();
    print(r);
    (_decoded["parts"] as List).shuffle();
    return new ResponsiveGridView(
      rows: r,
      cols: cols,
      children: (_decoded["parts"] as List)
          .map((e) =>
              _buildItems(j++, e, maxHeight, maxWidth, cols, orientation))
          .toList(growable: false),
    );
  }

  Widget _buildItems(int i, var part, double maxHeight, double maxWidth,
      int cols, Orientation orientation) {
    return new DragBox(
      onScore: widget.onScore,
      onEnd: widget.onEnd,
      onProgress: widget.onProgress,
      gameConfig: widget.gameConfig,
      render: _renderChoice,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      cols: cols,
      key: new ValueKey<int>(i),
      part: part,
      orientation: orientation,
    );
  }

  _onDragStart(BuildContext context, DragStartDetails start) {
    print(start.globalPosition.toString());
    // RenderBox getBox = context.findRenderObject();
    // var local = getBox.globalToLocal(start.globalPosition);
    // print(local.dx.toString() + "|" + local.dy.toString());
  }

  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    print(update.globalPosition.toString());
    // RenderBox getBox = context.findRenderObject();
    // var local = getBox.globalToLocal(update.globalPosition);
    // print(local.dx.toString() + "|" + local.dy.toString());
  }

  @override
  void dispose() {
    _imgController.dispose();
    for (var i = 0; i < _decoded["number"]; i++) {
      _textControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    print(_paint);
    Orientation orientation = MediaQuery.of(context).orientation;
    int cols = orientation == Orientation.landscape ? 7 : 5;
    return new LayoutBuilder(builder: (context, constraint) {
      print(
          "This is the height of the screen except header >>>>>  ${constraint.maxHeight}");
      print(
          "This is the width of the screen except header >>>>> ${constraint.maxWidth}");
      return new Flex(
        direction: Axis.vertical,
        children: <Widget>[
          new GestureDetector(
            onHorizontalDragStart: (DragStartDetails start) =>
                _onDragStart(context, start),
            onHorizontalDragUpdate: (DragUpdateDetails update) =>
                _onDragUpdate(context, update),
            onVerticalDragStart: (DragStartDetails start) =>
                _onDragStart(context, start),
            onVerticalDragUpdate: (DragUpdateDetails update) =>
                _onDragUpdate(context, update),
            child: new Container(
                height: (constraint.maxHeight) * 3 / 4,
                width: constraint.maxWidth,
                child: new Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    new AnimatedImage(
                        item: _decoded["id"],
                        animation: animateImage,
                        height: (constraint.maxHeight) * 3 / 4,
                        width: constraint.maxWidth,
                        orientation: orientation),
                    new Stack(
                      children: _createTextPaint(context),
                    ),
                  ],
                )),
          ),
          new Container(
              height: (constraint.maxHeight) / 4,
              width: constraint.maxWidth,
              decoration: new BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: _builtButton(context, constraint.maxHeight / 4,
                  constraint.maxWidth, cols, orientation)),
        ],
      );
    });
  }
}

class DragBox extends StatefulWidget {
  var part;
  double maxHeight;
  double maxWidth;
  int cols;
  Function render;
  Function onScore;
  GameConfig gameConfig;
  Function onEnd;
  Function onProgress;
  Orientation orientation;

  DragBox(
      {this.onEnd,
      this.onProgress,
      this.onScore,
      this.gameConfig,
      this.maxHeight,
      this.maxWidth,
      this.cols,
      Key key,
      this.part,
      this.render,
      this.orientation})
      : super(key: key);

  @override
  DragBoxState createState() => new DragBoxState();
}

class DragBoxState extends State<DragBox> with TickerProviderStateMixin {
  AnimationController controller, shakeController;
  Animation<double> animation, shakeAnimation, noanimation;

  int _flag1 = 1;
  var part;
  int _flag = 0;
  double maxHeight;
  double maxWidth;
  int cols;
  Function render;
  Orientation orientation;
  GameConfig gameConfig;

  // List<String> _buildPartsList() {
  //   List<String> partsName = [];
  //   for (var i = 0; i < (_decoded["parts"] as List).length; i++) {
  //     partsName.add((_decoded["parts"] as List)[i]["name"]);
  //   }
  //   return partsName;
  // }

  // _onTapDown(BuildContext context, TapDownDetails down) {
  //   // print(start.globalPosition.toString());
  //   RenderBox getBox = context.findRenderObject();
  //   var local = getBox.globalToLocal(down.globalPosition);
  //   print(local.dx.toString() + "|" + local.dy.toString());
  // }

  // _onTapUp(BuildContext context, TapUpDetails up) {
  //   // print(update.globalPosition.toString());
  //   RenderBox getBox = context.findRenderObject();
  //   var local = getBox.globalToLocal(up.globalPosition);
  //   print(local.dx.toString() + "|" + local.dy.toString());
  // }

  // _onDragStart(BuildContext context, DragStartDetails start) {
  //   // print(start.globalPosition.toString());
  //   RenderBox getBox = context.findRenderObject();
  //   var local = getBox.globalToLocal(start.globalPosition);
  //   print(local.dx.toString() + "|" + local.dy.toString());
  // }

  // _onDragUpdate(BuildContext context, DragUpdateDetails update) {
  //   // print(update.globalPosition.toString());
  //   RenderBox getBox = context.findRenderObject();
  //   var local = getBox.globalToLocal(update.globalPosition);
  //   print(local.dx.toString() + "|" + local.dy.toString());
  // }

  void toAnimateFunction() {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  void toAnimateButton() {
    shakeController.forward();
  }

  @override
  void initState() {
    super.initState();
    // _length = _buildPartsList().length;
    _length = _decoded["number"];

    shakeController = new AnimationController(
        duration: new Duration(milliseconds: 800), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation = new Tween(begin: -3.0, end: 3.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    shakeAnimation =
        new CurvedAnimation(parent: shakeController, curve: Curves.easeOut);
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(shakeController);

    part = widget.part;
    maxHeight = widget.maxHeight;
    maxWidth = widget.maxWidth;
    render = widget.render;
    cols = widget.cols;
    orientation = widget.orientation;
    gameConfig = widget.gameConfig;

    toAnimateButton();
  }

  @override
  void dispose() {
    controller.dispose();
    shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int r = ((_decoded["parts"] as List).length / cols +
            ((((_decoded["parts"] as List).length % cols) == 0) ? 0 : 1))
        .toInt();

    return new Container(
      margin: new EdgeInsets.all(4.0),
      decoration: new BoxDecoration(
          borderRadius:
              new BorderRadius.all(const Radius.elliptical(16.0, 16.0)),
          color: Color(0xffEDEDED),
          boxShadow: [
            new BoxShadow(
                color: Colors.black87,
                // blurRadius: 4.0
                // spreadRadius: 4.0
                offset: Offset(2.0, 2.0))
          ]),
      width: maxWidth / cols - 8.0,
      height: maxHeight / r - 8.0,
      // color: Theme.of(context).buttonColor,
      child: new ScaleTransition(
        scale: shakeAnimation,
        child: new Draggable(
          // feedbackOffset: Offset.zero,
          dragAnchor: DragAnchor.child,
          maxSimultaneousDrags: 1,
          key: widget.key,
          data: (_flag1 == 0) ? "" : Loca.of(context).intl(part["name"]),
          child: new AnimatedDrag(
            cols: cols,
            height: maxHeight,
            width: maxWidth,
            animation: (_flag == 0) ? noanimation : animation,
            draggableColor: Theme.of(context).buttonColor,
            draggableText:
                (_flag1 == 0) ? "" : Loca.of(context).intl(part["name"]),
          ),
          feedback: new AnimatedFeedback(
              height: maxHeight,
              width: maxWidth,
              animation: animation,
              draggableColor: Theme.of(context).disabledColor,
              draggableText:
                  (_flag1 == 0) ? "" : Loca.of(context).intl(part["name"])),
          onDraggableCanceled: (velocity, offset) {
            // RenderBox box = context.findRenderObject();
            // offset = box.globalToLocal(offset);
            // velocity = Velocity(pixelsPerSecond: Offset(50.0, 50.0));

            print(velocity);
            Size media = MediaQuery.of(context).size;
            double h, w, h1, w1, x1, y1, rh, rw, headerSize;
            headerSize = media.height - 4 * (maxHeight);
            print(orientation);
            if (orientation == Orientation.portrait) {
              // if ((gameConfig.gameDisplay == GameDisplay.myHeadToHead || gameConfig.gameDisplay == GameDisplay.otherHeadToHead )) {
              //   print(">>>>>inside the ORientation portrait function for checking how the game config working<<<<<<");
              //   print(offset);
              //   print(offset.dy + 40.0);
              //   x1 = 130.0;
              // } else {
              // x1 = 90.0;
              // y1 = 120.0;
              // }
              h = ((9 * 3 * maxHeight * 3) / (40));
              w = ((4 * maxWidth) / 5);
              x1 = 90.0;
              y1 = 120.0;
            } else {
              // if ((gameConfig.gameDisplay == GameDisplay.myHeadToHead || gameConfig.gameDisplay == GameDisplay.otherHeadToHead )) {
              //   print(">>>>>inside the Orientation landscape function for checking how the game config working<<<<<<");
              //   print(offset);
              //   print(offset.dy + 40.0);
              //   x1 = 140.0;
              // y1 = 90.0;
              // } else {
              // x1 = 100.0;
              // y1 = 90.0;
              // }
              h = ((49 * 3 * maxHeight * 3) / (200));
              w = ((maxWidth) / 2);
              x1 = 100.0;
              y1 = 90.0;
            }
            h1 = ((maxHeight * 3) - h) / 2;
            w1 = (maxWidth - w) / 2;
            print(h1);
            print(w1);
            rh = h / _decoded["height"];
            rw = w / _decoded["width"];
            if (true) {
              print(">>>>>");
              print(offset.dx);
              print(offset.dy);
            }
            if (((offset.dy - y1) <
                    (((rh * part["data"]["y"]) + h1) +
                        (rh * part["data"]["height"]) / 2)) &&
                ((offset.dy - y1) >
                    (((rh * part["data"]["y"]) + h1) -
                        (rh * part["data"]["height"]) / 2)) &&
                ((offset.dx + x1) <
                    (((rw * part["data"]["x"]) + w1) +
                        (rw * part["data"]["width"]) / 2)) &&
                ((offset.dx + x1) >
                    (((rw * part["data"]["x"]) + w1) -
                        (rw * part["data"]["width"]) / 2))) {
              render(
                  Loca.of(context).intl(part["name"]),
                  maxHeight,
                  maxWidth,
                  orientation,
                  w1 + (rw * part["data"]["x"]),
                  h1 + (rh * part["data"]["y"]));
              print("These are the system offest of y and x");
              print(offset.dx);
              print(offset.dy);
              print("range in x");
              print((((rw * part["data"]["x"]) + w1) -
                  (rw * part["data"]["width"]) / 2));
              print((((rw * part["data"]["x"]) + w1) +
                  (rw * part["data"]["width"]) / 2));
              print("range in y");
              print((((rh * part["data"]["y"]) + h1) -
                  (rh * part["data"]["height"]) / 2));
              print((((rh * part["data"]["y"]) + h1) +
                  (rh * part["data"]["height"]) / 2));
              print("centre given cordis");
              print(h1 + (rh * part["data"]["y"]));
              print(w1 + (rw * part["data"]["x"]));
              print("done coredis");
              print(headerSize);
              print(maxHeight * 4);
              print(media.height);
              print(offset.dy);
              print(y1);
              widget.onScore(1);
              widget.onProgress(
                  (1 + (_decoded["number"] - _length)) / _decoded["number"]);
              _length = _length - 1;
              print(_length);
              setState(() {
                _flag1 = 0;
              });
              new Future.delayed(const Duration(milliseconds: 1000), () {
                if (_length == 0) {
                  widget.onEnd();
                }
              });
            } else {
              widget.onScore(-1);
              _flag = 1;
              toAnimateFunction();
              new Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                  _flag = 0;
                });
                controller.stop();
              });
            }
          },
        ),
      ),
    );
  }
}

class AnimatedFeedback extends AnimatedWidget {
  AnimatedFeedback(
      {Key key,
      Animation<double> animation,
      this.height,
      this.width,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;
  final double height;
  final double width;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      color: draggableColor.withOpacity(0.0),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              decorationColor: Colors.black87,
              fontSize: width * 0.04,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class AnimatedDrag extends AnimatedWidget {
  AnimatedDrag(
      {Key key,
      Animation<double> animation,
      this.height,
      this.width,
      this.cols,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;
  final double height;
  final double width;
  final int cols;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double translateX = animation.value;
    print("value: $translateX");
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
            color: Theme.of(context).hintColor,
            decoration: TextDecoration.none,
            fontSize: (width / cols) * 0.15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AnimatedImage extends AnimatedWidget {
  AnimatedImage(
      {Key key,
      Animation<double> animation,
      this.item,
      this.height,
      this.width,
      this.orientation})
      : super(key: key, listenable: animation);

  final double height;
  final double width;
  final String item;
  final Orientation orientation;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: new Container(
        decoration: new BoxDecoration(
            border: new Border.all(width: 5.0, color: Colors.amberAccent),
            color: Colors.blueGrey),
        height: orientation == Orientation.portrait
            ? (((height) * 3) / 4) - (((height) * 3) / 40)
            : (((height) * 3) / 4) - (((height) * 3) / 200),
        width: orientation == Orientation.portrait
            ? width - (width / 5)
            : width - (width / 2),
        child: new ScaleTransition(
          scale: animation,
          child: new Image(
            image: AssetImage('assets/' + item),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

class Stickers extends CustomPainter {
  Stickers({
    this.orientation,
    this.width,
    this.height,
    this.text,
    this.x,
    this.y,
  });
  final String text;
  final double x;
  final double y;
  final double width;
  final double height;
  final Orientation orientation;

  @override
  void paint(Canvas canvas, Size size) {
    TextSpan span = new TextSpan(
        text: text,
        style: new TextStyle(
            color: Colors.black,
            fontSize: orientation == Orientation.portrait
                ? ((width * 4) / 5) * 0.03
                : (width / 2) * 0.03,
            fontWeight: FontWeight.bold));
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(x, y));
    canvas.save();
    canvas.restore();
  }

  @override
  bool shouldRepaint(Stickers oldDelegate) {
    if (oldDelegate.text != text) {
      print(">>>>>>>>>>>>>>>>>>$text");
      return true;
    } else {
      print(">>>>>>>>>>>>>>${oldDelegate.text}");
      return false;
    }
  }
}
