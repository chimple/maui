import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/flash_card.dart';
import 'package:tuple/tuple.dart';
import '../components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import '../games/single_game.dart';

class SecondScreen extends StatefulWidget {
  String jsonVal;
  List choice;
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  GameConfig gameConfig;
  bool isRotated;

  SecondScreen(
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
  Tuple3<String, String, List<String>> _allques;
  int _size = 2;
  // List<String> choice = ['Apple', 'Banana', 'Grape', 'Orange'];
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
    setState(() => _isLoading = true);
    print('gameData manuuuuuuuuuu sec: ${widget.gameConfig.gameData}');
    if (widget.gameConfig.gameData != null) {
      fromJsonMap(widget.gameConfig.gameData);
    } else {
      DrawData = [];
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
    // DrawData = {widget.jsonVal}
    // print("choice issssssssss ${choice[1]}");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        onPress: () {
          if (text == widget.choice[1]) {
            print("hiii manuu");
            widget.onScore(5);
            widget.onEnd(toJsonMap(), false);
            // widget.onProgress(1.0);
            // widget.onEnd();
            _initBoard();
          } else {
            widget.onScore(-1);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double ht = media.height;
    double wd = media.width;

    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }

    int j = 0;
    return new LayoutBuilder(builder: (context, constraints) {
      Orientation orientation = MediaQuery.of(context).orientation;
      var height = constraints.maxHeight;
      var width = constraints.maxWidth;
      var sizeOrientation = orientation == Orientation.portrait ? (_size+.5) : (_size+2);
      print("this is where the its comming full");
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);
      double maxWidth = (constraints.maxWidth - hPadding * 2) /(sizeOrientation);
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (sizeOrientation);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
      print(
          "object horizantal padding....:$hPadding.....vpadding : ..$vPadding");
      print("object button padding ......:$buttonPadding");
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;

      double fullwidthofscreen = _size * (maxWidth + buttonPadding + hPadding);

      double buttonarea = maxWidth * maxHeight;
      print("object....buttonarea .......:$buttonarea");
      UnitButton.saveButtonSize(context, 6, maxWidth, maxHeight);

      AppState state = AppStateContainer.of(context).state;
      return Scaffold(
        appBar: AppBar(title: new Text("manu"),),
          body: orientation == Orientation.portrait
              ? Column(children: <Widget>[
                  new Container(
                      height: height > width ? height * 0.45 : height * .75,
                      width: width > height ? width * 0.6 : width * .95,
                      child: new Drawing(widget.jsonVal)),
                  new Expanded(
                    child: _playerKeyBoard(context, buttonPadding),
                  ),
                ])
              : new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  new Container(
                      height: height > width ? height * 0.5 : height * .5625,
                      width: width > height ? width * 0.45 : width,
                      child: new Drawing(widget.jsonVal)),
                  Expanded(
                    child: _playerKeyBoard(context, buttonPadding),
                  )
                ]));
    });
  }
}

class QuestionText extends StatefulWidget {
  final String _question;

  QuestionText(this._question);

  @override
  State createState() => new QuestionTextState();
}

class QuestionTextState extends State<QuestionText>
    with SingleTickerProviderStateMixin {
  Animation<double> _fontSizeAnimation;
  AnimationController _fontSizeAnimationController;

  @override
  void initState() {
    super.initState();
    _fontSizeAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    _fontSizeAnimation = new CurvedAnimation(
        parent: _fontSizeAnimationController, curve: Curves.bounceOut);
    _fontSizeAnimation.addListener(() => this.setState(() {
          print(2);
        }));
    _fontSizeAnimationController.forward();
  }

  @override
  void dispose() {
    _fontSizeAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuestionText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._question != widget._question) {
      _fontSizeAnimationController.reset();
      _fontSizeAnimationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    double ht = media.height;
    double wd = media.width;
    return new Material(
      color: const Color(0xFF54cc70),
      child: new Container(
        height: ht * 0.22,
        width: wd * 0.6,
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(25.0),
          color: const Color(0xFFf8c43c),
          border: new Border.all(
            color: const Color(0xFF54cc70),
          ),
        ),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Text(widget._question,
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: ht > wd ? ht * 0.06 : wd * 0.06,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
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
              text: _displayText,
              onPress: () => widget.onPress(),
              // unitMode: UnitMode.text,
              showHelp: false,
            )));
  }
}

class Drawing extends StatefulWidget {
  String jsonVal;

  Drawing(this.jsonVal);

  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<Drawing> {
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
