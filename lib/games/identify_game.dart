import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:maui/components/responsive_grid_view.dart';

Map _decoded;
List<String> oldData = [];
int i = 0;

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
      List<Widget> _paint = [];

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
    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
  

  
  void _renderChoice(String text, double X, double Y) {
    setState(() {
      _paint.add(new Paint(paste: text, x: X, y: Y,));
    });
  }

  
  Widget _buildPaint(int i, Widget w){
    return new Container(
      child: w,
    );
  }

  List<Widget> _createTextPaint(BuildContext context){
    int i=0;
    return _paint.map((f) => _buildPaint(i++,f)).toList(growable: false);
  }

  Widget _builtButton(
      BuildContext context, double maxHeight, double maxWidth, int cols) {
    print((_decoded["parts"] as List).length);
    int j = 0;
    int r = ((_decoded["parts"] as List).length / cols +
            ((((_decoded["parts"] as List).length % cols) == 0) ? 0 : 1))
        .toInt();
    print(r);
    return new ResponsiveGridView(
      rows: r,
      cols: cols,
      children: (_decoded["parts"] as List)
          .map((e) => _buildItems(j++, e, maxHeight, maxWidth, cols,))
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
    _imgController.dispose();
    // SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("List of all paintings to be done : $_paint");
    print(_buildPartsList());
    Orientation orientation = MediaQuery.of(context).orientation;
    int cols = orientation == Orientation.landscape ? 7 : 5;
    return new LayoutBuilder(builder: (context, constraint) {
      return new Scaffold(
        body: new Flex(
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
                  decoration: new BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: new Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      new ScaleTransition(
                        scale: animateImage,
                        child: new AspectRatio(
                          aspectRatio: 1.0,
                                                  child: new Image(
                            image: AssetImage('assets/' + _decoded["id"]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
        ),
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

  var part;
  int _flag = 0;
  double maxHeight;
  double maxWidth;
  int cols;
  Function render;

  static List<String> _buildPartsList() {
    List<String> partsName = [];
    for (var i = 0; i < (_decoded["parts"] as List).length; i++) {
      partsName.add((_decoded["parts"] as List)[i]["name"]);
    }
    return partsName;
  }

  final List<String> data = _buildPartsList();

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

    return new ScaleTransition(
      scale: shakeAnimation,
      child: new GestureDetector(
        onHorizontalDragStart: (DragStartDetails start) =>
            _onDragStart(context, start),
        onHorizontalDragUpdate: (DragUpdateDetails update) =>
            _onDragUpdate(context, update),
        onVerticalDragStart: (DragStartDetails start) =>
            _onDragStart(context, start),
        onVerticalDragUpdate: (DragUpdateDetails update) =>
            _onDragUpdate(context, update),
        child: new Draggable(
          data: part["name"],
          child: new AnimatedDrag(
              cols: cols,
              height: maxHeight,
              width: maxWidth,
              animation: (_flag == 0) ? noanimation : animation,
              draggableColor: Theme.of(context).buttonColor,
              draggableText: part["name"]),
          feedback: new AnimatedFeedback(
              height: maxHeight,
              width: maxWidth,
              animation: animation,
              draggableColor: Theme.of(context).disabledColor,
              draggableText: part["name"]),
          onDraggableCanceled: (velocity, offset) {
            double hRatio = ((3 * maxHeight) / (4 * part["data"]["height"]));
            double wRatio = (maxWidth / part["data"]["width"]);
            // print(">>>>this is height ratio $hRatio");
            // print(">>>>>>>> this is width ratio $wRatio");
            // print(
            //     ">>>>>>>>>>>>> $maxHeight >>>>>>>>>>>>> $maxWidth>>>>>> from layout builder");
            // print("!@#^&*(^&*...this inside draggable cancelled.... $part");

            // print(
            //     "j fbifiugiqibh76r498y1985..here is the off set on the screen");
            // print(offset.dx);
            // print(offset.dy);

            // if (part["name"] == "face" &&
            //     (offset.dx > 360.0 && offset.dx < 480.0) &&
            //     (offset.dy > 140.0 && offset.dy < 250.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(i);
            //   print((oldData as List).length);
            //   int s = 0;
            //   if (i < data.length) {
            //     print("under first if");
            //     for (var d in (oldData as List)) {
            //       if (d == part["name"]) {
            //         print("object");
            //         s = 1;
            //         break;
            //       }
            //       print("under for");
            //     }
            //     if (s == 1) {
            //       print("ssssss111");
            //       s = 0;
            //     } else {
            //       print("ssss0000");
            //       (oldData as List).add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            // } else if (part["name"] == "upper body" &&
            //     (offset.dx > 336.0 && offset.dx < 480.0) &&
            //     (offset.dy > 250.0 && offset.dy < 480.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print((oldData as List));
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render2(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "right hand" &&
            //     (offset.dx > 260.0 && offset.dx < 310.0) &&
            //     (offset.dy > 300.0 && offset.dy < 540.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render3(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "left hand" &&
            //     (offset.dx > 430.0 && offset.dx < 530.0) &&
            //     (offset.dy > 300.0 && offset.dy < 540.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render4(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "left leg" &&
            //     (offset.dx > 392.0 && offset.dx < 520.0) &&
            //     (offset.dy > 620.0 && offset.dy < 820.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render5(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "right leg" &&
            //     (offset.dx > 220.0 && offset.dx < 392.0) &&
            //     (offset.dy > 620.0 && offset.dy < 820.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render6(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "right palm" &&
            //     (offset.dx > 200.0 && offset.dx < 305.0) &&
            //     (offset.dy > 510.0 && offset.dy < 600.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render7(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "left palm" &&
            //     (offset.dx > 480.0 && offset.dx < 550.0) &&
            //     (offset.dy > 510.0 && offset.dy < 620.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render8(part["name"], offset.dx, offset.dy - 150.0);
            // } else if (part["name"] == "left foot" &&
            //     (offset.dx > 372.0 && offset.dx < 470.0) &&
            //     (offset.dy > 835.0 && offset.dy < 930.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render9(part["name"], offset.dx + 10.0, offset.dy - 150.0);
            // } else if (part["name"] == "right foot" &&
            //     (offset.dx > 256.0 && offset.dx < 372.0) &&
            //     (offset.dy > 835.0 && offset.dy < 930.0)) {
            //   print(">>>>>>>>>${data.length}");
            //   print(oldData);
            //   print(i);
            //   int s = 0;
            //   if (i < data.length) {
            //     for (String d in oldData) {
            //       if (d == part["name"]) {
            //         s = 1;
            //         break;
            //       }
            //     }
            //     if (s == 1) {
            //       s = 0;
            //     } else {
            //       oldData.add(part["name"]);
            //       i += 1;
            //       render(part["name"], offset.dx, offset.dy - 150.0);
            //       widget.onScore(1);
            //       if (i == 10) {
            //         widget.onEnd();
            //       }
            //     }
            //   }
            //   // render10(part["name"], offset.dx, offset.dy - 150.0);
            // } else {
            //   widget.onScore(-1);
            //   _flag = 1;
            //   toAnimateFunction();
            //   new Future.delayed(const Duration(milliseconds: 1000), () {
            //     setState(() {
            //       // render("", 0.0, 0.0);
            //       _flag = 0;
            //     });
            //     controller.stop();
            //   });
            // }
            render(part["name"], offset.dx, offset.dy - 150.0);
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
    // Size media = MediaQuery.of(context).size;
    // double _height = media.height;
    // double _width = media.width;
    final Animation<double> animation = listenable;
    return new Container(
      // width: _width * 0.15,
      // // height: _height * 0.06,
      // padding: new EdgeInsets.all( width * 0.015),
      color: draggableColor.withOpacity(0.5),
      child: new Center(
        child: new Text(
          draggableText,
          style: new TextStyle(
            color: Theme.of(context).highlightColor,
            decoration: TextDecoration.none,
            fontSize: width * 0.03,
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
    int r = ((_decoded["parts"] as List).length / cols +
            ((((_decoded["parts"] as List).length % cols) == 0) ? 0 : 1))
        .toInt();
    // double _height = media.height;
    // double _width = media.width;
    final Animation<double> animation = listenable;
    double translateX = animation.value;
    print("value: $translateX");
    return new Transform(
      transform: new Matrix4.translationValues(translateX, 0.0, 0.0),
      child: new Container(
        width: width / cols,
        height: height / r,
        // padding: new EdgeInsets.all( width * 0.01 ),
        // margin: new EdgeInsets.symmetric(
        //   vertical:  width * 0.005,
        //   horizontal: width * 0.005,
        // ),
        color: draggableColor,
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
      ),
    );
  }
}

class Stickers extends CustomPainter {
  Stickers({this.text, this.x, this.y,});
  final String text;
  final double x;
  final double y;
  // final double width;
  // final double height;

  @override
  void paint(Canvas canvas, Size size) {
    TextSpan span = new TextSpan(
        text: text,
        style: new TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold));
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
    if (oldDelegate.text != text) {
      print(">>>>>>>>>>>>>>>>>>$text");
      return true;
    } else {
      print(">>>>>>>>>>>>>>${oldDelegate.text}");
      return false;
    }
  }
}

class Paint extends StatelessWidget {
  Paint({this.paste, this.x, this.y});
  final double x, y;
  final String paste;
  @override
  Widget build(BuildContext context) {
    return new RepaintBoundary(
      child: new CustomPaint(
        painter:
            new Stickers(text: paste, x: x, y: y,),
      ),
    );
  }
}
