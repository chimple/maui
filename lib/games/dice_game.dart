import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';

class Dice extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Dice(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false,
      this.gameConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DiceGameState();
}

class DiceGameState extends State<Dice> {
  var flag1 = 0;
  var correct = 0;
  var keys = 0;
  List<String> data = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  List<String> _rightwords = [];
  List<String> diceData = ['1', '2', '3', '4', '5', '6'];
  List<String> _letters = new List();
  List<String> _data2 = new List();
  List<int> _data3 = new List();
  List<int> _flag = new List();
  List<String> _data1 = new List();
  List _sortletters = [];
  bool _isLoading = true;

//  String img , dragdata;
  int _rows, _cols, code, dindex, dcode;
  int len, _rightlen, _rightcols;
  List<String> arr = new List<String>();
  String _counter = "1";


  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
//    for(var i=0;i<99;i++)
//    {
//      arr.add("1");
//      print({"this is an array":arr});
//    }
  }

  Widget _buildItem(int index, String text) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        onPress: () {
          setState(() {
            print("hellow manuuuu $text");
          });
        },
        );
  }

  void _randomVal() {
    setState(() {
      final _random = new Random();
      var dElement = diceData[_random.nextInt(diceData.length)];
     _counter = dElement;
      print("dice data $_counter ");
    ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
    var j = 0, h = 0, k = 100;
    return new Container(
        color: Colors.blue[300],
        child: new Column(
          // portrait mode
          children: <Widget>[
            new Flexible(
              flex: 3,
              child: new ResponsiveGridView(
                rows: 2,
                cols: 6,
                maxAspectRatio: 1.0,
                children:
                    data.map((e) => _buildItem(j++, e)).toList(growable: false),
              ),
            ),
       new GestureDetector(
          onTap: _randomVal,
           child: new Container(
              height: constraints.maxHeight*.3, width: constraints.maxWidth*.3,
               decoration: new BoxDecoration(
                 color: const Color(0xFFF1F8E9),
                 boxShadow: [new BoxShadow(
                   color: Colors.green,
                   blurRadius: 5.0,
                 ),
                 ],
                 border: new Border.all(
                   color: Colors.black,
                   width: 5.0,
                 ),
               ),
              child: new Center(
              child: new Text('$_counter',
              style: new TextStyle(fontSize: 100.0))
            ))),
            new Flexible(
              flex: 3,
              child: new ResponsiveGridView(
                rows: 2,
                cols: 6,
                maxAspectRatio: 1.0,
                children:
                    data.map((e) => _buildItem(j++, e)).toList(growable: false),
              ),
            ),
          ],
        ));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.index,
      this.text,
      this.color1,
      this.flag,
      this.onAccepted,
      this.code,
      this.isRotated,
      this.img,
        this.onPress,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  final VoidCallback onPress;
  final DragTargetAccept onAccepted;
  final keys;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;
  String newtext = '';
  var f = 0;
  var i = 0;

  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate)
          ..addStatusListener((state) {});
    controller.forward();
    animation1 = new Tween(begin: -5.0, end: 5.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animation1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    MediaQueryData media = MediaQuery.of(context);
    return new ScaleTransition(
        scale: animation,
        child:new Container(
          height: 20.0, width: 100.0,
        child: new RaisedButton(
          onPressed: widget.onPress,
          child: new Text("$_displayText",
          style:new TextStyle( fontSize: 20.0),),
        )));
  }
}
