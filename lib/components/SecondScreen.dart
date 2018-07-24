import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/flash_card.dart';
import '../components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import '../games/single_game.dart';
import 'package:maui/components/gameaudio.dart';

class SecondScreen extends StatefulWidget {
  String ans;
  int navVal;
  List choice;
  String jsonVal;
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  GameConfig gameConfig;
  bool isRotated;

  SecondScreen(
      this.ans,
      this.navVal,
      this.choice,
      this.jsonVal,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.gameConfig,
      this.isRotated);

  @override
  State createState() => new OptionState();
}

class OptionState extends State<SecondScreen> {
  bool _isLoading = true;
  List choice;
  int _size = 2;
  List<String> _ans = [];
  bool isCorrect;
  List<String> DrawData;
  List<String> ReceiveData;

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['myData'] = DrawData;
    data['otherData'] = ReceiveData;
    return data;
  }

  void fromJsonMap(Map<String, dynamic> data) {
    ReceiveData = data['myData'].cast<String>();
    DrawData = data['otherData'].cast<String>();
  }

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    // widget.navVal = 0;
    setState(() => _isLoading = true);
    print('gameData manuuuuuuuuuu : ${widget.gameConfig.gameData}');
    if (widget.gameConfig.gameData != null) {
      fromJsonMap(widget.gameConfig.gameData);
    } else {
      DrawData = [widget.jsonVal];
      ReceiveData = [];
    }
    for (var i = 0; i < _size; i++) {
      widget.choice
        ..forEach((e) {
          _ans.add(e);
        });
    }
    setState(() => _isLoading = false);
  }

  @override
  void didUpdateWidget(SecondScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  Widget _playerKeyBoard(BuildContext context, double buttonPadding) {
    var j = 0;
    return new ResponsiveGridView(
      rows: _size,
      cols: _size,
      children: _ans
          .map((e) => new Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: _buildItem(j++, e)))
          .toList(growable: false),
    );
  }

  Widget _buildItem(int index, String text) {
    print("text issssssssss $text");
    print("choice if b issssssssss ${widget.choice}");
    //  print("nav value iss ${widget.navVal}");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          if (text == widget.ans) {
            print("hiii manuu");
            print("hello rhis on end we are calling");
            widget.onScore(10);
            widget.onProgress(1.0);
            setState(() {
              widget.onEnd(toJsonMap(), false);
              widget.navVal = 0;
            });
          } else {
            widget.onScore(0);
            widget.onEnd(toJsonMap(), false);
          }
        });
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

    return new LayoutBuilder(builder: (context, constraints) {
      Orientation orientation = MediaQuery.of(context).orientation;
      var height = constraints.maxHeight;
      var width = constraints.maxWidth;
      var maxCharLength;
      final maxChars = (_ans != null
          ? _ans.fold(1,
              (prev, element) => element.length > prev ? element.length : prev)
          : 1);
      if (maxChars == 1) {
        maxCharLength = 3;
      } else {
        maxCharLength = maxChars;
      }
      var sizeOrientation =
          orientation == Orientation.portrait ? (_size + .2) : (_size + 1.5);
      print("this is where the its comming full");
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth =
          (constraints.maxWidth - hPadding * 2) / (sizeOrientation);
      double maxHeight =
          (constraints.maxHeight - vPadding * 2) / (sizeOrientation);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      print(
          "object horizantal padding....:$hPadding.....vpadding : ..$vPadding");
      print("object button padding ......:$buttonPadding");
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;

      // double fullwidthofscreen = _size * (maxWidth + buttonPadding + hPadding);

      double buttonarea = maxWidth * maxHeight;
      print("object....buttonarea .......:$buttonarea");
      UnitButton.saveButtonSize(context, maxCharLength, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      return Scaffold(
          body: orientation == Orientation.portrait
              ? Column(children: <Widget>[
                  new Container(
                      height: height > width ? height * 0.45 : height * .75,
                      width: width > height ? width * 0.6 : width * .95,
                      child: new DrawJsonImage(widget.jsonVal)),
                  new Expanded(
                    child: _playerKeyBoard(context, buttonPadding),
                  ),
                ])
              : new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  new Container(
                      height: height > width ? height * 0.5 : height * .5625,
                      width: width > height ? width * 0.45 : width,
                      child: new DrawJsonImage(widget.jsonVal)),
                  Expanded(
                    child: _playerKeyBoard(context, buttonPadding),
                  )
                ]));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress}) : super(key: key);

  final String text;
  final VoidCallback onPress;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
// print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
// print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
// print('dismissed');
          if (widget.text != null) {
            setState(() => _displayText = widget.text);
            controller.forward();
          }
        }
      });
    controller.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text == null && widget.text != null) {
      _displayText = widget.text;
      controller.forward();
    } else if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return new ScaleTransition(
        scale: animation,
        child: new GestureDetector(
            onLongPress: () {
              showDialog(
                  context: context,
                  child: new FractionallySizedBox(
                      heightFactor: 0.5,
                      widthFactor: 0.8,
                      child: new FlashCard(text: widget.text)));
            },
            child: new UnitButton(
              text: _displayText.toUpperCase(),
              onPress: () => widget.onPress(),
              // unitMode: UnitMode.text,
              showHelp: false,
            )));
  }
}

class DrawJsonImage extends StatefulWidget {
  String jsonVal;

  DrawJsonImage(this.jsonVal);

  @override
  State<StatefulWidget> createState() => new MyHomePageState();
}

class MyHomePageState extends State<DrawJsonImage> {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
        body: new Center(
            child: new Container(
      margin: orientation == Orientation.portrait
          ? EdgeInsets.only(top: 5.0)
          : EdgeInsets.only(left: 5.0),
      color: Colors.grey,
      child: new MyImagePage(widget.jsonVal),
    )));
  }
}

class MyImagePage extends StatefulWidget {
  String jsonVal;
  MyImagePage(this.jsonVal);

  @override
  State createState() => new MyDrawPageState();
}

class MyDrawPageState extends State<MyImagePage> {
// List<Offset> _points = [Offset(23.0, 54.0), Offset(44.0, 87.0)];
  DrawPainting currentPainter;

  @override
  Widget build(BuildContext context) {
// print({"the decoded value is : " : jsonVal});

    currentPainter = new DrawPainting(widget.jsonVal);

    return new Container(
      // margin: new EdgeInsets.all(5.0),
      child: new Card(
        child: new ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: new CustomPaint(
            painter: currentPainter,
          ),
        ),
      ),
    );
  }
}

class DrawPainting extends CustomPainter {
  String canvasProperty = null;

  DrawPainting(this.canvasProperty);

  void paint(Canvas canvas, Size size) {
    double _height = size.height;
    double _width = size.width;
    double _hsize = _height;
    double _wsize = _width;

    Paint paint = new Paint()..strokeCap = StrokeCap.round;

// print({"the canvasproperty value is : " : canvasProperty});

    var decode = json.decode(canvasProperty);

// print({"the json to obj value is fo pos : " : decode['draw'][0]['position'][0]['x']});
// print({"the lenth of draw : " : decode['draw'].length});

    for (int i = 0; i < decode['draw'].length; i++) {
      var draw = decode['draw'][i];

      for (int j = 0; j < draw['position'].length; j++) {
        var position = draw['position'];

        paint.strokeWidth = draw['width'];
        paint.color = new Color(draw['color']);

        if (position[j]['x'] != null && position[j + 1]['x'] != null) {
          Offset currentPixel = new Offset(
              ((position[j]['x']) * _wsize), ((position[j]['y']) * _hsize));

          Offset nextPixel = new Offset(((position[j + 1]['x']) * _wsize),
              ((position[j + 1]['y']) * _hsize));

          canvas.drawLine(currentPixel, nextPixel, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
