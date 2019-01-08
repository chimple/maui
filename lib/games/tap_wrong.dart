import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'dart:math';
import 'package:maui/components/unit_button.dart';
import 'dart:async';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/flash_card.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:maui/components/gameaudio.dart';

class TapWrong extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  TapWrong(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new TapWrongState();
}

enum Statuses { right, wrong }

class TapWrongState extends State<TapWrong> {
  String _dispText = '';
  int num1;
  int numOFWrongElem;
  bool _isLoading = true;
  List<String> word = new List(); //=['D','O','G'];
  List<String> others = new List(); //=['X','P'];
  List<String> arr1 = [];
  List<String> proArray = [];
  List<Statuses> _statusList;
  Tuple2<List<String>, List<String>> data;
  bool _isShowingFlashCard = false;
  int _maxSize = 3;
  int _maxSize1 = 0;
  int arrayLength = 0;
  int clickCnt = 0;
  bool control = true;
  @override
  void initState() {
    super.initState();
    if (widget.gameConfig.level < 4) {
      _maxSize = 3;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 4;
    } else {
      _maxSize = 5;
    }
    _maxSize1 = (_maxSize / 2).ceil();
    _initBoard();
  }

  void _initBoard() async {
    word = [];
    others = [];
    arr1 = [];
    _statusList = [];
    num1 = 0;
    numOFWrongElem = 0;
    _dispText = '';
    setState(() => _isLoading = true);
    data = await fetchWordData(
        widget.gameConfig.gameCategoryId, _maxSize, _maxSize1);
    print('datat  ${data.item1}');
    print('datat  ${data.item2}');
    data.item1.forEach((d) {
      word.add(d);
    });
    data.item2.forEach((d) {
      others.add(d);
    });
    word.forEach((d) {
      _dispText = _dispText + d;
    });
    if (_dispText[0] == _dispText[1] && _dispText[0] == _dispText[2]) {
      _dispText = _dispText[0];
    }
    arr1.addAll(word);
    var lenOfArr1 = arr1.length;
    arr1.addAll(others);
    print(" word ${word}");
    print(" others ${others}");
    print(" arr1 ${arr1}");
    print("_dispText ${_dispText}");
    print(" lenOfArr1${lenOfArr1}");
    var rand = new Random();
    var randNum = 0;
    String temp = '';
    String temp1 = '';

    // Randomizing array

    for (int w = 0; w < others.length; w++) {
      randNum = rand.nextInt(arr1.length - 1);
      print("random num $randNum");
      print('$arr1');
      temp = arr1[randNum];
      arr1[randNum] = others[w];
      print('$arr1');
      print('${arr1.length}');
      for (int q = randNum; q < (lenOfArr1 + w); q++) {
        temp1 = arr1[q + 1];
        arr1[q + 1] = temp;
        temp = temp1;
        // console.log("arr1[q],arr2[w]", arr1[q], this.props.data.others[w]);

      }
    }
    print('array1     $arr1');

    _statusList = arr1.map((a) => Statuses.right).toList(growable: false);
    print('status array      $_statusList');
    setState(() => _isLoading = false);
    arrayLength = arr1.length;
  }

  @override
  void didUpdateWidget(TapWrong oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initBoard();
    }
  }

  Widget _buildItem(int index, String text, Statuses status) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        index: index,
        status: status,
        onPress: !control
            ? () {}
            : () {
                print("index                         $index");
                int j = 0;
                control = false;
                proArray.addAll(arr1);
                proArray.removeAt(index);
                print('removed text from array ${arr1[index]}');
                print('removed array       $proArray');
                print('removed array l3en      ${proArray.length}');
                print('word array       $word');
                print('disp text   $_dispText');

                for (int i = 0; i < proArray.length; i++) {
                  if (word[j] == proArray[i]) {
                    j++;
                  }
                  if (j >= word.length) {
                    break;
                  }
                }

                print('j is now     $j');

                if (j >= word.length) {
                  num1++;
                  numOFWrongElem++;
                  print('array 1           $arr1');

                  new Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      //  _statusList.removeAt(index);
                      arr1.removeAt(index);
                    });
                    control = true;
                  });

                  print('array 1 after     $arr1');
                  widget.onScore(2);
                  widget.onProgress(num1 / others.length);
                  if (numOFWrongElem == others.length) {
                    new Future.delayed(const Duration(milliseconds: 700), () {
                      setState(() {
                        _isShowingFlashCard = true; // widget.onEnd();
                      });
                    });
                    //  widget.onEnd();
                  }
                } else {
                  setState(() {
                    _statusList[index] = Statuses.wrong;
                  });
                  print('status array after clicking wrong     $_statusList');
                  new Future.delayed(const Duration(milliseconds: 700), () {
                    setState(() {
                      _statusList[index] = Statuses.right;
                    });
                    control = true;
                  });
                }
                proArray = [];
              });
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / arrayLength;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (2);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxWidth);
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;

      if (_isLoading) {
        return new SizedBox(
          width: 20.0,
          height: 20.0,
          child: new CircularProgressIndicator(),
        );
      }
      if (_isShowingFlashCard) {
        return FractionallySizedBox(
            widthFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.65 : 0.5,
            heightFactor:
                constraints.maxHeight > constraints.maxWidth ? 0.7 : 0.9,
            child: new FlashCard(
                image: _dispText,
                text: _dispText,
                onChecked: () {
                  widget.onEnd(); // _initBoard();

                  setState(() {
                    _isShowingFlashCard = false;
                    control = true;
                  });
                }));
      }
      int j = 0;

      return Padding(
          padding:
              EdgeInsets.symmetric(vertical: vPadding, horizontal: hPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child:
                      //  maxHeight: maxHeight,
                      //  maxWidth: maxWidth,
                      new Material(
                          color: Theme.of(context).accentColor,
                          //  elevation: 4.0,
                          textStyle: new TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: buttonConfig.fontSize),
                          child: new Container(
                              // width: 100.0,
                              //  height: 200.0,
                              padding: EdgeInsets.all(buttonPadding),
                              child: new Center(
                                child: new UnitButton(
                                  maxHeight: constraints.maxHeight / 2,
                                  maxWidth: constraints.maxWidth / 2,
                                  text: _dispText,
                                  primary: false,
                                  unitMode: UnitMode.image,
                                ),
                              )))),
              Expanded(
                  child: ResponsiveGridView(
                rows: 1,
                cols: arr1.length,
                children: arr1
                    .map((e) => Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: _buildItem(j, e, _statusList[j++])))
                    .toList(growable: false),
              ))
            ],
          ));
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton({Key key, this.text, this.onPress, this.status, this.index})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
  final Statuses status;
  final int index;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1;
  Animation<double> animation, animation1;
  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 40), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);

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
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("_MyButtonState.build");
    return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.status == Statuses.wrong ? animation1 : animation,
            child: new UnitButton(
              onPress: widget.status == Statuses.wrong ? () {} : widget.onPress,
              text: widget.text,
              unitMode: UnitMode.text,
            )));
  }
}
