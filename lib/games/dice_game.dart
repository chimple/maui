import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/games/single_game.dart';
// import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/components/Shaker.dart';
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

enum ShakeCell { Right, InActive, Dance, CurveRow }

class DiceGameState extends State<Dice> with SingleTickerProviderStateMixin {
  var correct = 0;
  var keys = 0;
  static List<String> data;

  static List<String> data1;
  List<String> diceData = ['1', '2', '3', '4', '5', '6'];
  bool _isLoading = true;
  List<int> dice_tries = [];
  List<int> originalDice = [];
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
  int scoretrack = 0;

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

  List<int> _shake = [];
  void _initBoard() async {
    _currentIndex = 0;
    setState(() => _isLoading = true);
    data = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
    data1 = ['12', '11', '10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
    for (int i = 0; i < 12; i++) {
      _shake.add(0);
    }
  }

  @override
  void didUpdateWidget(Dice oldWidget) {
    super.didUpdateWidget(oldWidget);
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
                child: _buildItem(j, e, player, _shake[j++])))
            .toList(growable: false),
      );
    } else {
      var j = 0;
      return new ResponsiveGridView(
        rows: 2,
        cols: 6,
        children: data1
            .map((e) => Padding(
                padding: EdgeInsets.all(buttonPadding),
                child: _buildItem(j, e, player, _shake[j++])))
            .toList(growable: false),
      );
    }
  }

  Widget _buildItem(int index, String text, String player, int tile) {
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      text: text,
      player: player,
      color1: 1,
      tile: tile,
      onPress: () {
        count1 = count1 + 1;
        setState(() {
          print({"player status : ": player});
          print({"key index value : ": index});
          print({"i am : ": text});
          var btnVal = -1, sum = 0, sub = 0;
          if (text != '' && dice_tries.length == 2) {
            btnVal = int.parse(text);
            sum = dice_tries[0] + dice_tries[1];
            sub = dice_tries[0] - dice_tries[1];
          }
          if (sub < 0) {
            sub = -sub;
            print({"manu sub": sub});
          }

          var userControl = false;
          if (flag == 0 && player == "player1") {
            userControl = true;
          } else if (flag == 1 && player == "player2") {
            userControl = true;
          }
          if (userControl) {
            print({"hurry , you are correct user to access keyboard": player});
            if (btnVal == sum || btnVal == sub) {
              _currentIndex++;
              widget.onScore(2);
              widget.onProgress(_currentIndex / data.length);
              // widget.onEnd();
              // if (_currentIndex >= data.length-2 ||
              //     _currentIndex2 >= data1.length-2) {
              //   print({"inside main current index : " : _currentIndex});
              //   new Future.delayed(const Duration(milliseconds: 250), () {
              //     widget.onEnd();
              //   });
              // }
              resetDice();
              sum = 0;
              sub = 0;

              if (flag == 0) {
                print({"$player data removed index : $data[$index]": index});
                setState(() {
                  data[index] = '';
                  flag = 1;
                });
                print("palayer 1 data iss $data");
              } else {
                print({"$player data1 removed index : $data1[$index]": index});
                setState(() {
                  data1[index] = '';
                  flag = 0;
                });
                print("player 2 data1 iss: $data1");
              }
            } else {
              if (flag == 0 && player == "player1") {
                _shake[index] = 1;
                new Future.delayed(const Duration(milliseconds: 800), () {
                  setState(() {
                    _shake[index] = 0;
                    widget.onScore(-1);
                  });
                });
              } else if (flag == 1 && player == "player2") {
                _shake[index] = 1;
                new Future.delayed(const Duration(milliseconds: 800), () {
                  setState(() {
                    _shake[index] = 0;
                    widget.onScore(-1);
                  });
                });
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
    originalDice.clear();
    _counter = " ";
    _counter1 = " ";
    _counter2 = " ";
  }

  void _randomVal() {
    setState(() async {
      animation.forward(from: 0.0);
      if (flag == 0) {
        // dice random logic for player 1
        if (count <= 1) {
          count = count + 1;
          String dElement = randomLogic(data);
          print({"the dElement data is : " : dElement});
          print({"the dice_tries data is : " : dice_tries});
          print({"the data is : " : data});
          var randval = int.parse(dElement);
          if (dice_tries.length < 2) dice_tries.add(randval);
          await new Future.delayed(const Duration(milliseconds: 200));
          displayLabel(dElement);

          // print("dice data $_counter ");
          if (dice_tries.length == 2) {
            var sum = dice_tries[0] + dice_tries[1];
            var sub = dice_tries[0] - dice_tries[1];
            if (sub < 0) sub = -sub;
            var matched = false;
            for (int i = 0; i < data.length; i++) {
              if (data[i] != '') if (int.parse(data[i]) == sum ||
                  int.parse(data[i]) == sub) {
                // print("the data isssssssssssssssssss $data");
                matched = true;
              }
            }
            if (matched != true) {
              // This is condition for change player and bad luck
              popup();
              await new Future.delayed(const Duration(seconds: 1));
              setState(() {
                _counter1 = " ";
                flag = 1;
                resetDice();
              });
            }
          }
        }
      } else {
        if (count <= 1) {
          // dice random logic for player 2
          count = count + 1;
          String dElement = randomLogic(data1);
          print({"the dElement data1 is : " : dElement});
          print({"the dice_tries data1 is : " : dice_tries});
          print({"the data1 is : " : data1});

          var randval = int.parse(dElement);
          if (dice_tries.length < 2) dice_tries.add(randval);

          await new Future.delayed(const Duration(milliseconds: 200));
          displayLabel(dElement);
          // print("dice data $_counter2 ");

          if (dice_tries.length == 2) {
            var sum = dice_tries[0] + dice_tries[1];
            var sub = dice_tries[0] - dice_tries[1];
            if (sub < 0) sub = -sub;
            var matched = false;
            for (int i = 0; i < data1.length; i++) {
              if (data1[i] != '') if (int.parse(data1[i]) == sum ||
                  int.parse(data1[i]) == sub) {
                matched = true;

                // print("the data1 is sssssssss $data1");
              }
            }
            if (matched != true) {
              popup();
              await new Future.delayed(const Duration(seconds: 1));
              // if we want to add time then use setState
              setState(() {
                _counter1 = " ";
                flag = 0;
                resetDice();
              });
            }
          }
        }
      }
    });
  }

  String randomLogic(List<String> data) {
    // final _random = new Random();
    // String dElement = diceData[_random.nextInt(diceData.length)];
    List<int> existingData = getExistingDataInInt(data);
    int randomExistingValue = existingData[new Random().nextInt(existingData.length)];
    String dElement = '';
    if(dice_tries.length == 0){
      int fValue, sValue;
      while(true){
        fValue = new Random().nextInt(6)+1;
        sValue = new Random().nextInt(6)+1;
        int sum = (fValue + sValue) , sub = (fValue - sValue);
        if(sub < 0){sub*=-1;}        
        if(sum == randomExistingValue || sub == randomExistingValue){
          if((new Random().nextInt(100)) % 2 == 0){
            originalDice = [new Random().nextInt(6)+1,new Random().nextInt(6)+1];
          }else{
             originalDice = [fValue,sValue];
          }
          print({"the final new data is : " : originalDice});
          return fValue.toString();
        }
      }
    }else if(dice_tries.length == 1){
      return originalDice[1].toString();
    }
    return dElement;
  }

  List<int> getExistingDataInInt(List<String> data) {
    List<int> existingData = [];
    for (int i = 0; i < data.length; i++) {
      if (data[i] != '') existingData.add(int.parse(data[i]));
    }
    return existingData;
  }

  displayLabel(String dElement) {
    if (flag == 0) {
      _counter1 = dElement;
      _counter = " ";
      for (int i = 0; i < dice_tries.length; i++) {
        _counter = _counter + dice_tries[i].toString() + " ";
      }
    } else {
      _counter1 = dElement;
      _counter2 = " ";
      for (int i = 0; i < dice_tries.length; i++) {
        _counter2 = _counter2 + dice_tries[i].toString() + " ";
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

      print("data in player1 data $data");
      print("data in player2 dataq ...$data1");

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
    print({"poped up dice value is  " : dice_tries});
    print({"player1 - 0 and player2 - 1  " : flag});
    var color = flag == 0 ? Colors.red : Colors.blue;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          // title: new Text('Dicegame'),
          content: new Image(
              image: new AssetImage(
            'assets/hoodie/dice_sad.png',
          )),
        );
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
      this.tile,
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
  int tile;
  final VoidCallback onPress;
  final DragTargetAccept onAccepted;
  final keys;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  // AnimationController controller, controller1;
  // Animation<double> animation, animation1;
  String _displayText;
  String newtext = '';
  var f = 0;
  var i = 0;
  AnimationController controller, controller1;
  Animation<double> animationRight, animation, animationWrong, animationDance;
  initState() {
    super.initState();
    // print("_MyButtonState.initState: ${widget.text}");
    // position = widget.offset;
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 20), vsync: this);
    controller = new AnimationController(
        duration: new Duration(milliseconds: 250), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.dismissed) {
          if (widget.text == '') {
            // controller.reverse();
          }
        }
      });
    controller.forward();
    animationWrong = new Tween(begin: -2.0, end: 2.0).animate(controller1);
    _myAnim();
  }

  void _myAnim() {
    animationWrong.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller1.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller1.forward();
      }
    });
    controller1.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      // controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Shake(
      animation: widget.tile == 1 ? animationWrong : animationRight,
      child: new ScaleTransition(
          scale: animation,
          child: new Container(
              child: new UnitButton(
            onPress: widget.onPress,
            text: widget.text,
            unitMode: UnitMode.text,
          ))),
    );
  }
}
