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
import 'package:maui/components/gameaudio.dart';

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
  List<String> myData;
  List<String> otherData;

  static List<String> diceData = ['1', '2', '3', '4', '5', '6'];
  bool _isLoading = true;
  List<int> dice_tries = [];
  List<int> originalDice = [];
  // int code, dindex, dcode;
  String _counter = " ";
  String _myCounter = " ";
  int count = 0;
  int count1 = 0;
  var _currentIndex = 0;

  AnimationController animation;

  Map<String, dynamic> toJsonMap() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['myData'] = myData;
    data['otherData'] = otherData;
    data['currentIndex'] = _currentIndex;
    return data;
  }

  void fromJsonMap(Map<String, dynamic> data) {
    otherData = data['myData'].cast<String>();
    myData = data['otherData'].cast<String>();
    _currentIndex = data['currentIndex'];
  }

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
    print('gameData: ${widget.gameConfig.gameData}');
    if (widget.gameConfig.gameData != null) {
      fromJsonMap(widget.gameConfig.gameData);
    } else {
      myData = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
      otherData = [
        '12',
        '11',
        '10',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2',
        '1'
      ];
    }
    for (int i = 0; i < 12; i++) {
      _shake.add(0);
    }
  }

  @override
  void didUpdateWidget(Dice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  Widget _playerKeyBoard(BuildContext context, double buttonPadding) {
    var j = 0;
    return new ResponsiveGridView(
      rows: 2,
      cols: 6,
      children: myData
          .map((e) => Padding(
              padding: EdgeInsets.all(buttonPadding),
              child: _buildItem(j, e, _shake[j++])))
          .toList(growable: false),
    );
  }

  Widget _buildItem(int index, String text, int tile) {
    return new MyButton(
      key: new ValueKey<int>(index),
      index: index,
      text: text,
      color1: 1,
      tile: tile,
      onPress: () {
        count1 = count1 + 1;
        setState(() {
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

          if (btnVal == sum || btnVal == sub) {
            _currentIndex++;
            print("Current index is ${myData.length}");
            widget.onScore(2);
            widget.onProgress(_currentIndex / myData.length);
            getExistingDataForScore(myData);
            resetDice();
            sum = 0;
            sub = 0;

            setState(() {
              myData[index] = '';
            });
          } else if (dice_tries.length == 2) {
            _shake[index] = 1;
            new Future.delayed(const Duration(milliseconds: 600), () {
              setState(() {
                _shake[index] = 0;
                widget.onScore(-1);
              });
            });
          } else {
            _shake[index] = 1;
            new Future.delayed(const Duration(milliseconds: 600), () {
              setState(() {
                _shake[index] = 0;
              });
            });
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
    _myCounter = " ";
  }

  void _randomVal() {
    setState(() async {
      animation.forward(from: 0.0);
      if (count <= 1) {
        count = count + 1;
        String dElement = randomLogic(myData);
        print({"the dElement data is : ": dElement});
        print({"the dice_tries data is : ": dice_tries});
        print({"the data is : ": myData});
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
          for (int i = 0; i < myData.length; i++) {
            if (myData[i] != '') if (int.parse(myData[i]) == sum ||
                int.parse(myData[i]) == sub) {
              // print("the data isssssssssssssssssss $data");
              matched = true;
            }
          }
          if (matched != true) {
            // This is condition for change player and bad luck
            popup();
            await new Future.delayed(const Duration(seconds: 1));
            setState(() {
              _myCounter = " ";
              resetDice();
              widget.onEnd(toJsonMap(), false);
            });
          }
        }
      }
    });
  }

  String randomLogic(List<String> data) {
    List<int> existingData = getExistingDataInInt(data);
    int randomExistingValue =
        existingData[new Random().nextInt(existingData.length)];
    String dElement = '';
    if (dice_tries.length == 0) {
      int fValue, sValue;
      while (true) {
        fValue = new Random().nextInt(6) + 1;
        sValue = new Random().nextInt(6) + 1;
        int sum = (fValue + sValue), sub = (fValue - sValue);
        if (sub < 0) {
          sub *= -1;
        }
        if (sum == randomExistingValue || sub == randomExistingValue) {
          if ((new Random().nextInt(100)) % 2 == 0) {
            originalDice = [
              new Random().nextInt(6) + 1,
              new Random().nextInt(6) + 1
            ];
          } else {
            originalDice = [fValue, sValue];
          }
          print({"the final new data is : ": originalDice});
          return fValue.toString();
        }
      }
    } else if (dice_tries.length == 1) {
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

  getExistingDataForScore(List<String> myData) {
    List<int> existingData1 = [];
    for (int i = 0; i < myData.length; i++) {
      if (myData[i] != '') existingData1.add(int.parse(myData[i]));
    }
    if (existingData1.length <= 1) {
      widget.onEnd(toJsonMap(), true);
    } else {
      widget.onEnd(toJsonMap(), false);
    }
  }

  displayLabel(String dElement) {
    _myCounter = dElement;
    _counter = " ";
    for (int i = 0; i < dice_tries.length; i++) {
      _counter = _counter + dice_tries[i].toString() + " ";
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

      if (_myCounter != " ") {
        dval = _myCounter + '.png';
      } else {
        dval = "tapto_play.gif";
      }

      print("data in player1 data $myData");
      print("data in player2 dataq ...$otherData");

      return new Container(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          color: Colors.black12,
          child: new Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: _playerKeyBoard(context, buttonPadding),
              ),
              new Container(
                  height: media.size.height > media.size.width
                      ? constraints.maxHeight * .08
                      : constraints.maxHeight * .11,
                  width: media.size.height < media.size.width
                      ? constraints.maxWidth * .15
                      : constraints.maxWidth * .2,
                  // color: Colors.red,
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      shape: BoxShape.rectangle,
                      border: new Border.all(color: Colors.black, width: 2.0)),
                  child: new Center(
                      child: new Text("$_counter",
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: constraints.maxHeight * .06)))),
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
                          ? 'assets/dice_game/dice_play.gif'
                          : 'assets/dice_game/$dval',
                    )),
                  )),
            ],
          ));
    });
  }

  popup() {
    print({"poped up dice value is  ": dice_tries});
    MediaQueryData media = MediaQuery.of(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          // title: new Text('Dicegame'),
          content: Container(
            height: media.size.height * .2,
            width: media.size.width * .2,
            child: new Image(
                image: new AssetImage(
              'assets/hoodie/dice_sad.png',
            )),
          ),
        );
      },
    );
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
      this.onAccepted,
      this.code,
      this.isRotated,
      this.img,
      this.tile,
      this.onPress})
      : super(key: key);
  final index;
  final int color1;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  int tile;
  final VoidCallback onPress;
  final DragTargetAccept onAccepted;

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
