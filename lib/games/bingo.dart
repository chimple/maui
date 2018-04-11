import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'dart:math';
import 'package:maui/components/Shaker.dart';

class Bingo extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;

  Bingo(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new BingoState();
}

enum Status { Active, Visible }
enum ShakeCell { Right, Wrong, Dance, CurveRow }
enum ColmunCell { ColumnActive, CurveColumn }

class BingoState extends State<Bingo> with SingleTickerProviderStateMixin {
  Map<String, String> _Bingodata;
  List<String> _all = [];

  int _size = 3;
  var ques = 0;
  var num1 = 0;
  var i = 0, j = 0;
  Animation animation;
  AnimationController animationController;
  List _copyQuestion = [];
  List<String> _shuffledLetters = [];
  List<Status> _statuses = [];
  List<ShakeCell> _ShakeCells = [];
  List<ColmunCell> _ColmunCells = [];

//  List _letters;
  static int m = 3;
  static int n = 3;
  static double k = 3.0;
  static double l = 3.0;
  var count = 0;
  var x=0;
  // stored index check
  var s = 0;
  var element;

  /// datattaaaa

  bool _isLoading = true;
  var sum = 0;
  var _letters = new List.generate(m, (_) => new List(n));
  var _referenceMatrix = new List.generate(k.ceil(), (_) => new List(l.ceil()));

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    animationController = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 20.0).animate(animationController);
    setState(() => _isLoading = true);
    _Bingodata = await fetchPairData(widget.gameCategoryId, _size * _size);
    print({"kiran data": _Bingodata});

    _Bingodata.forEach((e, v) {
      _copyQuestion.add(e);
      _all.add(v);
    });

    ques = _copyQuestion[i];
    print({"this questions :": _copyQuestion});
    print({"this questions :": _all[i]});
//    print("this is a $question");
    print("this is a $ques");

    for (var i = 0; i < _all.length; i += _size * _size) {
      _shuffledLetters.addAll(
          _all.skip(i).take(_size * _size).toList(growable: false)..shuffle());
    }
    print({"reference size referenceMatrix.length": _referenceMatrix});
    _letters = _shuffledLetters.sublist(0, _size * _size);
    _statuses = _letters.map((a) => Status.Active).toList(growable: false);
    _ShakeCells = _letters.map((a) => ShakeCell.Wrong).toList(growable: false);
    _ColmunCells =
        _letters.map((a) => ColmunCell.ColumnActive).toList(growable: false);
    print({"reference size _ShakeCells.length": _ShakeCells});
    print({"reference size _ShakeCells.length": _ColmunCells});
    setState(() => _isLoading = false);
  }

  Widget _buildItem(
      int index, String text, Status status, ShakeCell tile, ColmunCell Ctile) {
    return new MyButton(
        key: new ValueKey<int>(index),
        text: text,
        status: status,
        tile: tile,
        Ctile: Ctile,
        onPress: () {
          print("this is index of prssed text ");
          print("index $index");
          print("text $text");
          if (status == Status.Active) {
            print("index kirrrrran $index");
            setState(() {
              if (text == element || text == ques) {
                setState(() {
                  _statuses[index] = Status.Visible;
//                  widget.onScore(1);
//                  widget.onProgress();
                });

                int counter = 0;
                for (int i = 0; i < 3; i++) {
                  for (int j = 0; j < 3; j++) {
                    if (counter == index) {
                      _referenceMatrix[i][j] = ShakeCell.Dance;
                      print({"this is  size": _size});
                    }
                    counter++;
                  }
                }

                int matchRow = bingoHorizontalChecker();
                print({"the bingo checker response row : ": matchRow});

                ///horizontall  data showing part
                if (-1 != matchRow) {
                  print("this is BINGORow");
                  for (int j = 0; j <= _referenceMatrix.length - 1; j++) {
                    if (_referenceMatrix[matchRow][j] == ShakeCell.Dance) {
                      _referenceMatrix[matchRow][j] = ShakeCell.CurveRow;
                    }
                  }
//                  horizontall animation and Bingo
                  if (matchRow == 0) {
                    for (i = matchRow; i < _size + matchRow; i++) {
                      setState(() {
                        _ShakeCells[i] = ShakeCell.CurveRow;
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          widget.onEnd();
                        });
                      });
                    }
                  } else if (matchRow == 1) {
                    matchRow = matchRow + _size - 1;
                    for (i = matchRow; i < _size + matchRow; i++) {
                      setState(() {
                        _ShakeCells[i] = ShakeCell.CurveRow;
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          widget.onEnd();
                        });
                      });
                    }
                  } else {
                    matchRow = matchRow + _size + 1;
                    for (i = matchRow; i < _size + matchRow; i++) {
                      setState(() {
                        _ShakeCells[i] = ShakeCell.CurveRow;
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          widget.onEnd();
                        });
                      });
                    }
                  }

                  print("thius is bngo animati curved in it $_ShakeCells");
                }
                int matchColumn = bingoVerticalChecker();
                print({"the bingo checker response column: ": matchColumn});
                if (-1 != matchColumn) {
                  //horizontall animation and Bingo
                  if (matchColumn == 0) {
                    print("this is 000first column of kiran $matchColumn ");
                    for (i = matchColumn; i <= _size + _size; i++) {
                      print("print iiiiiiiiiiii is iiiiiiii is $i");
                      setState(() {
                        print("this is great");
                        _ColmunCells[i] = ColmunCell.CurveColumn;
                        i = i + 2;
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          widget.onEnd();
                        });
                        print({"this is 1": _ColmunCells});
                      });
                    }
                  } else if (matchColumn == 1) {
                    print("this is 1111second column of kiran $matchColumn ");
                    for (i = matchColumn;
                        i <= _size + matchColumn + _size;
                        i++) {
                      print("print iiiiiiiiiiii is iiiiiiii is $i");
                      setState(() {
                        print({"this is 2": _ColmunCells});
                        _ColmunCells[i] = ColmunCell.CurveColumn;
                        i = i + 2;
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          widget.onEnd();
                        });
                      });
                    }
                  } else {
                    print("this is 2222third column of kiran $matchColumn ");
                    for (i = matchColumn;
                        i <= _size + matchColumn + _size;
                        i++) {
                      print("print iiiiiiiiiiii is iiiiiiii is $i");
                      setState(() {
                        _ColmunCells[i] = ColmunCell.CurveColumn;
                        i = i + 2;
                        new Future.delayed(const Duration(milliseconds: 250),
                            () {
                          widget.onEnd();
                        });
                        print({"this is 3": _ColmunCells});
                      });
                    }
                  }

                  print(
                      "thius is bngo animation  Colmun curved in it $_ColmunCells");
                }

                print({"this is reference": _referenceMatrix});
                print({"this is i value ": i});

                if (i <= _size * _size - 1) {
                  _copyQuestion.removeWhere((val)=> val==ques);
                  ques = _copyQuestion[i];

                } else {
                  print({"where is green manu ": " hello index is over"});
                }
              }

              else {
                _ShakeCells[index] = ShakeCell.Right;

                print("this is wrongg");
                new Future.delayed(const Duration(milliseconds: 400), () {
                  setState(() {
                    _ShakeCells[index] = ShakeCell.Wrong;
                    final _random = new Random();
                    var element = _copyQuestion[_random.nextInt(_copyQuestion.length)];
                    ques=element;
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
    return new LayoutBuilder(builder: (context, constraints) {
      var j = 0;
      return new Container(
        child: new Column(
          children: <Widget>[
            new Container(
                color: Colors.orange,
                height: 100.0,
                width: 100.0,
                child: new Center(
                    child: new Text("$ques",
                        key: new Key('question'),
                        style: new TextStyle(
                            color: Colors.black, fontSize: 30.0)))),
            new Expanded(
                child: new ResponsiveGridView(
              rows: _size,
              cols: _size,
              children: _letters
                  .map((e) => _buildItem(
                      j, e, _statuses[j], _ShakeCells[j], _ColmunCells[j++]))
                  .toList(growable: false),
            )),
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
      {Key key, this.text, this.onPress, this.status, this.tile, this.Ctile})
      : super(key: key);

  final String text;
  final VoidCallback onPress;
  Status status;
  ShakeCell tile;
  ColmunCell Ctile;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller, controller1, controller2;
  Animation<double> animationRight, animationWrong, animationDance;
  String _displayText;

  initState() {
    super.initState();
//    print("_MyButtonState.initState: ${widget.text}");
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    controller1 = new AnimationController(
        duration: new Duration(milliseconds: 100), vsync: this);
    animationRight =
        new CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller2 = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    controller.addStatusListener((state) {
//        print("$state:${animationRight.value}");
////        if (state == AnimationStatus.completed) {
//////        /  print('dismissed');
//////          if (!widget.text.isEmpty) {
//////            setState(() => _displayText = widget.text);
//////            controller.stop();
//////          }
////        }
    });
    controller.forward();
    animationWrong = new Tween(begin: -8.0, end: 8.0).animate(controller1);
    animationDance =
        new CurvedAnimation(parent: controller2, curve: Curves.easeInOut);
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

  @override
  Widget build(BuildContext context) {
//    print("_MyButtonState.build");
    return new ScaleTransition(
        scale: widget.Ctile == ColmunCell.CurveColumn ||
                widget.tile == ShakeCell.CurveRow
            ? animationDance
            : animationRight,
        child: new Shake(
            animation: widget.tile == ShakeCell.Right
                ? animationWrong
                : animationRight,
            child: new ScaleTransition(
                scale: animationRight,
                child: new RaisedButton(
                    splashColor: Colors.red,
                    onPressed: () => widget.onPress(),
                    padding: const EdgeInsets.all(8.0),
                    color: widget.status == Status.Visible
                        ? Colors.yellow
                        : Colors.teal,
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(8.0))),
                    child: new Text(_displayText,
                        style: new TextStyle(
                            color: Colors.white, fontSize: 24.0))))));
  }
}
