import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/state/button_state_container.dart';

// void main() {
//   runApp(new MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData.dark(),
//       home: new Basic_Counting(),
//     );
//   }
// }

class Basic_Counting extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Basic_Counting(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.onTurn,
      this.gameConfig,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new Basic_CountingState();
}

enum Status { Active, Visible }
enum ShakeCell { Right, Wrong }
enum ColmunCell { ColumnActive, CurveColumn }
enum RowCell { Dance, CurveRow }
enum Code{question,answer}

class Basic_CountingState extends State<Basic_Counting>
    with SingleTickerProviderStateMixin {
  Map<String, String> _Basic_Countingdata;
  // List<String> _all = [];

  int _size = 2;
  var ques;
  var num1 = 0;
  var p2pcount = 0;
  var i = 0, j = 0;
  Animation animation;
  AnimationController animationController;
  List _copyQuestion = [];
  List _copyQuestion1 = [];
  List<String> _shuffledLetters = [];
  List<Status> _statuses = [];
  List<ShakeCell> _ShakeCells = [];
  List<RowCell> _RowCells = [];
  List<ColmunCell> _ColmunCells = [];
  static int m = 3;
  static int n = 3;
  static double k = 3.0;
  static double l = 3.0;
  var count = 0;
  var countData = 0;
  var countEnd = 0;
  var clickCounter = 0;
  var a = 0, b = 0;
  var z = 0;
  // stored index check
  var s = 0;
  var element;
  var matchRow;
  var matchColumn;
  static int _maxSize = 2;
  var Basic_CountingCount = 0;
  var rowFlag = 0;
  var colFlag = 0;
  var onScoreFlag = 0;

  /// datattaaaa
  bool onend = false;
  bool _isLoading = true;
  var sum = 0;
  List<String> _all = ["5", "3", "3", "4", "5"];
  List<String> _answer = ["1", "2", "3", "4", "5"];
  var c = 0;
  var _referenceMatrix = new List.generate(_maxSize, (_) => new List(_maxSize));

  @override
  void initState() {
    super.initState();
    if (widget.gameConfig.level < 4) {
      _maxSize = 2;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 3;
    } else {
      _maxSize = 4;
    }
    print("this are my game basic");
    _statuses = _all.map((e) => Status.Active).toList(growable: false);
    _initBoard();
  }

  void _initBoard() async {
    print("second call when we are doing p2p");
    //  _Basic_Countingdata = await fetchPairData(
    //     // widget.gameConfig.gameCategoryId, _maxSize * _maxSize);
    // print({"kiran data": _Basic_Countingdata});
    // print({"kiran data": _Basic_Countingdata.length});
    // if ( _Basic_Countingdata.length <= 8) {
    //   Basic_CountingCount = 4;
    //   _maxSize = 2;
    // } else if ( _Basic_Countingdata.length < 16) {
    //   Basic_CountingCount = 9;
    //   _maxSize = 3;
    // } else {
    //   Basic_CountingCount = 16;
    //   _maxSize = 4;
    // }
    // _referenceMatrix = new List.generate(_maxSize, (_) => new List(_maxSize));
    // setState(() => _isLoading = true);
    // _Basic_Countingdata.forEach((e, v) {
    //   if (countData < Basic_CountingCount) {
    //     _copyQuestion.add(e);
    //     _copyQuestion1.add(e);
    //     _all.add(v);
    //     countData++;
    //   }
    // });
    // print("all data is checking when second time....$_all");

    // print("checking question here....::$_copyQuestion");

    // print(" count isssss $countData");
    // ques = _copyQuestion[z];
    // print("thia is a ques tio {$ques abd $z}");
    // print("this is a $ques");

// _shuffledLetters.removeRange(0, _shuffledLetters.length);
    // for (var i = 0; i < _all.length; i += _maxSize * _maxSize) {
    //   _shuffledLetters.addAll(
    //       _all.skip(i).take(_maxSize * _maxSize).toList(growable: false));
    // }

    // print(" display data is... chagongf or not ...::$_shuffledLetters");
    // print({"reference size referenceMatrix.length": _referenceMatrix});
    // _letters = _shuffledLetters.sublist(0, _maxSize * _maxSize);
    // _letters.shuffle();
    // _statuses = _letters.map((e) => Status.Active).toList(growable: false);
    // _ShakeCells = _letters.map((e) => ShakeCell.Wrong).toList(growable: false);
    // _ColmunCells =
    //     _letters.map((e) => ColmunCell.ColumnActive).toList(growable: false);
    // _RowCells = _letters.map((e) => RowCell.Dance).toList(growable: false);
    // setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, Status status, maxChars,
      double maxWidth, double maxHeight, code) {
    print("clicking button calling again and again we have fix");
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        code:code,
     
        //question unit mode
        status: status,
        onPress: () {
          print(" staus is.......::$_statuses");

          print("this is my new index $index");
          //     if (status == Status.Active) {
          //       setState(() {
          //         _statuses[index] = Status.Visible;
          //           print(" after click is.......::$_statuses");
          //             new Future.delayed(const Duration(milliseconds: 500), () {
          //               setState(() {
          //                                 _statuses[index] = Status.Active;
          //                                   });

          // });

          //       });
          //     }
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    print("this is my letters $_all");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    // if (_isLoading) {
    //   return new SizedBox(
    //       width: 20.0, height: 20.0, child: new CircularProgressIndicator());
    // }
    final maxChars = (_all != null
        ? _all.fold(
            1, (prev, element) => element.length > prev ? element.length : prev)
        : 1);
    print("$maxChars");
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _maxSize;
      double maxHeight =
          (constraints.maxHeight - vPadding * 2) / (_maxSize + 1);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);
     
      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, maxChars, maxWidth, maxHeight);
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
      print("this is my new $_all");
      var j = 0, k = 0;
      return Container(
        child: new Column(
          children: <Widget>[
            new LimitedBox(
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                child: new Material(
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    textStyle: new TextStyle(
                        color: Colors.orangeAccent, fontSize: 10.0),
                    child: new Container(
                        padding: EdgeInsets.all(buttonPadding),
                        child: new Center(
                          child: new Text(
                              "Count Your Fingers and Pick the Number choice"),
                        )))),
            new Expanded(
                child: Container(
              color: Colors.amberAccent,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: 1,
                    cols: 2,
                    children: _all
                        .map((e) => Padding(
                            padding: EdgeInsets.all(20.0),
                            child: _buildItem(j, e,
                                _statuses[j++], maxChars, maxWidth,maxHeight,Code.question)))
                        .toList(growable: false),
                  )),
            )),
            new Expanded(
                child: Container(
              color: Colors.lightBlue,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: vPadding, horizontal: hPadding),
                  child: new ResponsiveGridView(
                    rows: 1,
                    cols: 2,
                    children: _answer
                        .map((e) => Padding(
                            padding: EdgeInsets.all(20.0),
                            child: _buildItem(k, e, _statuses[k++], maxChars,
                                maxWidth, maxHeight,Code.answer)))
                        .toList(growable: false),
                  )),
            )),
          ],
        ),
      );
    });
  }
}

class MyButton extends StatefulWidget {
  MyButton(
      {Key key,
      this.text,
      this.onPress,
      this.status,
      this.maxChars,
      this.maxWidth,
      this.maxHeight, this.code})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
  final Status status;
  UnitMode unitMode; //question unit mode
  final int maxChars;
  final double maxWidth;
  final double maxHeight;
  final Code code;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, shakeController;
  Animation<double> animation, shakeAnimation, noAnimation;
  AnimationController flipController;

  String _displayText;

  initState() {
    super.initState();
    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    shakeController = new AnimationController(
        duration: new Duration(milliseconds: 50), vsync: this);
    flipController = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    noAnimation = new Tween(begin: 0.0, end: 0.0).animate(shakeController);
    animation =
        new CurvedAnimation(parent: controller, curve: Curves.elasticInOut)
          ..addStatusListener((state) {
            print("$state:${animation.value}");
            // if (state == AnimationStatus.completed) {
            // flipController.reverse();
            // }
            // else if(state == AnimationStatus.dismissed){
            //   flipController.forward();
            // }
          });
    flipController.addStatusListener((state) {
      if (state == AnimationStatus.completed &&
          widget.status == Status.Visible) {
        flipController.reverse();
      }
    });
    controller.forward().then((f) {
      // flipController.forward();
      // new Future.delayed(const Duration(milliseconds: 2000), () {
      //   flipController.reverse();
      // });
    });

    shakeAnimation = new Tween(begin: -6.0, end: 4.0).animate(shakeController);
    _myAnim();
  }

  void _myAnim() {
    shakeAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        shakeController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        shakeController.forward();
      }
    });
    shakeController.forward();
  }

  @override
  void didUpdateWidget(MyButton oldWidget) {
    print({"oldwidget data ": oldWidget.text});
    // if (oldWidget.status != widget.status) {
    //  if (widget.status == Status.Visible) {
    //       flipController.fling();
    //     } else {
    //       print("reverse");
    //       flipController.reverse();
    //     }
    // }
  }

  @override
  void dispose() {
    shakeController.dispose();
    controller.dispose();
    flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// print({"this is 123 kiran data": widget.Rtile});
    print({"this is 123 kiran column": widget.code});
    return 
    
    widget.code == Code.question?
    UnitButton(
      text: widget.text,
      unitMode: UnitMode.image,
    ): UnitButton(
      text: widget.text,
      unitMode: UnitMode.text,
    );
  }
}
