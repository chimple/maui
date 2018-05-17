import 'dart:async' show Future;
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:maui/components/responsive_grid_view.dart';

// String test = '';
Map _decoded;


final key = new GlobalKey<_IdentifyGameState>();

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
    with SingleTickerProviderStateMixin {
      double x=0.0, y=0.0;
String paste='';
  AnimationController _imgController;

  Animation<double> animateImage;

  Future<String> _loadGameAsset() async {
    return await rootBundle.loadString("assets/imageCoordinatesInfoBody.json");
  }

  Future _loadGameInfo() async {
    String jsonGameInfo = await _loadGameAsset();
    print(jsonGameInfo);
    this.setState(() {
      _decoded = json.decode(jsonGameInfo);
    });
    print((_decoded["parts"] as List));
    // print(_decoded["id"]);
    // print(_decoded["height"]);
    // print(_decoded["width"]);
    // print(_decoded["parts"][0]["name"]);
    // _parserJsonForGame(jsonGameInfo);
  }

  // void _parserJsonForGame(String jsonString) {
  //   this.setState((){
  //     _decoded = json.decode(jsonString);
  //   });
  //   print(_decoded["id"]);
  //   print(_decoded["height"]);
  //   print(_decoded["width"]);
  //   print(_decoded["parts"][0]["name"]);
  // }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    this._loadGameInfo();
    _imgController = new AnimationController(
        duration: new Duration(
          milliseconds: 800,
        ),
        vsync: this);
    animateImage =
        new CurvedAnimation(parent: _imgController, curve: Curves.bounceInOut);
    _imgController.forward();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  _renderChoice(String text, double X, double Y){
    setState((){
      paste = text;
      x = X;
      y = Y;
    });
  }

  // List<String> list=['square','circle','hexagon','triangle','trapezium','rectangle','rhombus','paralleogram','rightangled'];
  Widget _builtButton(BuildContext context, double maxHeight, double maxWidth) {
    print((_decoded["parts"] as List).length);
    // print(list);
    int j = 0;
    int r = ((_decoded["parts"] as List).length / 5 +
            ((((_decoded["parts"] as List).length % 5) == 0) ? 0 : 1))
        .toInt();
    print(r);
    return new ResponsiveGridView(
      rows: r,
      cols: 5,
      // maxAspectRatio: 5.0,
      children: (_decoded["parts"] as List)
          .map((e) => _buildItems(j++, e, maxHeight, maxWidth))
          .toList(growable: false),
    );
  }

  List<String> _buildPartsList() {
    List<String> partsName = [];
    for (var i = 0; i < (_decoded["parts"] as List).length; i++) {
      partsName.add((_decoded["parts"] as List)[i]["name"]);
    }
    return partsName;
  }

  Widget _buildItems(int i, var part, double maxHeight, double maxWidth) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..this is when calling each drag box for each parts for building draggable widget .....$part");
    return new DragBox(
      render: _renderChoice,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      key: new ValueKey<int>(i),
      part: part,
    );

    // return new Text("data");
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

  // List<Widget> _buidlTarget(BuildContext context, double){
  //   List<Widget> dropTargetArea;
  //   List<String> parts = _buildPartsList();
  //   print(_buildPartsList());
  //   for (var i = 0; i < parts.length; i++) {
  //     dropTargetArea.add(new Positioned(

  //     ));
  //   }
  //   return dropTargetArea;

  // }

  @override
    void dispose() {
      // TODO: implement dispose
      _imgController.dispose();
      SystemChrome.setPreferredOrientations([]);
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    print("kjbgiqjbqgobgqoub............. ga gieh bibeqfi...");
    print(_buildPartsList());
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    print("height of screen from media is $_height ");
    print("width of screen from media is $_width");
    // var x = _decoded["parts"][0]["data"]["height"];
    // print("this is $x height in pixels");
    return new LayoutBuilder(builder: (context, constraint) {
      print("Height from layout builder.....${constraint.maxHeight}");
      print("Width from layout builder.....${constraint.maxWidth}");
      return new Flex(
        // mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        children: <Widget>[
          new Expanded(
            child: new GestureDetector(
              onHorizontalDragStart: (DragStartDetails start) =>
                  _onDragStart(context, start),
              onHorizontalDragUpdate: (DragUpdateDetails update) =>
                  _onDragUpdate(context, update),
              onVerticalDragStart: (DragStartDetails start) =>
                  _onDragStart(context, start),
              onVerticalDragUpdate: (DragUpdateDetails update) =>
                  _onDragUpdate(context, update),
              child: new Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  new Scaffold(
                    body: new Column(
                      children: <Widget>[
                        new ScaleTransition(
                          scale: animateImage,
                          child: new Container(
                            height: (constraint.maxHeight ) * 3 / 4,
                            width: constraint.maxWidth,
                            decoration: new BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                            ),
                            child: new Image(
                              image: AssetImage('assets/' + _decoded["id"]),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        new Container(
                            height: (constraint.maxHeight) / 4,
                            width: constraint.maxWidth,
                            decoration: new BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
                            child: _builtButton(context, constraint.maxHeight, constraint.maxWidth))

                        // new Expanded(
                        //   flex: 1,
                        //   child: new Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       new DragBox(_decoded["parts"][0]),
                        //       new DragBox( _decoded["parts"][1]),
                        //       new DragBox(_decoded["parts"][2]),
                        //       new DragBox(_decoded["parts"][3]),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  new RepaintBoundary(
                    child: new CustomPaint(
                      painter: new Stickers(
                        text: paste,
                        x: x,
                        y: y,
                        height: _height,
                        width: _width
                      ),
                      // isComplex: false,
                      // willChange: false,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class DragBox extends StatefulWidget {
  // final String label;
  // final Color itemColor;
  var part;
  double maxHeight;
  double maxWidth;
  Function render;

  DragBox({
    this.maxHeight,
    this.maxWidth,
    Key key,
    this.part,
    this.render
  }) : super(key: key);

  @override
  DragBoxState createState() => new DragBoxState();
}

class DragBoxState extends State<DragBox> with TickerProviderStateMixin {
  AnimationController controller, shakeController;
  Animation<double> animation, shakeAnimation, noanimation;

  // Color draggableColor;
  // String draggableText;
  var part;
  int _flag = 0;
  double maxHeight;
  double maxWidth;
  Function render;

  _onDragStart(BuildContext context, DragStartDetails start) {
    // print(start.globalPosition.toString());
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(start.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
  }

  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    // print(update.globalPosition.toString());
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(update.globalPosition);
    print(local.dx.toString() + "|" + local.dy.toString());
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
    // TODO: implement initState
    super.initState();

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
    // draggableColor = widget.itemColor;
    // draggableText = widget.label;
    // part = widget.part;
    // this.setState((){
    //   part = widget.part;
    //   maxHeight = widget.maxHeight;
    //   maxWidth = widget.maxWidth;
    // });
    part = widget.part;
    maxHeight = widget.maxHeight;
    maxWidth = widget.maxWidth;
    render = widget.render;

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
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    return new ScaleTransition(
      scale: shakeAnimation,
      child: new Draggable(
        data: part["name"],
        child: new AnimatedDrag(
            animation: (_flag == 0) ? noanimation : animation,
            draggableColor: Theme.of(context).buttonColor,
            draggableText: part["name"]),
        feedback: new AnimatedFeedback(
            animation: animation,
            draggableColor: Theme.of(context).disabledColor,
            draggableText: part["name"]),
        onDraggableCanceled: (velocity, offset) {
            double hRatio = ((3*maxHeight)/(4*part["data"]["height"]));
            double wRatio = (maxWidth/part["data"]["width"]);
            // print(((3*maxHeight)/(4*part["data"]["height"])));
            print(">>>>this is height ratio $hRatio");
            print(">>>>>>>> this is width ratio $wRatio");
            print(">>>>>>>>>>>>> $maxHeight >>>>>>>>>>>>> $maxWidth>>>>>> from layout builder");
            print("!@#^&*(^&*...this inside draggable cancelled.... $part");

            
              print("j fbifiugiqibh76r498y1985..here is the off set on the screen");
              print(offset.dx);
              print(offset.dy);
              if (false) {
              // position = offset;
              render(part["name"], offset.dx, offset.dy-150.0);
            } else {
              _flag = 1;
              toAnimateFunction();
              new Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                  render("", 0.0, 0.0);
                  _flag = 0;
                });
                controller.stop();
              });
            }

            // if (
            //     (offset.dx > 0.0 && offset.dx < 100.0) &&
            //     (offset.dy > 0.0 && offset.dy < 100.0)) {
            //   // position = offset;
            //   paste = part["name"];
            //   x = offset.dx;
            //   y = offset.dy;
            //   print(offset.dx);
            //   print(offset.dy);
            // } else if (
            //     (offset.dx > (_width - 130) && offset.dx < 370.0) &&
            //     (offset.dy > 0.0 && offset.dy < 120.0)) {
            //   // position = offset;
            //   paste = part["name"];
            //   x = offset.dx;
            //   y = offset.dy;
            //   print(offset.dx);
            //   print(offset.dy);
            // } else if (
            //     (offset.dx > 0.0 && offset.dx < 130.0) &&
            //     (offset.dy > 160.0 && offset.dy < 290.0)) {
            //   // position = offset;
            //   paste = part["name"];
            //   x = offset.dx;
            //   y = offset.dy;
            //   print(offset.dx);
            //   print(offset.dy);
            // } else if (
            //     (offset.dx > (_width - 110) && offset.dx < 370.0) &&
            //     (offset.dy > 170 && offset.dy < 290.0)) {
            //   // position = offset;
            //   paste = part["name"];
            //   x = offset.dx;
            //   y = offset.dy;
            //   print(offset.dx);
            //   print(offset.dy);
            // } else {
            //   _flag = 1;
            //   toAnimateFunction();
            //   new Future.delayed(const Duration(milliseconds: 1000), () {
            //     setState(() {
            //       x=0.0;
            //       y=0.0;
            //       paste='';
            //       _flag = 0;
            //     });
            //     controller.stop();
            //   });
            // }
        },
      ),
    );
  }
}

class AnimatedFeedback extends AnimatedWidget {
  AnimatedFeedback(
      {Key key,
      Animation<double> animation,
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;

  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    final Animation<double> animation = listenable;
    return new Container(
      // width: _width * 0.15,
      // height: _height * 0.06,
      padding: new EdgeInsets.all((_width > _height) ? _width * 0.01 : _width * 0.015),
      color: draggableColor.withOpacity(0.5),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
            color: Theme.of(context).highlightColor,
            decoration: TextDecoration.none,
            fontSize: (_width > _height) ? _width * 0.015 : _width * 0.03,
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
      this.draggableColor,
      this.draggableText})
      : super(key: key, listenable: animation);

  final Color draggableColor;
  final String draggableText;

  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    final Animation<double> animation = listenable;
    double translateX = animation.value;
    print("value: $translateX");
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: new Container(
        // width: _width * 0.15,
        // height: _height * 0.06,
        padding: new EdgeInsets.all((_width > _height) ? _width * 0.01 : _width * 0.015),
        margin: new EdgeInsets.symmetric(vertical: (_width > _height) ? _width * 0.005 : _width * 0.005, horizontal: (_width > _height) ? _width * 0.005 : _width * 0.005,),
        color: draggableColor,
        child: new Center(
          child: new Text(
            draggableText,
            style: new TextStyle(
              color: Theme.of(context).hintColor,
              decoration: TextDecoration.none,
              fontSize: (_width > _height) ? _width * 0.015 : _width * 0.03,
            ),
          ),
        ),
      ),
    );
  }
}


class Stickers extends CustomPainter {
  Stickers({this.text, this.x, this.y, this.height, this.width});
  final String text;
  final double x;
  final double y;
  final double width;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    TextSpan span = new TextSpan(
        text: text,
        style: new TextStyle(
            color: Colors.black, fontSize: (width > height) ? width * 0.015 : width * 0.03, fontWeight: FontWeight.bold));
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(x, y));
    //canvas.restore();
    canvas.save();
    // canvas.saveLayer(rect, new Paint());
  }

  @override
  bool shouldRepaint(Stickers oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
