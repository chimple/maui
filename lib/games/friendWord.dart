import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maui/components/unit_button.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'package:maui/components/responsive_grid_view.dart';
import 'package:maui/components/Shaker.dart';
import 'package:maui/state/button_state_container.dart';

class FriendWord extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  GameConfig gameConfig;
  bool isRotated;
  FriendWord(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.isRotated = false,
      this.gameConfig})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new FriendWordState();
}

enum Status { Active, Visible, Disappear }

class FriendWordState extends State<FriendWord> {
  var flag1 = 0;
  var flag = 0;
  var correct = 0;
  var keys = 0;
  List<int> clicks = [];
  static int _size = 5;
  List<String> data = ['', '', '', '', '', '', '', '', ''];
  List<String> _rightwords = [];
  List<String> dragData = ['c', 'a', 't', 'b', 'g', 'r', 't', 'y', 'u'];
  List<int> _starList = new List();
  List<int> _flag = new List();
  List<String> _data1 = new List();
  var _sortletters = [];
  bool _isLoading = true;
  List _center = [];
  String Cword = '';
  String Rword = '';
  var L, R;
  var i = 0, j = 0;
  var counter = 0;
  var row, col;
  int _rows, _cols, code, dindex, dcode;
  var Top = _size, Bot = _size, Lef = 1, Rig = 1, point = 0;
  List<Status> _statuses;
  List<Status> _dragStatus;
  static var median1 = (_size - 1) / 2;
  static int k = median1.toInt();
  int median = k;
  int center = (k * _size) + k;
  List<String> arr = new List<String>();
  var _referenceMatrix = new List.generate(_size, (_) => new List(_size));

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() async {
    setState(() => _isLoading = true);
//    _center.removeRange(0, _center.length);
//    List<String> arr = new List<String>();
    print("this is center $center");
    print("thhiiis kiiirran mean value is $median");
    for (var i = 0; i < _size * _size; i++) {
      arr.add(" ");
      print({"this is an array": arr});
    }

    _starList.add(median);

    for (var j = 0; j < k; j++) {
      median = median + _size - 1;
      L = median;
      _starList.add(median);

      print("this is $L");
      print("this is ${_size * median}");
    }
    median = k;
    print(" ths value o llllll id $L");
    if (L == (_size * median)) {
      median = L;
      print(" its comming in if");
      for (var j = 0; j < k; j++) {
        median = median + _size + 1;

        _starList.add(median);
        L = median;
      }
    }
    median = k;
    for (var j = 0; j < k; j++) {
      median = median + _size + 1;
      R = median;
      _starList.add(median);
    }
    median = k;
    print(" ths value o llllll id $L");
    if (R == ((_size * median) + (_size - 1))) {
      median = R;
      print(" its comming in if");
      for (var j = 0; j < k; j++) {
        median = median + _size - 1;

        _starList.add(median);
        R = median;
      }
      center = ((_size * _size) / 2).floor();
      _starList.add(center);
      print("this is kiran $center");
    }

    _starList.forEach((e) {
      arr[e] = "*";
    });
    _statuses = arr.map((e) => Status.Visible).toList(growable: false);
    _dragStatus = dragData.map((e) => Status.Disappear).toList(growable: false);
    print("the satus $_statuses");
    print("this is drag status $_dragStatus");
    setState(() => _isLoading = false);
  }

  Widget _buildItem(int index, String text, Status status) {
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        status: status,
        onAccepted: (dcindex) {
          print("index is .......$dcindex");
          setState(() {
            if (center == index) {
              arr[index] = dcindex;
              _center.add(index);
              Cword = "$dcindex";
              Rword = "$dcindex";
              clicks.add(index);

              _statuses[index] = Status.Active;
              print("status of active $_statuses");
              print("index is .......$index");
              row = index / _size;
              col = index % _size;
              _referenceMatrix[row.toInt()][col.toInt()] = dcindex;
              counter = 1;

//              print("this is my _center index $center");
//              print("this is my _center index $_center");
            }
          });
          print('dataa $dcindex');
//          print({"array data index": center});
//          print({"array data index": _center});

          _center.forEach((e) {
            point = e;

            if ((index == point + Rig) ||
                index == point + Bot ||
                (index == point - Lef) ||
                index == point - Top) {
              setState(() {
//                  arr[index] = dcindex;
                _statuses[index] = Status.Active;
                print("status of active after CCCC $_statuses");
                flag = 1;
                if (index == point + 1) {
                  Rword = "$Rword" + "$dcindex";
                } else if (index == point - 1) {
                  Rword = "$dcindex" + "$Rword";
                } else if (index == point - Top) {
                  Cword = "$dcindex" + "$Cword";
                  print("this is new   Cword $Cword");
                } else if (index == point + Bot) {
                  Cword = "$Cword" + "$dcindex";
                }
              });
            }

            horizontalChecker(Rword);
            verticalChecker(Cword);
//              var Hword = bingoHorizontalChecker(Rword);
//              print("this is horizontal ${Hword}");
          });
//            if(index == center +1 ){
//              word = "$word" + "$dcindex";
//            }else if(index == point -1 ){
//              word = "$dcindex" + "$word";
//
//            }
          print("sorted letter $Rword");
          print("Sorted top $Cword");
          if (flag == 1) {
            arr[index] = dcindex;
            clicks.add(index);
            _center.add(index);
            row = index / _size;
            col = index % _size;
            print("row is coming here $row");
            print("Col is coming here $col");
            _referenceMatrix[row.toInt()][col.toInt()] = dcindex;

            flag = 0;
          }
//            arr[index] = dcindex;
//              _center.add(index);
//          var matchRow = bingoHorizontalChecker();
//          print({"the bingo checker response row : ": matchRow});
//            print("object of index... is $index");
//            print("this is my _center index2 $_center");
//            print("this is my _center clicks $clicks");
//          print("this is my reference $_referenceMatrix");
        });
  }

  submit() {
    print("hello $Rword");
//    if(Rword != null)
//    bingoHorizontalChecker(Rword);
    var Hword = horizontalChecker(Rword);
    var Vword = horizontalChecker(Cword);
    print("this is horizontal ${Hword}");
    print("this is Vertical   ${Vword}");
  }

  horizontalChecker(String searchWord) {
    bool allChar = true;
    print("this is my search word $searchWord");
    if (searchWord != null) {
      String firstWord = searchWord[0];
      print("print FirstWord $firstWord");
      print({"the reference matrix value is : ": _referenceMatrix});
      for (var i = 0; i < _referenceMatrix.length; i++) {
        for (int j = 0; j < _referenceMatrix[i].length; j++) {
          if (_referenceMatrix[i][j] == firstWord) {
            print({"the first word i and j": _referenceMatrix[i][j]});
            int searchRow = i;
            int searchColumn = j;
            for (int charIndex = 0;
                charIndex < searchWord.length;
                charIndex++) {
              if (searchRow >= _referenceMatrix.length ||
                  searchColumn >= _referenceMatrix[searchRow].length ||
                  _referenceMatrix[searchRow][searchColumn] !=
                      searchWord[charIndex]) {
                allChar = false;
              }
              searchColumn++;
            }
          }
          if (allChar) return true;
          return searchWord;
//        print("hello");
//        print("this is row ${i}");
//        print("this   rrjenrnjenjrenrne ${_referenceMatrix[i][j]}");
        }
      }
      print("this is $i");
      return false;
    }
  }

  verticalChecker(String searchWord) {
    bool allChar = true;
    print("this is my search word $searchWord");
    if (searchWord != null) {
      String firstWord = searchWord[0];
      print("print FirstWord $firstWord");
      print({"the reference matrix value is : ": _referenceMatrix});
      for (var i = 0; i < _referenceMatrix.length; i++) {
        for (int j = 0; j < _referenceMatrix[i].length; j++) {
          if (_referenceMatrix[i][j] == firstWord) {
            print({"the first word i and j": _referenceMatrix[i][j]});
            int searchRow = i;
            int searchColumn = j;
            for (int charIndex = 0;
                charIndex < searchWord.length;
                charIndex++) {
              if (searchRow >= _referenceMatrix.length ||
                  searchColumn >= _referenceMatrix[searchRow].length ||
                  _referenceMatrix[searchRow][searchColumn] !=
                      searchWord[charIndex]) {
                allChar = false;
              }
              searchColumn++;
            }
          }
          if (allChar) return true;
          return searchWord;
//        print("hello");
//        print("this is row ${i}");
//        print("this   rrjenrnjenjrenrne ${_referenceMatrix[i][j]}");
        }
      }
      print("this is $i");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("this is my array $arr");
    var j = 0, k = 0;
    var rwidth, rheight;
    //  print(constraints.maxHeight);
    return new LayoutBuilder(builder: (context, constraints) {
      final hPadding = pow(constraints.maxWidth / 150.0, 2);
      final vPadding = pow(constraints.maxHeight / 150.0, 2);

      double maxWidth = (constraints.maxWidth - hPadding * 2) / _size;
      double maxHeight = (constraints.maxHeight - vPadding * 2) / (_size + 2);

      final buttonPadding = sqrt(min(maxWidth, maxHeight) / 5);

      maxWidth -= buttonPadding * 2;
      maxHeight -= buttonPadding * 2;
      UnitButton.saveButtonSize(context, 1, maxWidth, maxHeight);

      return new Container(
          color: Colors.purple[300],
          child: new Column(
            // portrait mode
            children: <Widget>[
              new Expanded(
                child: new ResponsiveGridView(
                  rows: _size,
                  cols: _size,
                  maxAspectRatio: 1.0,
                  children: arr
                      .map((e) => Padding(
                          padding: EdgeInsets.all(buttonPadding),
                          child: _buildItem(j, e, _statuses[j++])))
                      .toList(growable: false),
                ),
              ),
              new Container(
                child: new ResponsiveGridView(
                  rows: 1,
                  cols: 9,
                  children: dragData
                      .map((e) => Padding(
                          padding: EdgeInsets.all(buttonPadding),
                          child: _buildItem(k, e, _dragStatus[k++])))
                      .toList(growable: false),
                ),
              ),
              new Container(
                child: new RaisedButton(
                  onPressed: () => submit(),
                  child: new Text("SUBMIT"),
                  splashColor: Colors.orangeAccent,
                ),
              )
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
      this.status,
      this.keys})
      : super(key: key);
  final index;
  final int color1;
  final int flag;
  final int code;
  final bool isRotated;
  final String text;
  final String img;
  final DragTargetAccept onAccepted;
  final Status status;
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
    final buttonConfig = ButtonStateContainer.of(context).buttonConfig;
    if (widget.status == Status.Visible && widget.color1 != 0) {
      return new ScaleTransition(
        scale: animation,
        child: new Shake(
            animation: widget.flag == 1 ? animation1 : animation,
            child: new ScaleTransition(
                scale: animation,
                child: new Container(
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: new DragTarget(
                    onAccept: (String data) => widget.onAccepted(data),
//                    onWillAccept:(String data) => true,
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return new UnitButton(
                        key: new Key('A${widget.keys}'),
                        text: widget.text,
                        bgImage: widget.img,
                        showHelp: false,
                        highlighted: widget.flag == 1 ? true : false,
                      );
                    },
                  ),
                ))),
      );
    } else if (widget.status == Status.Active &&
        (widget.text == '' || widget.text.length == 2)) {
      if (widget.text == '') {
        newtext = '';
      } else {
        newtext = widget.text[0];
      }
      return new ScaleTransition(
          scale: animation,
          child: new UnitButton(
            key: new Key('A${widget.keys}'),
            text: newtext,
            showHelp: false,
            disabled: true,
          ));
    } else if (widget.status == Status.Disappear ||
        widget.status == Status.Active) {
      return new Draggable(
        data: '${widget.text}',
        child: new ScaleTransition(
            scale: animation,
            child: new UnitButton(
              key: new Key('A${widget.keys}'),
              text: widget.text,
              showHelp: false,
            )),
        //  childWhenDragging: new Container(),
        feedback: UnitButton(
          text: widget.text,
          maxHeight: buttonConfig.height,
          maxWidth: buttonConfig.width,
          fontSize: buttonConfig.fontSize,
        ),
      );
    } else {
      return new ScaleTransition(
          scale: animation,
          child: new UnitButton(
            key: new Key('A${widget.keys}'),
            text: widget.text,
            disabled: true,
            showHelp: false,
          ));
    }
  }
}
