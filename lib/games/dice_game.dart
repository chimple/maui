import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
// import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

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
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DiceGameState();
}

class DiceGameState extends State<Dice> with SingleTickerProviderStateMixin {
  var correct = 0;
  var keys = 0;
  static List<String> data;

  static List<String> data1;
  List<String> diceData = ['1', '2', '3', '4', '5', '6'];
  // List _sortletters = [];
  bool _isLoading = true;
  List<int> dice_tries = [];
  // int code, dindex, dcode;
  List<String> arr = new List<String>();
  String _counter = " ";
  String _counter1 = " ";
  String _counter2 = " ";
  int count = 0;
  int count1 = 0;
  int flag = 0;
  var _currentIndex = 0;
  var _currentIndex1 = 0;
  var _currentIndex2 = 0;

  AnimationController animation;

  @override
  void initState() {
    super.initState();
    _initBoard();
    animation = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 400),
    );
    animation.addListener(() {
      this.setState(() {});
    });
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    data = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
    data1 = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  }

  @override
  void didUpdateWidget(Dice oldWidget) {
    if (widget.iteration != oldWidget.iteration) {
      // _initBoard();
    }
  }

  Widget _playerKeyBoard(
      BuildContext context, double buttonPadding, String player) {
    if (player == "player1") {
      var j = 0;
      return new ResponsiveGridView(
        rows: 2,
        cols: 6,
        children: data
            .map((e) => Padding(
                padding: EdgeInsets.all(buttonPadding),
                child: _buildItem(j++, e, player)))
            .toList(growable: false),
      );
    } else if (player == "player2") {
      var j = 0;
      return new ResponsiveGridView(
        rows: 2,
        cols: 6,
        children: data1
            .map((e) => Padding(
                padding: EdgeInsets.all(buttonPadding),
                child: _buildItem(j++, e, player)))
            .toList(growable: false),
      );
    }
  }

  Widget _buildItem(int index, String text, String player) {
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      text: text,
      player: player,
      color1: 1,
      onPress: () {
        count1 = count1 + 1;
        setState(() {
          print({"player status : ": player});
          print({"key index value : ": index});
          var btnVal = -1, sum = 0, sub = 0, i = 0;
          if (text != '' && dice_tries.length == 2) {
            btnVal = int.parse(text);
            sum = dice_tries[0] + dice_tries[1];
            sub = dice_tries[0] - dice_tries[1];
          }
          print({"manu sum": sum});
          print({"manu sub real": sub});
          if (sub < 0) {
            sub = -sub;
            print({"manu sub": sub});
          }

          var userControl = false;
          if (flag == 0 && player == "player1") {
            userControl = true;
            _currentIndex1++;
          } else if (flag == 1 && player == "player2") {
            userControl = true;
            _currentIndex2++;
          }
          if (userControl) {
            print({"hurry , you are correct user to access keyboard": player});
            for (i = 0; i < data.length; i++) {
              if (btnVal == sum || btnVal == sub) {
                _currentIndex++;
                widget.onScore(2);
                widget.onProgress(_currentIndex / data.length);
                if ( _currentIndex1 >= data.length-1 || _currentIndex2 >= data1.length-1) {
              new Future.delayed(const Duration(milliseconds: 250), () {
                widget.onEnd();
              });
            
          } 
          // else {
          //   widget.onScore(-1);
          // }
                resetDice();
                sum = 0;
                sub = 0;

                if (flag == 0) {
                  data[index] = '';
                  flag = 1;
                } else {
                  data1[index] = '';
                  flag = 0;
                }
              }
            }
          }
          print("hellow manuuuu $text");
        });
      },
    );
  }

  void resetDice() {
    count = 0;
    dice_tries.clear();
    _counter = " ";
    _counter1 = " ";
    _counter2 = " ";
  }

  void _randomVal() {
    setState(() async {
      animation.forward(from: 0.0);
      if (flag == 0) {
        if (count <= 1) {
          count = count + 1;
          final _random = new Random();
          var dElement = diceData[_random.nextInt(diceData.length)];

          var randval = int.parse(dElement);
          if (dice_tries.length < 2) dice_tries.add(randval);

          await new Future.delayed(const Duration(milliseconds: 200));
          displayLabel(dElement);

          print("dice data $_counter ");
          if (dice_tries.length == 2) {
            var sum = dice_tries[0] + dice_tries[1];
            var sub = dice_tries[0] - dice_tries[1];
            var matched = false;
            for (int i = 0; i < data.length; i++) {
              if (data[i] != '') if (int.parse(data[i]) == sum ||
                  int.parse(data[i]) == sub) {
                matched = true;
              }
            }
            if (matched != true) {
              _counter1 = " ";
              popup();
              await new Future.delayed(const Duration(milliseconds: 200));
              flag = 1;
              resetDice();
            }
          }
        }
      } else {
        if (count <= 1) {
          count = count + 1;
          final _random = new Random();
          var dElement = diceData[_random.nextInt(diceData.length)];

          var randval = int.parse(dElement);
          if (dice_tries.length < 2) dice_tries.add(randval);

          // new Timer(const Duration(milliseconds: 5000),displayLabel(dElement));
          await new Future.delayed(const Duration(milliseconds: 200));
          displayLabel(dElement);
          print("dice data $_counter2 ");

          if (dice_tries.length == 2) {
            var sum = dice_tries[0] + dice_tries[1];
            var sub = dice_tries[0] - dice_tries[1];
            var matched = false;
            for (int i = 0; i < data.length; i++) {
              if (data1[i] != '') if (int.parse(data1[i]) == sum ||
                  int.parse(data1[i]) == sub) {
                matched = true;
              }
            }
            if (matched != true) {
              _counter1 = " ";
              popup();
              await new Future.delayed(const Duration(milliseconds: 200));
              flag = 0;
              resetDice();
            }
          }
        }
      }
    });
  }

  displayLabel(String dElement) {
    if (flag == 0) {
      _counter1 = dElement;
      _counter = " ";
      for (int i = 0; i < dice_tries.length; i++) {
        _counter = _counter + dice_tries[i].toString() + "  ";
      }
    } else {
      _counter1 = dElement;
      _counter2 = " ";
      for (int i = 0; i < dice_tries.length; i++) {
        _counter2 = _counter2 + dice_tries[i].toString() + "  ";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / 6;

      double maxHeight = (constraints.maxHeight - vPadding * 2) / 2;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 2, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;
      var dval;
      if (_counter1 != " ") {
        dval = _counter1;
      } else {
        dval = flag == 0 ? "tapme" : "tapme1";
      }

      return new Container(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          color: Colors.black12,
          child: new Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: flag == 0
                    ? _playerKeyBoard(context, buttonPadding, "player1")
                    : _playerKeyBoard(context, buttonPadding, "player2"),
              ),
              new Container(
                  height: media.size.height > media.size.width
                      ? constraints.maxHeight * .08
                      : constraints.maxHeight * .08,
                  width: media.size.height < media.size.width
                      ? constraints.maxWidth * .1
                      : constraints.maxWidth * .2,
                  color: flag == 0 ? Colors.red : Colors.blue,
                  child: new Center(
                      child: new Text(flag == 0 ? "$_counter" : "$_counter2",
                          style: new TextStyle(
                              color: Colors.black, fontSize: 25.0)))),
              new InkWell(
                  onTap: _randomVal,
                  child: new Container(
                    height: media.size.height > media.size.width
                        ? constraints.maxHeight * .3
                        : constraints.maxHeight * .35,
                    width: media.size.height < media.size.width
                        ? constraints.maxWidth * .3
                        : constraints.maxWidth * .35,
                    child: new Image(
                        image: new AssetImage(
                      animation.isAnimating
                          ? 'assets/dice_game/dice1.gif'
                          : 'assets/dice_game/$dval.png',
                    )),
                  )),
            ],
          ));
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  popup() {
    var color = flag == 0 ? Colors.red : Colors.blue;
    return showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
            // title: new Text('Dicegame'),
            content: Text(
          "Bad luck",
          style: TextStyle(color: color, fontWeight: FontWeight.w900),
        ));
      },
    );
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
      this.player,
      this.isRotated,
      this.img,
      this.onPress,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  String player;
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
    return new ScaleTransition(
        scale: animation,
        child: new Container(
            child: new UnitButton(
          onPress: widget.onPress,
          text: widget.text,
          unitMode: UnitMode.text,
        )));
  }
}
