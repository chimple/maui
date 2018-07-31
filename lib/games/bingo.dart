import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'dart:math';
import 'package:maui/games/single_game.dart';
import 'package:maui/components/shaker.dart';
import 'package:maui/state/button_state_container.dart';

class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  Function onTurn;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;

  Bingo(
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
  var bingoCount = 0;
  var rowFlag = 0;
  var colFlag = 0;
  var onScoreFlag = 0;

  /// datattaaaa
  bool onend = false;
  bool _isLoading = true;
  var sum = 0;
  List _letters = [];
  var c = 0;
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
    _referenceMatrix = [];
    print("iteratin in initstate is...:: ${widget.iteration}");
    _initBoard();
  }

  @override
  void didUpdateWidget(Bingo oldWidget) {
    print(
        "this is our preseent iteraion GOOOD SANDJFNDNF DJNFJDNF ${widget.iteration}");
    if (oldWidget.iteration != widget.iteration) {
      print("old widget ${oldWidget.iteration}");
      print("new widget ${widget.iteration}");
      print(
          "this is my new data ${oldWidget.iteration} and ${widget.iteration}");
      onend = false;
      setState(() {
        _statuses = _letters.map((e) => Status.Active).toList(growable: false);
        _ShakeCells =
            _letters.map((e) => ShakeCell.Wrong).toList(growable: false);
        _ColmunCells = _letters
            .map((e) => ColmunCell.ColumnActive)
            .toList(growable: false);
        _RowCells = _letters.map((e) => RowCell.Dance).toList(growable: false);
//        z = 0;
//        bingoCount = 0;
//        countData = 0;
//        onScoreFlag = 0;
//        countEnd == 0;
//        clickCounter = 0;
//        onScoreFlag = 0;
//        _copyQuestion.removeRange(0, _copyQuestion.length);
//        _copyQuestion1.removeRange(0, _copyQuestion1.length);
//        _all.removeRange(0, _all.length);
//        _letters.removeRange(0, _letters.length);
//        _shuffledLetters.removeRange(0, _shuffledLetters.length);
//        print("iteration not chhanging.......::..${widget.iteration}");
      });
      _initBoard();
    }
  }

  void _initBoard() async {
    print("second call when we are doing p2p");
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
    setState(() => _isLoading = true);
    _Bingodata.forEach((e, v) {
      if (countData < bingoCount) {
        _copyQuestion.add(e);
        _copyQuestion1.add(e);
        _all.add(v);
        countData++;
      }
    });
    print("all data is checking when second time....$_all");

    print("checking question here....::$_copyQuestion");

    print(" count isssss $countData");
    ques = _copyQuestion[z];
    print("thia is a ques tio {$ques abd $z}");
    print("this is a $ques");

// _shuffledLetters.removeRange(0, _shuffledLetters.length);
    for (var i = 0; i < _all.length; i += _maxSize * _maxSize) {
      _shuffledLetters.addAll(
          _all.skip(i).take(_maxSize * _maxSize).toList(growable: false));
    }

    print(" display data is... chagongf or not ...::$_shuffledLetters");
    print({"reference size referenceMatrix.length": _referenceMatrix});
    _letters = _shuffledLetters.sublist(0, _maxSize * _maxSize);
    _letters.shuffle();
    _statuses = _letters.map((e) => Status.Active).toList(growable: false);
    _ShakeCells = _letters.map((e) => ShakeCell.Wrong).toList(growable: false);
    _ColmunCells =
        _letters.map((e) => ColmunCell.ColumnActive).toList(growable: false);
    _RowCells = _letters.map((e) => RowCell.Dance).toList(growable: false);
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
    print("clicking button calling again and again we have fix");
    c = 0;
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        Ctile: Ctile,
        Rtile: Rtile,
        unitMode: widget.gameConfig.questionUnitMode, //question unit mode
        onPress: () {
          print("text $text");

          print("testing $text");

          var str1 = _all.indexOf(text);
          var str2 = _copyQuestion1.indexOf(ques);
          print(
              "comparring string in bingo game suddenly taking extra score $c");

          print(" staus is.......::$_statuses");
          if (str1 == str2 && onend != true && status == Status.Active) {
            widget.onScore(4);
            setState(() {
              _statuses[index] = Status.Visible;
              clickCounter++;
            });

            int counter = 0;
            for (int i = 0; i < _maxSize; i++) {
              for (int j = 0; j < _maxSize; j++) {
                if (counter == index) {
                  _referenceMatrix[i][j] = 1;
                }
                counter++;
              }
            }
            print("checking where it is comming ");
            matchRow = bingoHorizontalChecker();
            matchColumn = bingoVerticalChecker();
            if (-1 != matchRow) {
              if (matchRow == 0 ||
                  matchRow == 1 ||
                  matchRow == 2 ||
                  matchRow == 3 ||
                  matchRow == 4 ||
                  matchRow == 5) {
                rowFlag = 1;
                matchRow = _maxSize * matchRow;
                for (i = matchRow; i < _maxSize + matchRow; i++) {
                  p2pcount = p2pcount + 1;
                  setState(() {
                    _RowCells[i] = RowCell.CurveRow;
                    widget.onProgress(2 / 1);
                  });
                }
              }
            }
            print("where it is comming .... ");
            if (-1 != matchColumn) {
              if (matchColumn == 0 ||
                  matchColumn == 1 ||
                  matchColumn == 2 ||
                  matchColumn == 3 ||
                  matchColumn == 4 ||
                  matchColumn == 5) {
                rowFlag = 1;
                for (i = matchColumn; i < _maxSize * _maxSize; i++) {
                  setState(() {
                    print("this is great");
                    _ColmunCells[i] = ColmunCell.CurveColumn;
                    i = i + _maxSize - 1;
                    widget.onProgress(2 / 1);
                  });
                }
              }
            }
            if (rowFlag == 1 || colFlag == 1) {
              setState(() {
                rowFlag = 0;
                colFlag = 0;
                onScoreFlag = 1;

                _turnByTurn();
              });
            }
            if (matchRow == -1 && matchColumn == -1) {
              if (z <= _maxSize * _maxSize - 1) {
                _copyQuestion.removeWhere((val) => val == ques);
                ques = _copyQuestion[z];
                print("this is a deleted copyquestion $ques");
                print("this is a length copyquestion ${_copyQuestion[z]}");
              }
            } else {
              _copyQuestion.removeRange(0, _copyQuestion.length);
            }
          } else {
            print("this is my1 click $clickCounter");
            print("this is my2 intial $countEnd");
            if (onScoreFlag != 1 &&
                status == Status.Active &&
                clickCounter > 0 &&
                c == 0) {
              print("this is my click $clickCounter");
              print("this is my intial $countEnd");
              if (c == 0) {
                setState(() {
                  widget.onScore(-1);
                  countEnd++;
                  _ShakeCells[index] = ShakeCell.Right;
                  if (countEnd == 3) {
                    print("this is my count End $countEnd");
                    countEnd = 0;
                    widget.onEnd();
                    z = 0;
                    bingoCount = 0;
                    countData = 0;
                    onScoreFlag = 0;
                    clickCounter = 0;
                    onScoreFlag = 0;
                    _copyQuestion.removeRange(0, _copyQuestion.length);
                    _copyQuestion1.removeRange(0, _copyQuestion1.length);
                    _all.removeRange(0, _all.length);
                    _letters.removeRange(0, _letters.length);
                    _shuffledLetters.removeRange(0, _shuffledLetters.length);
                  }
                });
                //print("this is wrongg");
                new Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    _ShakeCells[index] = ShakeCell.Wrong;
                    if (matchColumn == -1 && matchRow == -1) {
                      final _random = new Random();
                      var element =
                          _copyQuestion[_random.nextInt(_copyQuestion.length)];
                      ques = element;
                      print("this is a elemet of removed $ques");
                    }
                  });
                });
              }
              c = 1;
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
// print("MyTableState.build");
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
      final buttonConfig = ButtonStateContainer.of(context).buttonConfig;

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
                        fontSize: buttonConfig.fontSize),
                    child: new Container(
                        padding: EdgeInsets.all(buttonPadding),
                        child: new Center(
                          child: new UnitButton(
                            text: "$ques",
                            primary: true,
                            unitMode: widget.gameConfig.questionUnitMode,
                          ),
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
// print({"the reference matrix value is : ": _referenceMatrix});
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
// print({"the reference matrix value is : ": _referenceMatrix});
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

  void _turnByTurn() {
    if (onend == false) {
      onend = true;

      print("this is when onend calling method was........ ");
      setState(() {
        new Future.delayed(const Duration(milliseconds: 200), () {
          if (onend == true) {
            countEnd == 0;
            widget.onEnd();
            z = 0;
            bingoCount = 0;
            countData = 0;
            onScoreFlag = 0;
            clickCounter = 0;
            onScoreFlag = 0;
            _copyQuestion.removeRange(0, _copyQuestion.length);
            _copyQuestion1.removeRange(0, _copyQuestion1.length);
            _all.removeRange(0, _all.length);
            _letters.removeRange(0, _letters.length);
            _shuffledLetters.removeRange(0, _shuffledLetters.length);
          }
        });
      });
    }
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
      this.unitMode, //question unit mode
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
  UnitMode unitMode; //question unit mode
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
// print("_MyButtonState.initState: ${widget.text}");
// print("this fkjdnfjflkjfjfkdf nidfjodkfofkdf biswjeet");
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

  @override
  void didUpdateWidget(MyButton oldWidget) {
// print({"oldwidget data ": oldWidget.text});
    if (oldWidget.text != widget.text) {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    controller2.dispose();
    controller.dispose();
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// print({"this is 123 kiran data": widget.Rtile});
// print({"this is 123 kiran column":widget.Ctile});
    return new ScaleTransition(
        scale: widget.Ctile == ColmunCell.CurveColumn ||
                widget.Rtile == RowCell.CurveRow
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
                    text: _displayText,
                    highlighted: widget.status == Status.Visible ? true : false,
                    disabled: widget.Ctile == ColmunCell.CurveColumn ||
                            widget.Rtile == RowCell.CurveRow
                        ? true
                        : false,
                    unitMode: widget.unitMode))));
  }
}
