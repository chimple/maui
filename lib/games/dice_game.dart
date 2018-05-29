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
      this.isRotated = false,
      this.gameConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new DiceGameState();
}

enum Stext1 { Active, Visible }
enum Stext2 { Right, InActive }
enum Statuses { right, wrong }

class DiceGameState extends State<Dice> with SingleTickerProviderStateMixin {
  var flag1 = 0;
  var correct = 0;

  var keys = 0;
  static List<String> data = [
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

    static List<String> data1 = [
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
  List<Stext1> _status1 = [];
  List<Stext2> _status2 = [];
  List<Statuses> _statusList;

  List<String> diceData = ['1', '2', '3', '4', '5', '6'];
  List _sortletters = [];
  bool _isLoading = true;
  List<int> dice_tries = [];
  int code, dindex, dcode;
  List<String> arr = new List<String>();
  String _counter = "";
  String _counter1 = "1";
  String _counter2 = "";
  int count = 0;
  int count1 = 0;
  int flag = 0;

  AnimationController animation;

  @override
  void initState() {
    super.initState();
    _initBoard();
    animation = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 3),
    );
    animation.addListener(() {
      this.setState(() {});
    });
    _statusList = [];
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
  }

  Widget _playerKeyBoard(BuildContext context, double buttonPadding, String player) {

    if(player == "player1"){
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
    }else if(player == "player2"){
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
          var btnVal=-1,sum=0,sub=0;
          if(text != '' && dice_tries.length == 2){
            btnVal = int.parse(text);
            sum = dice_tries[0] + dice_tries[1];
            sub = dice_tries[0] - dice_tries[1];
          }
            print({"manu um": sum});
            print({"manu sub": sub});
          if (sub < 0) {
            sub = -sub;
            print({"manu sub": sub});
          }
          
          var userControl = false;
          if(flag == 0 && player == "player1"){
            userControl = true;
          }else if(flag == 1 && player == "player2"){
              userControl = true;
          }


          if (userControl) {
            print({"hurry , you are correct user to access keyboard" : player});
            if (btnVal == sum) {
              count = 0;
              dice_tries.removeRange(0, dice_tries.length);
              _counter = " ";
              _counter1 = " ";
              _counter2 = " ";
              sum = 0;
              sub = 0;
            
              if (flag == 0) {
                data[index] = '';
                flag = 1;
              } else {
                data1[index] = '';
                flag = 0;
              }
            } else if (sub == btnVal) {
              count = 0;
              dice_tries.removeRange(0, dice_tries.length);
              _counter = " ";
              _counter1 = " ";
              _counter2 = " ";
              sub = 0;
              sum = 0;
              if (flag == 0) {
                data[index] = '';
                flag = 1;
              } else {
                data1[index] = '';
                flag = 0;
              }
            }
          }
          print("hellow manuuuu $text");
        });
      },
    );
  }

  void _randomVal() {
    setState(() {
      animation.forward(from: 0.0);
      if (flag == 0) {
        if (count <= 1) {
          count = count + 1;
          final _random = new Random();
          var dElement = diceData[_random.nextInt(diceData.length)];

          var randval = int.parse(dElement);
          dice_tries.add(randval);
          _counter1 = dElement;
          _counter = "$_counter" + "$dElement" + ",";
          print("dice data $_counter ");
        }
      } else {
        if (count <= 1) {
          count = count + 1;
          final _random = new Random();
          var dElement = diceData[_random.nextInt(diceData.length)];

          var randval = int.parse(dElement);
          dice_tries.add(randval);
          _counter1 = dElement;
          _counter2 = "$_counter2" + "$dElement" + ",";
          print("dice data $_counter2 ");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / 6;

      double maxHeight = (constraints.maxHeight - vPadding * 2) / 6;

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 2, maxWidth, maxHeight);
      AppState state = AppStateContainer.of(context).state;

      return new Container(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          color: Colors.white,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: _playerKeyBoard(context, buttonPadding, "player1"),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        height: media.size.height > media.size.width
                            ? constraints.maxHeight * .08
                            : constraints.maxHeight * .1,
                        width: media.size.height < media.size.width
                            ? constraints.maxWidth * .1
                            : constraints.maxWidth * .2,
                        color: Colors.red,
                        margin: EdgeInsets.only(right: 20.0),
                        child: new Center(
                            child: new Text("$_counter",
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 25.0)))),
                    new InkWell(
                        onTap: _randomVal,
                        child: new Container(
                          height: media.size.height > media.size.width
                              ? constraints.maxHeight * .15
                              : constraints.maxHeight * .2,
                          width: media.size.height < media.size.width
                              ? constraints.maxWidth * .15
                              : constraints.maxWidth * .2,
                          child: new Image(
                              image: new AssetImage(
                            animation.isAnimating
                                ? 'assets/dice_game/dice2.gif'
                                : 'assets/dice_game/$_counter1.png',

                          )),
                        )),
                    new Container(
                        height: media.size.height > media.size.width
                            ? constraints.maxHeight * .08
                            : constraints.maxHeight * .1,
                        width: media.size.height < media.size.width
                            ? constraints.maxWidth * .1
                            : constraints.maxWidth * .2,
                        color: Colors.blue,
                        margin: EdgeInsets.only(left: 20.0),
                        child: new Center(
                            child: new Text("$_counter2",
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 25.0)))),
                  ]),
              new Expanded(
                child: _playerKeyBoard(context, buttonPadding, "player2"),
              ),
            ],
          ));
    });
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
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
