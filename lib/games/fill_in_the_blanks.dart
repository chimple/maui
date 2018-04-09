import 'package:flutter/material.dart';
import 'package:maui/repos/game_data.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';

class FillInTheBlanks extends StatefulWidget {
  Function onScore;
  Function onProgress;
  Function onEnd;
  int iteration;
  int gameCategoryId;
  bool isRotated;
  FillInTheBlanks(
      {key,
      this.onScore,
      this.onProgress,
      this.onEnd,
      this.iteration,
      this.gameCategoryId,
      this.isRotated = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new FillInTheBlanksState();
}

class FillInTheBlanksState extends State<FillInTheBlanks> {
  var flag1 = 0;
  bool _isLoading = true;
  //[[, a], [p, A], [p, L], [, l], [e, K]]
  static List<String> _table1 = ['', 'P', 'P', '', 'E'];
  static List<String> _table2 = ['A', 'U', 'M', 'L', 'Q'];
  int _size;
  List<String> fillblanks1;
  List<String> fillblanks2;
  List<Tuple2<String, String>> _fillData;
  List<int> _flag = new List();
  @override
  void initState() {
    super.initState();
    _initFillBlanks();
  }

  int count = 0;
  int progres = 0;
  void _initFillBlanks() async {
    count = 0;
    progres = 0;
    setState(() => _isLoading = true);
    _fillData = await fetchWordWithBlanksData(widget.gameCategoryId);
    fillblanks1 = _fillData.map((f) {
      return f.item2;
    }).toList(growable: false);
    fillblanks2 = _fillData.map((f) {
      return f.item1;
    }).toList(growable: false);
    print("fill1 $fillblanks1");
    print("fill2 $fillblanks2");
    setState(() => _isLoading = false);
    _size = fillblanks1.length;
    _flag.length = _table1.length + _size + 1;
    for (var i = 0; i < _flag.length; i++) {
      _flag[i] = 0;
    }
    for (int j = 0; j < fillblanks2.length; j++) {
      if (fillblanks2[j].isNotEmpty) count++;
    }
    count = fillblanks2.length - count;
    print("count is$count");
  }

  @override
  void didUpdateWidget(FillInTheBlanks oldWidget) {
    print(oldWidget.iteration);
    print(widget.iteration);
    if (widget.iteration != oldWidget.iteration) {
      _initFillBlanks();
    }
  }

  Widget _buildItem(int index, String text, int flag) {
    final TextEditingController t1 = new TextEditingController(text: text);
    return new MyButton(
        key: new ValueKey<int>(index),
        index: index,
        text: text,
        color1: 1,
        isRotated: widget.isRotated,
        onAccepted: (targetindex) {
          // print(targetindex);
          // print(fillblanks1);
          // print(fillblanks2);
          if (targetindex == index + 100 && fillblanks2[index] == '') {
            flag1 = 0;
            widget.onScore(2);
            //  print("count in button is $count");
            progres++;
            widget.onProgress(progres / count);
            //print("count decrement is $count");
            fillblanks2[index] = fillblanks1[index];
            print('table 33 $_table1');
          }
          print("outside progress is $progres");
          print("outside count is $count");
          if (progres == count) {
            new Future.delayed(const Duration(milliseconds: 500), () {
              //_initFillBlanks();
              widget.onEnd();
            });
          }
        },
        flag: flag,
        arr: _flag);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    print(media);
    if (_isLoading) {
      return new SizedBox(
        width: 5.0,
        height: 5.0,
        child: new CircularProgressIndicator(),
      );
    }
    List<TableRow> rows = new List<TableRow>();
    List<TableRow> rows1 = new List<TableRow>();
    var j = 0, h = 0;
    for (var i = 0; i < 1; i++) {
      List<Widget> cells = fillblanks2
          // .skip(i*_size)
          .take(_size)
          .map((e) => _buildItem(j++, e, _flag[h++]))
          .toList();

      rows.add(new TableRow(children: cells));
    }
    j = 100;
    for (var i = 0; i < 1; i++) {
      List<Widget> cells = fillblanks1
          //.skip(i*1)
          .take(_size)
          .map((e) => _buildItem(j++, e, _flag[h++]))
          .toList();

      rows1.add(new TableRow(children: cells));
    }
    //final mq = MediaQuery.of(context);
    // final sz = mq.size;
    return new Container(
      padding: new EdgeInsets.all(10.0),
      color: Colors.green[300],
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Table(children: rows),
          new Padding(
            padding: new EdgeInsets.all(60.0),
          ),
          new Table(children: rows1),
        ],
      ),
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
      this.isRotated = false,
      this.arr})
      : super(key: key);
  //  MyButton({Key key, this.text, this.onPress}) : super(key: key);

  var index;
  final int color1;
  final int flag;
  final String text;
  List arr;
  final DragTargetAccept onAccepted;
  bool isRotated;
  // final String text1;

  @override
  _MyButtonState createState() => new _MyButtonState();
}

class _MyButtonState extends State<MyButton> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String _displayText;

  initState() {
    super.initState();
    _displayText = widget.text;
    controller = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addStatusListener((state) {
        //  print("$state:${animation.value}");
        if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }
//  @override
//   void didUpdateWidget(MyButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if ( widget.flag==1) {

//       controller.reverse();

//     }

//   }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < widget.arr.length; i++) {
      widget.arr[i] = 0;
    }
    if (widget.index < 100) {
      return new TableCell(
        child: new Padding(
          padding: const EdgeInsets.all(4.0),
          child: new ScaleTransition(
            scale: animation,
            child: new Container(
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                color: widget.color1 == 1 ? Colors.white : Colors.purple[300],
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
              child: new DragTarget(
                onAccept: (int data) => widget.onAccepted(data),
                builder: (
                  BuildContext context,
                  List<dynamic> accepted,
                  List<dynamic> rejected,
                ) {
                  return new Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(8.0)),
                    ),
                    child: new Center(
                      child: new Text(widget.text,
                          style: new TextStyle(
                              color: Colors.black, fontSize: 24.0)),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else if (widget.index >= 100) {
      var feedbackContainer = new Container(
        height: 60.0,
        width: 60.0,
        decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
            color: Colors.yellow[400]),
        child: new Center(
          child: new Text(
            _displayText,
            style: new TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 26.0,
            ),
          ),
        ),
      );
      return new TableCell(
          child: new Draggable(
              data: widget.index,
              child: new Padding(
                padding: new EdgeInsets.all(8.0),
                child: new ScaleTransition(
                    scale: animation,
                    child: new Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: new BoxDecoration(
                        color: widget.color1 == 1
                            ? Colors.white
                            : Colors.purple[300],
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(8.0)),
                      ),
                      child: new Center(
                        child: new Text(_displayText,
                            style: new TextStyle(
                                color: Colors.black, fontSize: 24.0)),
                      ),
                    )),
              ),
              feedback: widget.isRotated
                  ? new RotatedBox(quarterTurns: 2, child: feedbackContainer)
                  : feedbackContainer));
    }
  }
}
