import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import '../components/shaker.dart';
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

  double x1 = 0.0,
      y1 = 0.0,
      x2 = 0.0,
      y2 = 0.0,
      x3 = 0.0,
      y3 = 0.0,
      x4 = 0.0,
      y4 = 0.0,
      x5 = 0.0,
      y5 = 0.0,
      x6 = 0.0,
      y6 = 0.0,
      x7 = 0.0,
      y7 = 0.0,
      x8 = 0.0,
      y8 = 0.0,
      x9 = 0.0,
      y9 = 0.0,
      x10 = 0.0,
      y10 = 0.0;
  String paste1 = '',
      paste2 = '',
      paste3 = '',
      paste4 = '',
      paste5 = '',
      paste6 = '',
      paste7 = '',
      paste8 = '',
      paste9 = '',
      paste10 = '';

  List<String> _buildPartsList() {
    List<String> partsName = [];
    for (var i = 0; i < (_decoded["parts"] as List).length; i++) {
      partsName.add((_decoded["parts"] as List)[i]["name"]);
    }
    return partsName;
  }

  final TextEditingController _controller = new TextEditingController();
  String _guess = '';
  int _flag = 0;
  // double x, y = 0.0;
  // String paste = '';

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

  Future<String> _loadGameAsset() async {
    return await rootBundle.loadString("assets/imageCoordinatesInfoBody.json");
  }

  Future _loadGameInfo() async {
    String jsonGameInfo = await _loadGameAsset();
    print(jsonGameInfo);
    this.setState(() {
      _decoded = json.decode(jsonGameInfo);
    });
    print(_decoded["id"]);
    print(_decoded["height"]);
    print(_decoded["width"]);
    print(_decoded["parts"][0]["name"]);
    // _parserJsonForGame(jsonGameInfo);
  }

  // void drawName(Canvas context, String name, double x, double y) {
  //   TextSpan span = new TextSpan(
  //       style: new TextStyle(
  //           color: Colors.blue[800], fontSize: 24.0, fontFamily: 'Roboto'),
  //       text: name);
  //   TextPainter tp = new TextPainter(
  //       text: span,
  //       textAlign: TextAlign.left,
  //       textDirection: TextDirection.ltr);
  //   tp.layout();
  //   tp.paint(context, new Offset(x, y));
  // }

  void _validate() {
    if (_guess == _decoded["parts"][0]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x1 = 50.0;
        y1 = 100.0;
        paste1 = _guess;
      });
      // drawName(  , _guess, 50.0, 100.0);
    } else if (_guess == _decoded["parts"][1]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x2 = 250.0;
        y2 = 100.0;
        paste2 = _guess;
      });
    } else if (_guess == _decoded["parts"][2]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x3 = 150.0;
        y3 = 100.0;
        paste3 = _guess;
      });
    } else if (_guess == _decoded["parts"][3]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x4 = 200.0;
        y4 = 100.0;
        paste4 = _guess;
      });
    } else if (_guess == _decoded["parts"][4]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x5 = 250.0;
        y5 = 100.0;
        paste5 = _guess;
      });
    } else if (_guess == _decoded["parts"][5]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x6 = 250.0;
        y6 = 100.0;
        paste6 = _guess;
      });
    } else if (_guess == _decoded["parts"][6]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x7 = 250.0;
        y7 = 100.0;
        paste7 = _guess;
      });
    } else if (_guess == _decoded["parts"][7]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x8 = 250.0;
        y8 = 100.0;
        paste8 = _guess;
      });
    } else if (_guess == _decoded["parts"][8]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x9 = 250.0;
        y9 = 100.0;
        paste9 = _guess;
      });
    } else if (_guess == _decoded["parts"][9]["name"]) {
      print(_guess);
      _controller.text = '';
      this.setState(() {
        x10 = 250.0;
        y10 = 100.0;
        paste10 = _guess;
      });
    } else {
      this.setState(() {
        _flag = 1;
        toAnimateFunction();
        new Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            // x = 0.0;
            // y = 0.0;
            // paste = '';
            _flag = 0;
          });
          print(animation.value);
          print(noanimation.value);
          _controller.text = '';
          controller.stop();
        });
      });
      // paste = '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation = new Tween(begin: -3.0, end: 3.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(controller);
    this._loadGameInfo();
    _imgController = new AnimationController(
        duration: new Duration(
          milliseconds: 800,
        ),
        vsync: this);
    animateImage =
        new CurvedAnimation(parent: _imgController, curve: Curves.bounceInOut);
    _imgController.forward();
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
    _controller.dispose();
    controller.dispose();
    // _focusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context).requestFocus(_focusnode);
    // ThemeData themeData = Theme.of(context);
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    return new LayoutBuilder(builder: (context, constraint) {
      return new Scaffold(
        body: new Flex(direction: Axis.vertical, children: <Widget>[
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
                  new ScaleTransition(
                    scale: animateImage,
                    child: new Image(
                      image: AssetImage('assets/' + _decoded["id"]),
                      fit: BoxFit.contain,
                    ),
                  ),

                  // new Expanded(
                  //   flex: 1,
                  //   child: new Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       new RaisedButton(
                  //         key: new Key("checking"),
                  //         child: new Text("Check"),
                  //         onPressed: () => _validate(),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste1,
                              x: x1,
                              y: y1,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste2,
                              x: x2,
                              y: y2,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste3,
                              x: x3,
                              y: y3,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste4,
                              x: x4,
                              y: y4,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste5,
                              x: x5,
                              y: y5,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste6,
                              x: x6,
                              y: y6,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste7,
                              x: x7,
                              y: y7,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste8,
                              x: x8,
                              y: y8,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste9,
                              x: x9,
                              y: y9,
                              height: _height,
                              width: _width),
                        ),
                      ),
                      new RepaintBoundary(
                        child: new CustomPaint(
                          painter: new Stickers(
                              text: paste10,
                              x: x10,
                              y: y10,
                              height: _height,
                              width: _width),
                        ),
                      ),
                  // new RepaintBoundary(
                  //   child: new CustomPaint(
                  //     painter: new Stickers(
                  //       text: paste,
                  //       x: x,
                  //       y: y,
                  //     ),
                  //     isComplex: false,
                  //     willChange: false,
                  //   ),
                  // )
                  // new Positioned(
                  //   left: x,
                  //   top: y,
                  //   child: new Text(
                  //     paste,
                  //     style: new TextStyle(
                  //         fontSize: 20.0,
                  //         fontWeight: FontWeight.bold,
                  //         fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          new Container(
            height: (constraint.maxHeight) / 4,
            width: constraint.maxWidth,
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
                      controller: _controller,
                      obscureText: false,
                      style: new TextStyle(color: Colors.black, fontSize: 25.0),
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "name what you see and press check",
                        hintStyle: new TextStyle(
                            color: Colors.blueGrey, fontSize: 15.0),
                        border: InputBorder.none,
                      ),
                      onChanged: (String str) {
                        _guess = str.toLowerCase();
                        print(_guess);
                        // setState((){
                        //   _guess = str;
                        // });
                        // _controller.text = '';
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
                      onPressed: () => _validate(),
                    ))
              ],
            ),
          ),
        ]),
      );
    });
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
    TextSpan span = new TextSpan(
        text: text,
        style: new TextStyle(
            color: Colors.black,
            fontSize: (width > height) ? width * 0.015 : width * 0.03,
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
