import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import '../components/shaker.dart';
import 'package:maui/repos/game_data.dart';
// import '../components/Sticker.dart';

Map _decoded;
int _length = 0;

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
  bool _isLoading = true;
  List<Widget> _paint = [];
  List<String> partsName = [];

  void _renderChoice(String text, double X, double Y) {
    setState(() {
      _paint.add(
        new CustomPaint(
          painter: new Stickers(
            text: text,
            x: X,
            y: Y,
          ),
        ),
      );
    });
  }

  Widget _buildPaint(int i, Widget w) {
    return new RepaintBoundary(
      child: w,
    );
  }

  List<Widget> _createTextPaint(BuildContext context) {
    int i = 0;
    return _paint.map((f) => _buildPaint(i++, f)).toList(growable: true);
  }
 
  List<String> _buildPartsList() {
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

  // Future<String> _loadGameAsset() async {
  //   return await rootBundle.loadString("assets/imageCoordinatesInfoBody.json");
  // }

  // Future _loadGameInfo() async {
  //   String jsonGameInfo = await _loadGameAsset();
  //   print(jsonGameInfo);
  //   this.setState(() {
  //     _decoded = json.decode(jsonGameInfo);
  //   });
  //   print(_decoded["id"]);
  //   print(_decoded["height"]);
  //   print(_decoded["width"]);
  //   print(_decoded["parts"][0]["name"]);
  //   // _parserJsonForGame(jsonGameInfo);
  // }

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
    // _controller.text = '';
    // _renderChoice(_guess, 350.0, 200.0);

    if (true) {
      print(_guess);
      _controller.text = '';
      widget.onScore(1);
      // _length = _length - 1;
      _renderChoice(_guess, 50.0, 100.0);
      new Future.delayed(const Duration(milliseconds: 1000),(){
              if(_length == 0){
                widget.onEnd();
              }
            });
    } else {
      this.setState(() {
        _flag = 1;
        toAnimateFunction();
        new Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _flag = 0;
          });
          // print(animation.value);
          // print(noanimation.value);
          _controller.text = '';
          controller.stop();
        });
      });
      // paste = '';
    }
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    String jsonGameInfo = await fetchGuessData();

    _decoded = json.decode(jsonGameInfo);
    new Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isLoading = false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initBoard();
    
    // print(_buildPartsList());
    // _length =partsName.length;
    // print(partsName.length);
    // print(_length);print("kgbibibhbhbhbjbbk bg$_length");
    controller = new AnimationController(
        duration: new Duration(milliseconds: 80), vsync: this);
    animation = new Tween(begin: -3.0, end: 3.0).animate(controller);

    animation.addListener(() {
      setState(() {});
    });
    noanimation = new Tween(begin: 0.0, end: 0.0).animate(controller);
    // this._loadGameInfo();
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
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    // FocusScope.of(context).requestFocus(_focusnode);
    // ThemeData themeData = Theme.of(context);
    Size media = MediaQuery.of(context).size;
    double _height = media.height;
    double _width = media.width;
    return new LayoutBuilder(builder: (context, constraint) {
      return new Scaffold(
        body: new Flex(direction: Axis.vertical, children: <Widget>[
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
                  new ScaleTransition(
                    scale: animateImage,
                    child: new Image(
                      image: AssetImage('assets/' + _decoded["id"]),
                      fit: BoxFit.contain,
                    ),
                  ),
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
