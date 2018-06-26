import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import '../components/shaker.dart';
import 'package:maui/repos/game_data.dart';
// import '../components/Sticker.dart';

Map _decoded;

class GuessIt extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  bool isRotated;

  GuessIt(
      {Key key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false})
      : super(key: key);

  @override
  _GuessItState createState() => new _GuessItState();
}

class _GuessItState extends State<GuessIt> with TickerProviderStateMixin {
  List<AnimationController> _textControllers = new List<AnimationController>();
  List<Animation<double>> _animateText = new List<Animation<double>>();
  bool _isLoading = true;
  List<Widget> _paint = [];
  List<String> partsName = [];
  int _length = 0;

  void _renderChoice(String text, double X, double Y, double height,
      double width, Orientation orientation) {
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

  List<String> _buildPartsList() {
    List<String> parts=[];
    for (var i = 0; i < (_decoded["parts"] as List).length; i++) {
      partsName.add((_decoded["parts"] as List)[i]["name"]);
    }
    return parts;
  }

  final TextEditingController _textController = new TextEditingController();
  String _guess = '';
  int _flag = 0;

  AnimationController controller, _imgController;
  Animation<double> animation, noanimation, animateImage;

  // final FocusNode _focusnode = new FocusNode();

  void toAnimateFunction() {
    animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
      print(animation.value);
    });
    controller.forward();
  }

  void _validate(double height, double width, Orientation orientation) {
    double h1, w1, h, w, rh, rw, x, y;
    // print("before trimming $_guess");
    // _guess.trim();
    // print("after trimming $_guess");
    if (orientation == Orientation.portrait) {
      h = (height * 3 * 9) / 40;
      w = (width * 4) / 5;
    } else {
      h = (height * 3 * 49) / 200;
      w = width / 2;
    }
    rh = h / _decoded["height"];
    rw = w / _decoded["width"];
    h1 = (((height * 3) / 4) - h) / 2;
    w1 = (width - w) / 2;
    if (partsName.indexOf(_guess) != -1) {
      // int i = 0;
      partsName.remove(_guess);
      // print(i);
      print(partsName);
      _textController.text = '';
      widget.onScore(1);
      // _length = _length - 1;
      // while (i < partsName.length) {
      //   if (_guess == _decoded["parts"][i]["name"]) {
      //     print(_decoded["parts"][i]["name"]);
      //     // y = rh * _decoded["parts"][i]["data"]["y"];
      //     // x = rw * _decoded["parts"][i]["data"]["x"];

      //     print(h1 + y);
      //     print(w1 + x);
      //     break;
      //   } else {
      //     i = i + 1;
      //   }
      // }
      _renderChoice(_guess, w1, h1, height, width, orientation);
      new Future.delayed(const Duration(milliseconds: 1000), () {
        if (partsName.isEmpty) {
          widget.onEnd();
        }
      });
    } else {
      print("this is th elist of parts $partsName");
      this.setState(() {
        _flag = 1;
        toAnimateFunction();
        new Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _flag = 0;
          });
          // print(animation.value);
          // print(noanimation.value);
          _textController.text = '';
          controller.stop();
        });
      });
    }
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    // String jsonGameInfo = await fetchGuessData();

    _decoded = await json.decode(await fetchGuessData());
    new Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        for (var i = 0; i < _decoded["number"]; i++) {
          _textControllers.add(new AnimationController(
              vsync: this, duration: new Duration(milliseconds: 500)));
          _animateText.add(new CurvedAnimation(
              parent: _textControllers[i], curve: Curves.elasticOut));
        }
        _length = _decoded["number"];
        _imgController.forward();
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initBoard();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation = new Tween(begin: -3.0, end: 3.0).animate(controller);

    // animation.addListener(() {
    //   setState(() {});
    // });
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(controller);
    _imgController = new AnimationController(
        duration: new Duration(
          milliseconds: 800,
        ),
        vsync: this);
    animateImage =
        new CurvedAnimation(parent: _imgController, curve: Curves.bounceInOut);
  }

  @override
  void didUpdateWidget(GuessIt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _paint = [];
      _textControllers = [];
      _animateText = [];
      _initBoard();
      _length = 0;
      partsName = [];
    }
  }

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

  @override
  void dispose() {
    super.dispose();
    _imgController.dispose();
    _textController.dispose();
    controller.dispose();
    for (var i = 0; i < _decoded["number"]; i++) {
      _textControllers[i].dispose();
    }
    // _focusnode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(partsName.isEmpty){
      partsName = _buildPartsList();
    }
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    // FocusScope.of(context).requestFocus(_focusnode);
    // ThemeData themeData = Theme.of(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    Size media = MediaQuery.of(context).size;
    // double _height = media.height;
    // double _width = media.width;
    return new LayoutBuilder(builder: (context, constraint) {
      return new Flex(direction: Axis.vertical, children: <Widget>[
        new Expanded(
          flex: 3,
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
                    height: constraint.maxHeight,
                    width: constraint.maxWidth,
                    orientation: orientation),
                // new ScaleTransition(
                //   scale: animateImage,
                //   child: new Image(
                //     image: AssetImage('assets/' + _decoded["id"]),
                //     fit: BoxFit.contain,
                //   ),
                // ),
                new Stack(
                  children: _createTextPaint(context),
                )
              ],
            ),
          ),
        ),
        new Expanded(
          flex: 1,
          // height: (constraint.maxHeight) / 4,
          // width: constraint.maxWidth,
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Expanded(
                flex: 8,
                child: new Shake(
                  animation: (_flag == 0) ? noanimation : animation,
                  child: new TextField(
                    // focusNode: _focusnode,
                    // textAlign: TextAlign.center,
                    autofocus: false,
                    controller: _textController,
                    obscureText: false,
                    style: new TextStyle(color: Colors.black, fontSize: 25.0),
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "name what you see and press check",
                      hintStyle:
                          new TextStyle(color: Colors.blueGrey, fontSize: 15.0),
                      border: InputBorder.none,
                    ),
                    onChanged: (String str) {
                      _guess = str.toLowerCase();
                      print(_guess);
                    },
                  ),
                ),
              ),
              new Expanded(
                  flex: 2,
                  child: new RaisedButton(
                    key: new Key("checking"),
                    padding: new EdgeInsets.fromLTRB(0.0, 19.0, 0.0, 19.0),
                    child: new Text("Check"),
                    onPressed: () => _validate(
                        constraint.maxHeight, constraint.maxWidth, orientation),
                  ))
            ],
          ),
        ),
      ]);
    });
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
