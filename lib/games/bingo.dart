import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'dart:math';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';

class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Bingo(
      {key,
        this.onScore,
        this.onProgress,
        this.onEnd,
        this.iteration,
        this.gameConfig,
        this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new BingoState();
}

enum Status { Active, Visible }
enum ShakeCell { Right, Wrong }
enum ColmunCell { ColumnActive, CurveColumn }
enum RowCell { Dance, CurveRow }

class BingoState extends State<Bingo> with SingleTickerProviderStateMixin {
  Map<String, String> _Bingodata;
  List<String> _all = [];

  int _size = 2;
  var ques;
  var num1 = 0;
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
  var x = 0;
  // stored index check
  var s = 0;
  var element;
  List _Bingodata1 = [];
  var matchRow;
  var matchColumn;
  static int _maxSize = 2;
  var bingoCount = 0;

  /// datattaaaa

  bool _isLoading = true;
  var sum = 0;
  List _letters = [];
  //new List.generate(m, (_) => new List(n));
  var _referenceMatrix = new List.generate(_maxSize, (_) => new List(_maxSize));

  @override
  void initState() {
    super.initState();
    print("the data level erererererere ${widget.gameConfig.level}");
    if (widget.gameConfig.level < 4) {
      _maxSize = 2;
    } else if (widget.gameConfig.level < 7) {
      _maxSize = 3;
    } else {
      _maxSize = 4;
    }
    _initBoard();
    _referenceMatrix = [];
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
    _Bingodata = await fetchPairData(
        widget.gameConfig.gameCategoryId, _maxSize * _maxSize);
    print({"kiran data": _Bingodata});
    print({"kiran data": _Bingodata.length});
    if (_Bingodata.length <= 8) {
      bingoCount = 4;
      _maxSize = 2;
    } else if (_Bingodata.length < 16) {
      bingoCount = 9;
      _maxSize = 3;
    } else {
      bingoCount = 16;
      _maxSize = 4;
    }
    _referenceMatrix = new List.generate(_maxSize, (_) => new List(_maxSize));

    _Bingodata.forEach((e, v) {
      if (countData < bingoCount) {
        _copyQuestion.add(e);
        _copyQuestion1.add(e);
        _all.add(v);
        countData++;
      }
    });
    print(" count isssss $countData");
    ques = _copyQuestion[i];
    print({"this questions :": _copyQuestion});
    print({"this questions :": _all[i]});
//    print("this is a $question");
    print("this is a $ques");
    for (var i = 0; i < _all.length; i += _maxSize * _maxSize) {
      _shuffledLetters.addAll(
          _all.skip(i).take(_maxSize * _maxSize).toList(growable: false)
            ..shuffle());
    }
    print({"reference size referenceMatrix.length": _referenceMatrix});
    _letters = _shuffledLetters.sublist(0, _maxSize * _maxSize);
    _statuses = _letters.map((a) => Status.Active).toList(growable: false);
    _ShakeCells = _letters.map((a) => ShakeCell.Wrong).toList(growable: false);
    _ColmunCells =
        _letters.map((a) => ColmunCell.ColumnActive).toList(growable: false);
    _RowCells = _letters.map((a) => RowCell.Dance).toList(growable: false);
//    print({"reference size _ShakeCells.length": _ShakeCells});
//    print({"reference size _ShakeCells.length": _ColmunCells});
    setState(() => _isLoading = false);
  }

  Widget _buildItem(
      int index,
      String text,
      Status status,
      ShakeCell tile,
      ColmunCell Ctile,
      RowCell Rtile,

      int maxChars,
      double maxWidth,
      double maxHeight) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        Ctile: Ctile,
        Rtile: Rtile,
        unitMode: widget.gameConfig.answerUnitMode,//question unit mode
        onPress: () {
          print({"reference max size ": _referenceMatrix});
          print("this is index of prssted text ");
          print("index $index");
          print("text $text");
          if (status == Status.Active) {
            print("index kirrrrran $index");
            setState(() {
              var str1 = _all.indexOf(text);
              var str2 = _copyQuestion1.indexOf(ques);
              print("index of");
              if (str1 == str2) {
                print("heloo this shanttttthuuuuu");
                setState(() {
                  _statuses[index] = Status.Visible;
                  widget.onScore(4);
                });

                int counter = 0;
                for (int i = 0; i < _maxSize; i++) {
                  for (int j = 0; j < _maxSize; j++) {
                    print("hello kisrrrrraaan $index");
                    print("hello this is maannnnu $counter");
                    if (counter == index) {
                      _referenceMatrix[i][j] = 1;
                    }
                    counter++;
                  }
                }

                matchRow = bingoHorizontalChecker();
                print({"the bingo checker response row : ": matchRow});

                ///horizontall  data showing part
                if (-1 != matchRow) {
                  print("this is BINGORow");
                  if (matchRow == 0 ||matchRow == 1 || matchRow == 2||matchRow == 3 ||matchRow == 4 || matchRow == 5 ) {
                    matchRow=_maxSize*matchRow;
                    for (i = matchRow; i < _maxSize + matchRow; i++) {
                      setState(() {
                        _RowCells[i] = RowCell.CurveRow;
                        widget.onProgress(2 / 1);

                        new Future.delayed(const Duration(milliseconds: 2000),
                                () {
                              countData = 0;
                              widget.onEnd();
                            });
                      });
                    }
                  }

                  print("thius is bngo animati curved in it $_RowCells[i] ");
                }
                matchColumn = bingoVerticalChecker();
                print({"the bingo checker response column: ": matchColumn});
                if (-1 != matchColumn) {
                  //horizontall animation and Bingo
                  if (matchColumn == 0 || matchColumn == 1 || matchColumn == 2 || matchColumn == 3 || matchColumn == 4 || matchColumn == 5) {
                    print("this is 000first column of kiran $matchColumn ");
                    for (i = matchColumn; i < _maxSize * _maxSize; i++) {
                      print("print iiiiiiiiiiii is iiiiiiii is $i");
                      setState(() {
                        print("this is great");
                        _ColmunCells[i] = ColmunCell.CurveColumn;
                        i = i + _maxSize - 1;
                        widget.onProgress(2 / 1);

                        new Future.delayed(const Duration(milliseconds: 2000) ,
                                () {
                              countData = 0;
                              widget.onEnd();
                            });
                        print({"this is 1": _ColmunCells});
                      });
                    }
                  }
                  print(
                      "thius is bngo animation  Colmun curved in it $_ColmunCells");
                }

                print({"this is reference": _referenceMatrix});
                print({"this is i value ": i});
                if (matchRow == -1 && matchColumn == -1) {
                  if (i <= _maxSize * _maxSize - 1) {
                    _copyQuestion.removeWhere((val) => val == ques);
                    ques = _copyQuestion[i];
                  } else {
                    print({"where is green manu ": " hello index is over"});
                  }
                } else {
                  _copyQuestion.removeRange(0, _copyQuestion.length);
                }
              } else {
                widget.onScore(-1);
                _ShakeCells[index] = ShakeCell.Right;

                print("this is wrongg");
                new Future.delayed(const Duration(milliseconds: 300), () {
                  setState(() {
                    _ShakeCells[index] = ShakeCell.Wrong;
                    if (matchColumn == -1 && matchRow == -1) {
                      final _random = new Random();
                      var element =
                      _copyQuestion[_random.nextInt(_copyQuestion.length)];
                      ques = element;
                    }
//                    }
                  });
                });
              }
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
//    print("MyTableState.build");
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    if (_isLoading) {
      return new SizedBox(
          width: 20.0, height: 20.0, child: new CircularProgressIndicator());
    }
    final maxChars = (_letters != null
        ? _letters.fold(
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
      AppState state = AppStateContainer.of(context).state;

      var j = 0;
      return new Container(
        child: new Column(
          children: <Widget>[
            new LimitedBox(
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                child: new Material(
                    color: Theme.of(context).accentColor,
                    elevation: 4.0,
                    textStyle: new TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: state.buttonFontSize),
                    child: new Container(
                        padding: EdgeInsets.all(buttonPadding),
                        child: new Center(
                          child: new UnitButton(text:"$ques",primary: true,unitMode: widget.gameConfig.questionUnitMode,),
                        )))),
            new Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: vPadding, horizontal: hPadding),
                    child: new ResponsiveGridView(
                      rows: _maxSize,
                      cols: _maxSize,
                      children: _letters
                          .map((e) => Padding(
                          padding: EdgeInsets.all(buttonPadding),
                          child: _buildItem(
                              j,
                              e,
                              _statuses[j],
                              _ShakeCells[j],
                              _ColmunCells[j],
                              _RowCells[j++],
                              maxChars,
                              maxWidth,
                              maxHeight)))
                          .toList(growable: false),
                    ))),
          ],
        ),
      );
    });
  }

  int bingoHorizontalChecker() {
    print({"the reference matrix value is : ": _referenceMatrix});
    for (int i = 0; i < _referenceMatrix.length; i++) {
      bool bingo = true;
      for (int j = 0; j < _referenceMatrix.length; j++) {
        if (_referenceMatrix[i][j] == null) {
          bingo = false;
          break;
        }
      }
      if (bingo) return i;
    }

    return -1;
  }

  int bingoVerticalChecker() {
    print({"the reference matrix value is : ": _referenceMatrix});
    for (int j = 0; j < _referenceMatrix.length; j++) {
      bool bingo = true;
      for (int i = 0; i < _referenceMatrix.length; i++) {
        if (_referenceMatrix[i][j] == null) {
          bingo = false;
          break;
        }
      }
      if (bingo) return j;
    }

    return -1;
  }
}

class MyButton extends StatefulWidget {


  MyButton(
      {Key key,
        this.text,
        this.onPress,
        this.status,
        this.tile,
        this.Ctile,
        this.Rtile,
        this.unitMode,//question unit mode
        this.maxChars,
        this.maxWidth,
        this.maxHeight})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
  Status status;
  ShakeCell tile;
  ColmunCell Ctile;
  RowCell Rtile;
  UnitMode unitMode;//question unit mode
  final int maxChars;
  final double maxWidth;
  final double maxHeight;
  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1, controller2;
  Animation<double> animationRight,
      animationWrong,
      animationDance,
      animationOpacity;
  String _displayText;

  List<String> _DisplayCol = [];

  initState() {
    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");

    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 10), vsync: this);

    animationRight =
    new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller2 = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    controller.addStatusListener((state) {});
    controller.forward();
    animationWrong = new Tween(begin: -2.0, end: 2.0).animate(controller1);

    animationDance = new Tween(begin: 0.9, end: 1.0).animate(
      new CurvedAnimation(
          parent: controller2,
          curve: new Interval(
            0.100,
            0.500,
            curve: Curves.easeIn,
          ),
          reverseCurve: Curves.elasticOut),
    );
    animationOpacity = new Tween(begin: 0.3, end: 1.0).animate(
        new CurvedAnimation(
            parent: controller2,
            curve: new Interval(0.650, 0.700,
                curve: new Cubic(400.0, 400.0, 400.0, 400.0))));
    _myAnim();
    _myZoom();
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

  void _myZoom() {
    animationDance.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller2.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller2.forward();
      }
    });
    controller2.forward();
  }

//  @override
//  void didUpdateWidget(MyButton oldWidget) {
//    print({"oldwidget data ": oldWidget.text});
//    if (oldWidget.text != widget.text) {
//      controller.reverse();
//    }
//  }

  @override
  void dispose() {
    controller2.dispose();
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  var _colmunMethod;
  @override
  Widget build(BuildContext context) {
    print({"this is 123 kiran data": widget.Rtile});
    print({"this is 123 kiran column":widget.Ctile});
    return new ScaleTransition(
        scale:
        widget.Ctile ==  ColmunCell.CurveColumn || widget.Rtile == RowCell.CurveRow
            ? animationDance
            : animationRight,
        child: new Shake(
            animation: widget.tile == ShakeCell.Right
                ? animationWrong
                : animationRight,
            child: new ScaleTransition(
                scale: animationRight,
                child: new UnitButton(
                    onPress: () => widget.onPress(),

//                    padding: const EdgeInsets.all(8.0),
//                        color: widget.status == Status.Visible
//                            ? Colors.pink
//                            : Colors.teal,
//                        shape: new RoundedRectangleBorder(
//                            borderRadius:
//                            const BorderRadius.all(const Radius.circular(8.0))),
//                        text: new Text(_displayText,
//                            style: new TextStyle(
//                                color: Colors.white, fontSize: 24.0))
                    text: _displayText,
                    highlighted: widget.status == Status.Visible ? true : false,
                    disabled:  widget.Ctile ==  ColmunCell.CurveColumn || widget.Rtile == RowCell.CurveRow ? true :false ,
                    unitMode:  widget.unitMode)))); //question unit mode
  }
}
