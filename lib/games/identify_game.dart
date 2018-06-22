import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/repos/game_data.dart';

Map _decoded;
int _length = 0;

class IdentifyGame extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  IdentifyGame(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
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
    // String jsonGameInfo = await fetchIdentifyData();

    _decoded = await json.decode(await fetchIdentifyData());
    print("intiborad.>>>>>>$_decoded");
    print(_decoded["parts"]);
    // print(_decoded["parts"] as List);
    new Future.delayed(const Duration(milliseconds: 500), () {
      // setState(() => _isLoading = false);
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

  void _renderChoice(String text, double X, double Y) {
    setState(() {
      _paint.add(
        new CustomPaint(
          painter: new Stickers(
            text: text,
            x: X,
            y: Y,
            // x: 100.0,
            // y: 100.0
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
    // return new RepaintBoundary(
    //   child: w,
    // );
  }

  List<Widget> _createTextPaint(BuildContext context) {
    int i = 0;
    return _paint.map((f) => _buildPaint(i++, f)).toList(growable: true);
  }

  Widget _builtButton(
      BuildContext context, double maxHeight, double maxWidth, int cols) {
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
          .map((e) => _buildItems(
                j++,
                e,
                maxHeight,
                maxWidth,
                cols,
              ))
          .toList(growable: false),
    );
  }

  Widget _buildItems(
      int i, var part, double maxHeight, double maxWidth, int cols) {
    return new DragBox(
      onScore: widget.onScore,
      onEnd: widget.onEnd,
      render: _renderChoice,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      cols: cols,
      key: new ValueKey<int>(i),
      part: part,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>inside build $_decoded");
    Size media = MediaQuery.of(context).size;
    print("This is the height of the whole screen >>>>>  ${media.height}");
    print("This is the width of the whole screen >>>>> ${media.width}");
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
                // decoration: new BoxDecoration(
                //   color: Theme.of(context).backgroundColor,
                // ),
                child: new Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    // new Center(
                    //   child: new Container(
                    //     decoration: new BoxDecoration(
                    //       border: new Border.all(width: 5.0, color: Colors.amber),
                    //     ),
                    //     height: (((constraint.maxHeight) * 3) / 4) - (((constraint.maxHeight) * 3) / 20),
                    //     width: constraint.maxWidth - (constraint.maxWidth/4),
                    //     child:new ScaleTransition(
                    //   scale: animateImage,
                    //   child: new Image(
                    //     image: AssetImage('assets/' + _decoded["id"]),
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    //   ),
                    // ),
                    new AnimatedImage(
                      item: _decoded["id"],
                      animation: animateImage,
                      height: (constraint.maxHeight) * 3 / 4,
                      width: constraint.maxWidth,
                    ),
                    // new ScaleTransition(
                    //   scale: animateImage,
                    //   child: new Image(
                    //     image: AssetImage('assets/' + _decoded["id"]),
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
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
                  constraint.maxWidth, cols)),
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
  Function onEnd;

  DragBox({
    this.onEnd,
    this.onScore,
    this.maxHeight,
    this.maxWidth,
    this.cols,
    Key key,
    this.part,
    this.render,
  }) : super(key: key);

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

  List<String> _buildPartsList() {
    List<String> partsName = [];
    for (var i = 0; i < (_decoded["parts"] as List).length; i++) {
      partsName.add((_decoded["parts"] as List)[i]["name"]);
    }
    return partsName;
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
    _length = _buildPartsList().length;

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
    // Size media = MediaQuery.of(context).size;
    // double _height = media.height;
    // double _width = media.width;
    int r = ((_decoded["parts"] as List).length / cols +
            ((((_decoded["parts"] as List).length % cols) == 0) ? 0 : 1))
        .toInt();

    return new Container(
      width: maxWidth / cols,
      height: maxHeight / r,
      color: Theme.of(context).buttonColor,
      child: new ScaleTransition(
        scale: shakeAnimation,
        child: new Draggable(
          data: (_flag1 == 0) ? "" : part["name"],
          child: new AnimatedDrag(
            cols: cols,
            height: maxHeight,
            width: maxWidth,
            animation: (_flag == 0) ? noanimation : animation,
            draggableColor: Theme.of(context).buttonColor,
            draggableText: (_flag1 == 0) ? "" : part["name"],
          ),
          feedback: new AnimatedFeedback(
              height: maxHeight,
              width: maxWidth,
              animation: animation,
              draggableColor: Theme.of(context).disabledColor,
              draggableText: (_flag1 == 0) ? "" : part["name"]),
          onDraggableCanceled: (velocity, offset) {
            print(velocity);
            Size media = MediaQuery.of(context).size;
            double rh, rw, headerSize;
            rh = (3 * maxHeight) / _decoded["height"];
            print("bffvhqvfihvqfiqvi...$rh");
            print(_length);
            rw = maxWidth / _decoded["width"];
            headerSize = media.height - 4 * (maxHeight);
            if ((((offset.dy + 35.0) >
                        (headerSize +
                            ((rh * part["data"]["y"]) -
                                ((rh * part["data"]["height"]) / 2)))) &&
                    ((offset.dy + 35.0) <
                        (headerSize +
                            ((rh * part["data"]["y"]) +
                                ((rh * part["data"]["height"]) / 2))))) &&
                (((offset.dx + 40.0)  >
                        (((rw * part["data"]["x"]) -
                            ((rw * part["data"]["width"]) / 2)))) &&
                    ((offset.dx + 40.0) <
                        (((rw * part["data"]["x"]) +
                            ((rw * part["data"]["width"]) / 2)))))) {
              print(
                  " Header Size $headerSize  Start of object  along y axis ...>> ${(headerSize + ((rh * part["data"]["y"]) -((rh * part["data"]["height"]) / 2)))}  End of object  ${(headerSize +((rh * part["data"]["y"]) +((rh * part["data"]["height"]) / 2)))}");
                  print(
                  "Start of object  along x axis ...>> ${( ((rw * part["data"]["x"]) -((rw * part["data"]["width"]) / 2)))}  End of object  ${(((rw * part["data"]["x"]) +((rw * part["data"]["width"]) / 2)))}");
              render(part["name"],(rw * part["data"]["x"]) , (rh * part["data"]["y"]));
              print(offset.dy);
              widget.onScore(1);
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
            }
            // if(true){
            //   print("xxxxxxx...${offset.dx}");

            //   print("yyyyyyy...${offset.dy}");
            //   print((rh * part["data"]["y"]));
            // }
            else {
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
            // color: Theme.of(context).highlightColor,
            color: Colors.black,
            decoration: TextDecoration.none,
            fontSize: width * 0.05,
          ),
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
  AnimatedImage({
    Key key,
    Animation<double> animation,
    this.item,
    this.height,
    this.width,
  }) : super(key: key, listenable: animation);

  final double height;
  final double width;
  final String item;

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: new ScaleTransition(
        scale: animation,
        child: new Image(
          image: AssetImage('assets/' + item),
          fit: BoxFit.contain,
        ),
      ),
    );
    // return Center(
    //                     child: new Container(
    //                       // decoration: new BoxDecoration(
    //                       //   border: new Border.all(width: 5.0, color: Colors.amber),
    //                       // ),
    //                       height: (((height) * 3) / 4) - (((height) * 3) / 20),
    //                       width: width - (width/10),
    //                       child:new ScaleTransition(
    //                     scale: animation,
    //                     child: new Image(
    //                       image: AssetImage('assets/' + _decoded["id"]),
    //                       fit: BoxFit.contain,
    //                     ),
    //                   ),
    //                     ),
    //                   );
  }
}

class Stickers extends CustomPainter {
  Stickers({
    this.text,
    this.x,
    this.y,
  });
  final String text;
  final double x;
  final double y;

  @override
  void paint(Canvas canvas, Size size) {
    TextSpan span = new TextSpan(
        text: text,
        style: new TextStyle(
            color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold));
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
    // TODO: implement shouldRepaint
    if (oldDelegate.text != text) {
      print(">>>>>>>>>>>>>>>>>>$text");
      return true;
    } else {
      print(">>>>>>>>>>>>>>${oldDelegate.text}");
      return false;
    }
  }
}
